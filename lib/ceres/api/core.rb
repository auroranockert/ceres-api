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

framework 'cocoa'

require 'cgi'

require 'ceres/support'

require 'ceres/api/exceptions'
require 'ceres/api/extensions'
require 'ceres/api/urls'

require 'digest/sha1'

module Ceres
  class API
    def self.downloader=(downloader = :remote)
      downloader.init
      @downloader = downloader
    end
    
    def self.downloader
      @downloader ||= CocoaDownloader
    end
    
    def initialize(settings = {})
      @settings = settings
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
        else
          key
        end
      
        "#{key.to_s}=#{CGI.escape(value.to_s)}"
      end.join("&")
    
      if attributes != ""
        url += "?#{attributes}"
      end
      
      Ceres::API.downloader.download(url)
    end
    
    module RubyDownloader
      def self.init
        require 'open-uri'
      end
      
      def self.download(url)
        error = Pointer.new_with_type('@')

        result = NSXMLDocument.alloc.initWithXMLString(open(url).read, options: 0, error: error)

        error = error[0]

        if error
          raise StandardError, "oh dear... (#{error.description})"
        else
          result.checkForErrors
          result
        end
      end
    end
    
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
          result.checkForErrors
          result
        end
      end
    end
    
    module LocalDownloader
      def self.init
        require 'fileutils'
        
        FileUtils.mkdir_p 'xml'
      end
      
      def self.download(url)
        url, error = NSURL.fileURLWithPath('./xml/' + Digest::SHA1.hexdigest(url) + '.xml'), Pointer.new_with_type('@')
        
        result = NSXMLDocument.alloc.initWithContentsOfURL(url, options: 0, error: error)

        error = error[0]
        
        if error
          raise StandardError, "oh dear... (#{error.description})"
        else
          result.checkForErrors
          result
        end
      end
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