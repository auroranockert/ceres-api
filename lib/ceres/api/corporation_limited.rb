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
        :id => xml.read_node("/eveapi/result/corporationID").to_i,
        :name => xml.read_node("/eveapi/result/corporationName").to_s,
        :ticker => xml.read_node("/eveapi/result/ticker").to_s,
        :ceo / :id => xml.read_node("/eveapi/result/ceoID").to_i,
        :ceo / :name => xml.read_node("/eveapi/result/ceoName").to_s,
        :station / :id => xml.read_node("/eveapi/result/stationID").to_i,
        :station / :name => xml.read_node("/eveapi/result/stationName").to_s,
        :description => xml.read_node("/eveapi/result/description").to_s,
        :url => xml.read_node("/eveapi/result/url").to_s,
        :alliance / :id => xml.read_node("/eveapi/result/allianceID").to_i,
        :alliance / :name => xml.read_node("/eveapi/result/allianceName").to_s,
        :tax => xml.read_node("/eveapi/result/taxRate").to_f,
        :member_count => xml.read_node("/eveapi/result/memberCount").to_i,
        :shares => xml.read_node("/eveapi/result/shares").to_i,
        
        :logo / :graphic_id => xml.read_node("/eveapi/result/logo/graphicID").to_i,
        :logo / :shape => [
          xml.read_node("/eveapi/result/logo/shape1").to_i,
          xml.read_node("/eveapi/result/logo/shape2").to_i,
          xml.read_node("/eveapi/result/logo/shape3").to_i
        ],
        :logo / :colour => [
          xml.read_node("/eveapi/result/logo/color1").to_i,
          xml.read_node("/eveapi/result/logo/color2").to_i,
          xml.read_node("/eveapi/result/logo/color3").to_i
        ]
      }
      
      unless corporation_id
        sheet[:member_limit] = xml.read_node("/eveapi/result/memberLimit").to_i
        
        divisions = []
        xml.read_nodes("/eveapi/result/rowset[@name='divisions']/row").each do |division|
          divisions[division.read_attribute("accountKey").to_i % 10] = division.read_attribute("description").to_s
        end
        sheet[:divisions] = divisions
        
        wallet_divisions = []
        xml.read_nodes("/eveapi/result/rowset[@name='walletDivisions']/row").each do |division|
          wallet_divisions[division.read_attribute("accountKey").to_i % 10] = division.read_attribute("description").to_s
        end
        sheet[:wallet_divisions] = wallet_divisions
      end
      
      return sheet, xml.cached_until
    end
    
    def corporation_medals
      xml = self.download(Ceres.corporation_urls[:medals])
      
      medals = xml.read_nodes("/eveapi/result/rowset/row").map do |medal|
        {
          :id => medal.read_attribute("medalID").to_i,
          :title => medal.read_attribute("title").to_s,
          :description => medal.read_attribute("description").to_s,
          :creator_id => medal.read_attribute("creatorID").to_i,
          :created_at => medal.read_attribute("created").to_date
        }
      end
      
      return medals, xml.cached_until
    end
    
    def corporation_medals_issued
      xml = self.download(Ceres.corporation_urls[:medals_issued])
      
      medals = xml.read_nodes("/eveapi/result/rowset/row").map do |medal|
        {
          :id => medal.read_attribute("medalID").to_i,
          :character_id => medal.read_attribute("characterID").to_i,
          :reason => medal.read_attribute("reason").to_s,
          :status => medal.read_attribute("status").to_s,
          :issuer_id => medal.read_attribute("issuerID").to_i,
          :issued_at => medal.read_attribute("issued").to_date
        }
      end
      
      return medals, xml.cached_until
    end
  end
end