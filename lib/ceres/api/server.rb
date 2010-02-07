#
#  server.rb
#  This file is part of Ceres-API.
#
#  Ceres is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Ceres is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Ceres-API.  If not, see <http://www.gnu.org/licenses/>.
#
#  Created by Jens Nockert on 11/4/09.
#

module Ceres
  class API
    def server_status
      xml = self.download(Ceres.server_urls[:status])
      
      status = {
        :open => (xml.readNode("/eveapi/result/serverOpen").to_s == "True"),
        :players => xml.readNode("/eveapi/result/onlinePlayers").to_i
      }
      
      return status, xml.cachedUntil      
    end
  end
end