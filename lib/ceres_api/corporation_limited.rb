#
#  corporation_limited.rb
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
    def corporation_sheet(corporation_id = nil)
      xml = self.download(Ceres.corporation_urls[:sheet], corporation_id ? { :corporationID => corporation_id } : {})
      
      sheet = {
        :id => xml.readNode("/eveapi/result/corporationID").integerValue,
        :name => xml.readNode("/eveapi/result/corporationName").stringValue,
        :ticker => xml.readNode("/eveapi/result/ticker").stringValue,
        :ceo_id => xml.readNode("/eveapi/result/ceoID").integerValue,
        :ceo_name => xml.readNode("/eveapi/result/ceoName").stringValue,
        :station_id => xml.readNode("/eveapi/result/stationID").integerValue,
        :station_name => xml.readNode("/eveapi/result/stationName").stringValue,
        :description => xml.readNode("/eveapi/result/description").stringValue,
        :url => xml.readNode("/eveapi/result/url").stringValue,
        :alliance_id => xml.readNode("/eveapi/result/allianceID").integerValue,
        :alliance_name => xml.readNode("/eveapi/result/allianceName").stringValue,
        :tax => xml.readNode("/eveapi/result/taxRate").floatValue,
        :member_count => xml.readNode("/eveapi/result/memberCount").integerValue,
        :shares => xml.readNode("/eveapi/result/shares").integerValue,
        
        :logo => {
          :graphic_id => xml.readNode("/eveapi/result/logo/graphicID").integerValue,
          :shape => [
            xml.readNode("/eveapi/result/logo/shape1").integerValue,
            xml.readNode("/eveapi/result/logo/shape2").integerValue,
            xml.readNode("/eveapi/result/logo/shape3").integerValue
          ],
          :colour => [
            xml.readNode("/eveapi/result/logo/color1").integerValue,
            xml.readNode("/eveapi/result/logo/color2").integerValue,
            xml.readNode("/eveapi/result/logo/color3").integerValue
          ]
        }
      }
      
      unless corporation_id
        sheet[:member_limit] = xml.readNode("/eveapi/result/memberLimit").integerValue
        
        divisions = []
        xml.readNodes("/eveapi/result/rowset[@name='divisions']/row").each do |division|
          divisions[division.readAttribute("accountKey").integerValue % 10] = division.readAttribute("description").stringValue
        end
        sheet[:divisions] = divisions
        
        wallet_divisions = []
        xml.readNodes("/eveapi/result/rowset[@name='walletDivisions']/row").each do |division|
          wallet_divisions[division.readAttribute("accountKey").integerValue % 10] = division.readAttribute("description").stringValue
        end
        sheet[:wallet_divisions] = wallet_divisions
      end
      
      return sheet, xml.cachedUntil
    end
    
    def corporation_medals
      xml = self.download(Ceres.corporation_urls[:medals])
      
      medals = xml.readNodes("/eveapi/result/rowset/row").map do |medal|
        {
          :id => medal.readAttribute("medalID").integerValue,
          :title => medal.readAttribute("title").stringValue,
          :description => medal.readAttribute("description").stringValue,
          :creator_id => medal.readAttribute("creatorID").integerValue,
          :created_at => medal.readAttribute("created").dateValue
        }
      end
      
      return medals, xml.cachedUntil
    end
    
    def corporation_medals_issued
      xml = self.download(Ceres.corporation_urls[:medals_issued])
      
      medals = xml.readNodes("/eveapi/result/rowset/row").map do |medal|
        {
          :id => medal.readAttribute("medalID").integerValue,
          :character_id => medal.readAttribute("characterID").integerValue,
          :reason => medal.readAttribute("reason").stringValue,
          :status => medal.readAttribute("status").stringValue,
          :issuer_id => medal.readAttribute("issuerID").integerValue,
          :issued_at => medal.readAttribute("issued").dateValue
        }
      end
      
      return medals, xml.cachedUntil
    end
  end
end