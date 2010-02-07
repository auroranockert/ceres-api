module Ceres
  module XMLDocument
    def self.from_string(xml)
      if Object.name == "NSObject"
        error = Pointer.new_with_type('@')

        result = NSXMLDocument.alloc.initWithXMLString(open(url).read, options: 0, error: error)

        error = error[0]

        if error
          raise StandardError, "oh dear... (#{error.description})"
        else
          result.errors
          CocoaXMLDocument.new(result)
        end
      else
        raise Exception, "Can only run Ceres under MacRuby."
      end
    end
    
    def self.from_nsxml(xml)
      CocoaXMLDocument.new(xml)
    end
  end
  
  class CocoaXMLDocument
    def initialize(xml)
      @xml = xml
    end
    
    def read_nodes(xpath)
      error = Pointer.new_with_type('@')
      result = @xml.nodesForXPath(xpath, error: error)

      error = error[0]

      if error
        raise StandardError, "oh dear... (#{error.description})"
      else
        result.map { |x| CocoaXMLNode.new(x) }
      end
    end

    def read_node(xpath)
      self.read_nodes(xpath)[0]
    end

    def cachedUntil
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
  
  class CocoaXMLNode
    def initialize(xml)
      @xml = xml
    end
    
    def read_nodes(xpath)
      error = Pointer.new_with_type('@')
      result = @xml.nodesForXPath(xpath, error: error)

      error = error[0]

      if error
        raise StandardError, "oh dear... (#{error.description})"
      else
        result.map { |x| CocoaXMLNode.new(x) }
      end
    end

    def read_node(xpath)
      self.read_nodes(xpath)[0]
    end

    def read_attribute(attribute)
      self.read_node("@#{attribute}")
    end

    def to_i
      @xml.stringValue.to_i
    end

    def to_f
      @xml.stringValue.to_f
    end

    def to_date
      Time.at(NSDate.alloc.initWithString(self.to_s + " +0000").timeIntervalSince1970) # TODO: Get Time.parse to work in MacRuby
    end
  end
end