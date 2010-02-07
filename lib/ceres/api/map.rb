#
#  map.rb
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
    def conquerable_stations
      xml = self.download(Ceres.map_urls[:conquerable_stations])
      
      stations = xml.readNodes("/eveapi/result/rowset/row").map do |station|
        {
          :id => station.readAttribute("stationID").to_i,
          :type_id => station.readAttribute("stationTypeID").to_i,
          :name => station.readAttribute("stationName").to_s,
          :solar_system_id => station.readAttribute("solarSystemID").to_i,
          :corporation / :id => station.readAttribute("corporationID").to_i,
          :corporation / :name => station.readAttribute("corporationName").to_s
        }
      end
      
      return stations, xml.cachedUntil
    end
    
    def jumps
      xml = self.download(Ceres.map_urls[:jumps])
      
      systems = xml.readNodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.readAttribute("solarSystemID").to_i,
          :jumps => system.readAttribute("shipJumps").to_i
        }
      end
      
      return systems, xml.cachedUntil
    end
    
    def kills
      xml = self.download(Ceres.map_urls[:kills])
      
      systems = xml.readNodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.readAttribute("solarSystemID").to_i,
          :kills / :ship => system.readAttribute("shipKills").to_i,
          :kills / :faction => system.readAttribute("factionKills").to_i,
          :kills / :pod => system.readAttribute("podKills").to_i
        }
      end
      
      return systems, xml.cachedUntil
    end

    def sovereignty
      xml = self.download(Ceres.map_urls[:sovereignty])
      
      systems = xml.readNodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.readAttribute("solarSystemID").to_i,
          :name => system.readAttribute("solarSystemName").to_s,
          :corporation_id => system.readAttribute("corporationID").to_i,
          :alliance_id => system.readAttribute("allianceID").to_i,
          :faction_id => system.readAttribute("factionID").to_i
        }
      end

      return systems, xml.cachedUntil
    end
  end
end