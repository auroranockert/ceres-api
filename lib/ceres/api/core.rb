#
#  core.rb
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

if Object.name == "NSObject"
  framework 'cocoa'
end

require 'cgi'
require 'time'

require 'ceres/support'

require 'ceres/api/downloaders'
require 'ceres/api/xml'

require 'ceres/api/exceptions'
require 'ceres/api/extensions'
require 'ceres/api/urls'

module Ceres
  class API
    def self.downloader=(downloader)
      downloader.init
      @downloader = downloader
    end
    
    def self.downloader
      @downloader ||= (Object.name == "NSObject" ? (CocoaDownloader.init; CocoaDownloader) : (RubyDownloader.init; RubyDownloader))
    end
    
    def self.xml_parser=(parser)
      parser.init
      @parser = parser
    end
    
    def self.parser
      @parser ||= (Object.name == "NSObject" ? (CocoaXMLDocument.init; CocoaDownloader) : (NokogiriXMLDocument.init; NokogiriXMLDocument))
    end
    
    def initialize(settings = {})
      @settings = settings
      
      if settings[:base_url]
        @base_url = settings[:base_url]
      else
        @base_url = Ceres.base_url
      end
    end
    
    def download(url, settings = {})
      url = url.to_s
    
      attributes = @settings.merge(settings).map do |key, value|
        key = case key
        when :user_id
          :userID
        when :api_key
          :apiKey
        when :character_id
          :characterID
        when :itemID, :beforeRefID, :ids, :names
          key
        end
      
        "#{key.to_s}=#{CGI.escape(value.to_s)}" if key
      end.join("&")
    
      if attributes != ""
        url += "?#{attributes}"
      end
      
      Ceres::API.downloader.download(@base_url + url)
    end
  end
end

require 'ceres/api/account'
require 'ceres/api/character_full'
require 'ceres/api/character_limited'
require 'ceres/api/corporation_full'
require 'ceres/api/corporation_limited'
require 'ceres/api/fw'
require 'ceres/api/map'
require 'ceres/api/misc'
require 'ceres/api/server'
require 'ceres/api/starbase'