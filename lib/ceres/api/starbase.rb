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
      
      starbases = xml.readNodes("/eveapi/result/rowset/row").map do |starbase|
        {
          :id => starbase.readAttribute("itemID").integerValue,
          :type_id => starbase.readAttribute("typeID").integerValue,
          :location_id => starbase.readAttribute("locationID").stringValue,
          :moon_id => starbase.readAttribute("moonID").stringValue,
          :onlined_at => starbase.readAttribute("onlineTimestamp").dateValue,
          :state => [:unanchored, :anchored, :onlining, :reinforced, :online][starbase.readAttribute("state").integerValue],
          :state / :changed_at => starbase.readAttribute("stateTimestamp").dateValue
        }
      end
      
      return starbases, xml.cachedUntil      
    end
    
    def starbase(identifier)
      xml = self.download(Ceres.starbase_urls[:details], itemID: identifier.to_s)
      
      starbase = {        
        :state => [:unanchored, :anchored, :onlining, :reinforced, :online][xml.readNode("/eveapi/result/state").integerValue],
        :state_changed_at => xml.readNode("/eveapi/result/stateTimestamp").dateValue,
        :onlined_at => xml.readNode("/eveapi/result/onlineTimestamp").dateValue,
        :settings / :general / :usage => xml.readNode("/eveapi/result/generalSettings/usageFlags").integerValue,
        :settings / :general / :deploy => xml.readNode("/eveapi/result/generalSettings/deployFlags").integerValue,
        :settings / :general / :allows => [],
        :settings / :combat / :shoots_on => [:low_standing],
        :settings / :combat / :standings => xml.readNode("/eveapi/result/combatSettings/onStandingDrop").readAttribute("standing").floatValue,
        :settings / :combat / :status => xml.readNode("/eveapi/result/combatSettings/onStandingDrop").readAttribute("standing").floatValue,
        :fuel => { }
      }
      
      starbase[:settings / :general / :allows] << :corporation if xml.readNode("/eveapi/result/generalSettings/allowCorporationMembers").integerValue == 1
      starbase[:settings / :general / :allows] << :alliance if xml.readNode("/eveapi/result/generalSettings/allowAllianceMembers").integerValue == 1
      
      starbase[:settings / :combat / :shoots_on] << :aggression if xml.readNode("/eveapi/result/combatSettings/onAggression").readAttribute("enabled").integerValue == 1
      starbase[:settings / :combat / :shoots_on] << :low_status if xml.readNode("/eveapi/result/combatSettings/onStatusDrop").readAttribute("enabled").integerValue == 1
      starbase[:settings / :combat / :shoots_on] << :war_target if xml.readNode("/eveapi/result/combatSettings/onCorporationWar").readAttribute("enabled").integerValue == 1
      
      xml.readNodes("/eveapi/result/rowset/row").each do |fuel|
        starbase[:fuel][fuel.readAttribute("typeID").integerValue] = fuel.readAttribute("quantity").integerValue
      end
      
      return starbase, xml.cachedUntil
    end
  end
end