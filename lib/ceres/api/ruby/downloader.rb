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
  module API
    module RubyDownloader
      def self.init
        require 'open-uri'
      end
  
      def self.download(url)
        Ceres::XMLDocument.from_string(open(url).read)
      end
    end

    module LocalDownloader
      def self.init
        require 'fileutils'
        require 'digest/sha1'
    
        FileUtils.mkdir_p 'xml'
      end
  
      def self.download(url)
        File.open('./xml/' + Digest::SHA1.hexdigest(url) + '.xml') do |f|
          result = Ceres::XMLDocument.from_string(f.read)
        end
    
        result
      end
    end
  end
end
