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
  
      def to_s
        @xml.stringValue
      end

      def to_i
        self.to_s.to_i
      end

      def to_f
        self.to_s.to_f
      end

      def to_date
        Time.parse(self.to_s)
      end
    end
    
    class CocoaXMLDocument < CocoaXMLNode
      include Ceres::API::XMLHelper
      
      def self.from_nsxml(xml)
        result = CocoaXMLDocument.new(xml)
        result.errors
        result
      end
  
      def self.from_string(xml)
        error = Pointer.new_with_type('@')
        result = NSXMLDocument.alloc.initWithXMLString(xml, options: 0, error: error)
        error = error[0]

        if error
          raise StandardError, "oh dear... (#{error.description})"
        else
          self.from_nsxml(result)
        end
      end
      
      def self.init
      end
    end
  end
end