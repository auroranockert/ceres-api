#  xml.rb
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
#  Created by Jens Nockert on 7/2/10.
#

module Ceres
  class API
    module XMLHelper
      def cached_until
        current_time = self.read_node("/eveapi/currentTime").to_date
        cached_until = self.read_node("/eveapi/cachedUntil").to_date

        Time.now + (cached_until - current_time)
      end

      def errors
        error = self.read_node("/eveapi/error")

        if error
          code = error.read_attribute("code").to_i
          message = "EVE API Error (##{code.to_s}): #{error.to_s}"

          case code
          when 100
            raise Ceres::WalletNotPreviouslyLoadedError, message
          when 101, 103
            raise Ceres::WalletExhaustedError, message
          when 102
            raise Ceres::WalletPreviouslyLoadedError, message
          when 105 .. 111, 114, 121 .. 123
            raise Ceres::InvalidIdentifierError, message
          when 112, 113
            raise Ceres::VersionError, message
          when 115 .. 117
            raise Ceres::AlreadyDownloadedError, message
          when 118
            raise Ceres::KillsNotPreviouslyLoadedError, message
          when 119
            raise Ceres::KillsExhaustedError, message
          when 120
            raise Ceres::KillsPreviouslyLoadedError, message
          when 124, 125
            raise Ceres::NotEnlistedInFactionalWarfareError, message
          when 200, 206, 208, 209, 213
            raise Ceres::AuthorizationError, message
          when 201 .. 205, 210 .. 212
            raise Ceres::AuthenticationError, message
          when 207, 214
            raise Ceres::AllianceOrCorporationError, message
          when 500 .. 525
            raise Ceres::ServerError, message
          when 901, 902
            raise Ceres::APITemporarilyDisabledError, message
          when 903
            raise Ceres::RateLimitedError, message
          else
            raise Exception, "Oh dear, unidentified flying exception (UFE) detected, call SETI quick!"
          end
        else
          nil
        end
      end
    end
  end
end

if Object.name == "NSObject"
  require 'ceres/api/cocoa/xml'
end

begin
  require 'nokogiri'
  require 'ceres/api/ruby/xml'
rescue
end