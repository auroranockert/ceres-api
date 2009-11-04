#
#  account.rb
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
    def characters
      xml = self.download(Ceres.account_urls[:characters])
      
      characters = xml.readNodes("/eveapi/result/rowset/row").map do |character|
        {
          :id => character.readAttribute("characterID").integerValue,
          :name => character.readAttribute("name").stringValue,
          :corporation_id => character.readAttribute("corporationID").integerValue,
          :corporation_name => character.readAttribute("corporationName").stringValue
        }
      end
      
      return characters, xml.cachedUntil
    end
  end
end