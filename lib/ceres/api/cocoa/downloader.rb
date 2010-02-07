#  downloader.rb
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
#  Created by Jens Nockert on 6/2/10.
#

module Ceres
  class API
    module CocoaDownloader
      def self.init

      end

      def self.download(url)
        url, error = NSURL.URLWithString(url), Pointer.new_with_type('@')

        result = NSXMLDocument.alloc.initWithContentsOfURL(url, options: 0, error: error)

        error = error[0]

        if error
          raise StandardError, "oh dear... (#{error.description})"
        else
          Ceres::XMLDocument.from_nsxml(result)
        end
      end
    end
  end
end