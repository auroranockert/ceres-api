module Ceres
  class API
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
        require 'digest/sha1'
        
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
