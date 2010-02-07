#
#  server.rb
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
#  Created by Jens Nockert on 11/23/09.
#

module Ceres
  class API
    def starbases
      xml = self.download(Ceres.starbase_urls[:list])
      
      starbases = xml.read_nodes("/eveapi/result/rowset/row").map do |starbase|
        {
          :id => starbase.read_attribute("itemID").to_i,
          :type_id => starbase.read_attribute("typeID").to_i,
          :location_id => starbase.read_attribute("locationID").to_s,
          :moon_id => starbase.read_attribute("moonID").to_s,
          :onlined_at => starbase.read_attribute("onlineTimestamp").to_date,
          :state => [:unanchored, :anchored, :onlining, :reinforced, :online][starbase.read_attribute("state").to_i],
          :state / :changed_at => starbase.read_attribute("stateTimestamp").to_date
        }
      end
      
      return starbases, xml.cached_until      
    end
    
    def starbase(identifier)
      xml = self.download(Ceres.starbase_urls[:details], :itemID => identifier.to_s)
      
      starbase = {        
        :state => [:unanchored, :anchored, :onlining, :reinforced, :online][xml.read_node("/eveapi/result/state").to_i],
        :state_changed_at => xml.read_node("/eveapi/result/stateTimestamp").to_date,
        :onlined_at => xml.read_node("/eveapi/result/onlineTimestamp").to_date,
        :settings / :general / :usage => xml.read_node("/eveapi/result/generalSettings/usageFlags").to_i,
        :settings / :general / :deploy => xml.read_node("/eveapi/result/generalSettings/deployFlags").to_i,
        :settings / :general / :allows => [],
        :settings / :combat / :shoots_on => [:low_standing],
        :settings / :combat / :standings => xml.read_node("/eveapi/result/combatSettings/onStandingDrop").read_attribute("standing").to_f,
        :settings / :combat / :status => xml.read_node("/eveapi/result/combatSettings/onStandingDrop").read_attribute("standing").to_f,
        :fuel => { }
      }
      
      starbase[:settings / :general / :allows] << :corporation if xml.read_node("/eveapi/result/generalSettings/allowCorporationMembers").to_i == 1
      starbase[:settings / :general / :allows] << :alliance if xml.read_node("/eveapi/result/generalSettings/allowAllianceMembers").to_i == 1
      
      starbase[:settings / :combat / :shoots_on] << :aggression if xml.read_node("/eveapi/result/combatSettings/onAggression").read_attribute("enabled").to_i == 1
      starbase[:settings / :combat / :shoots_on] << :low_status if xml.read_node("/eveapi/result/combatSettings/onStatusDrop").read_attribute("enabled").to_i == 1
      starbase[:settings / :combat / :shoots_on] << :war_target if xml.read_node("/eveapi/result/combatSettings/onCorporationWar").read_attribute("enabled").to_i == 1
      
      xml.read_nodes("/eveapi/result/rowset/row").each do |fuel|
        starbase[:fuel][fuel.read_attribute("typeID").to_i] = fuel.read_attribute("quantity").to_i
      end
      
      return starbase, xml.cached_until
    end
  end
end