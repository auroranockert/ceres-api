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
        :id => xml.readNode("/eveapi/result/corporationID").to_i,
        :name => xml.readNode("/eveapi/result/corporationName").to_s,
        :ticker => xml.readNode("/eveapi/result/ticker").to_s,
        :ceo / :id => xml.readNode("/eveapi/result/ceoID").to_i,
        :ceo / :name => xml.readNode("/eveapi/result/ceoName").to_s,
        :station / :id => xml.readNode("/eveapi/result/stationID").to_i,
        :station / :name => xml.readNode("/eveapi/result/stationName").to_s,
        :description => xml.readNode("/eveapi/result/description").to_s,
        :url => xml.readNode("/eveapi/result/url").to_s,
        :alliance / :id => xml.readNode("/eveapi/result/allianceID").to_i,
        :alliance / :name => xml.readNode("/eveapi/result/allianceName").to_s,
        :tax => xml.readNode("/eveapi/result/taxRate").floatValue,
        :member_count => xml.readNode("/eveapi/result/memberCount").to_i,
        :shares => xml.readNode("/eveapi/result/shares").to_i,
        
        :logo / :graphic_id => xml.readNode("/eveapi/result/logo/graphicID").to_i,
        :logo / :shape => [
          xml.readNode("/eveapi/result/logo/shape1").to_i,
          xml.readNode("/eveapi/result/logo/shape2").to_i,
          xml.readNode("/eveapi/result/logo/shape3").to_i
        ],
        :logo / :colour => [
          xml.readNode("/eveapi/result/logo/color1").to_i,
          xml.readNode("/eveapi/result/logo/color2").to_i,
          xml.readNode("/eveapi/result/logo/color3").to_i
        ]
      }
      
      unless corporation_id
        sheet[:member_limit] = xml.readNode("/eveapi/result/memberLimit").to_i
        
        divisions = []
        xml.readNodes("/eveapi/result/rowset[@name='divisions']/row").each do |division|
          divisions[division.readAttribute("accountKey").to_i % 10] = division.readAttribute("description").to_s
        end
        sheet[:divisions] = divisions
        
        wallet_divisions = []
        xml.readNodes("/eveapi/result/rowset[@name='walletDivisions']/row").each do |division|
          wallet_divisions[division.readAttribute("accountKey").to_i % 10] = division.readAttribute("description").to_s
        end
        sheet[:wallet_divisions] = wallet_divisions
      end
      
      return sheet, xml.cachedUntil
    end
    
    def corporation_medals
      xml = self.download(Ceres.corporation_urls[:medals])
      
      medals = xml.readNodes("/eveapi/result/rowset/row").map do |medal|
        {
          :id => medal.readAttribute("medalID").to_i,
          :title => medal.readAttribute("title").to_s,
          :description => medal.readAttribute("description").to_s,
          :creator_id => medal.readAttribute("creatorID").to_i,
          :created_at => medal.readAttribute("created").to_date
        }
      end
      
      return medals, xml.cachedUntil
    end
    
    def corporation_medals_issued
      xml = self.download(Ceres.corporation_urls[:medals_issued])
      
      medals = xml.readNodes("/eveapi/result/rowset/row").map do |medal|
        {
          :id => medal.readAttribute("medalID").to_i,
          :character_id => medal.readAttribute("characterID").to_i,
          :reason => medal.readAttribute("reason").to_s,
          :status => medal.readAttribute("status").to_s,
          :issuer_id => medal.readAttribute("issuerID").to_i,
          :issued_at => medal.readAttribute("issued").to_date
        }
      end
      
      return medals, xml.cachedUntil
    end
  end
end