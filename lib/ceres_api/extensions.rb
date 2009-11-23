#
#  extensions.rb
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

class NSMutableString
  def url_escape
    self.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end

  def url_unescape
    self.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n) do
      [$1.delete('%')].pack('H*')
    end
  end
end

class NSXMLDocument
  def readNodes(xpath)
    error = Pointer.new_with_type('@')
    result = self.nodesForXPath(xpath, error: error)
    
    error = error[0]
    
    if error
      raise StandardError, "oh dear... (#{error.description})"
    else
      result
    end
  end

  def readNode(xpath)
    self.readNodes(xpath)[0]
  end

  def cachedUntil
    currentTime = self.readNode("/eveapi/currentTime").dateValue
    cachedUntil = self.readNode("/eveapi/cachedUntil").dateValue

    NSDate.alloc.initWithTimeIntervalSinceNow(cachedUntil.timeIntervalSinceDate(currentTime))
  end

  def checkForErrors
    error = self.readNode("/eveapi/error")

    if error
      code = error.readAttribute("code").integerValue
      message = "EVE API Error (##{code.to_s}): #{error.stringValue}"

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

class NSXMLNode
  def readNodes(xpath)
    error = Pointer.new_with_type('@')
    result = self.nodesForXPath(xpath, error: error)
    
    error = error[0]
    
    if error
      raise StandardError, "oh dear... (#{error.description})"
    else
      result
    end
  end

  def readNode(xpath)
    self.readNodes(xpath)[0]
  end

  def readAttribute(attribute)
    self.readNode("@#{attribute}")
  end

  def integerValue
    self.stringValue.to_i
  end

  def floatValue
    self.stringValue.to_f
  end
  
  def dateValue
    NSDate.alloc.initWithString(self.stringValue + " +0000")
  end
end
