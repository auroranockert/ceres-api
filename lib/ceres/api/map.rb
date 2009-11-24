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
          :id => station.readAttribute("stationID").integerValue,
          :name => station.readAttribute("stationName").stringValue,
          :type_id => station.readAttribute("stationTypeID").integerValue,
          :solar_system_id => station.readAttribute("solarSystemID").integerValue,
          :corporation_id => station.readAttribute("corporationID").integerValue,
          :corporation_name => station.readAttribute("corporationName").stringValue
        }
      end
      
      return stations, xml.cachedUntil
    end
    
    def jumps
      xml = self.download(Ceres.map_urls[:jumps])
      
      systems = xml.readNodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.readAttribute("solarSystemID").integerValue,
          :jumps => system.readAttribute("shipJumps").integerValue
        }
      end
      
      return systems, xml.cachedUntil
    end
    
    def kills
      xml = self.download(Ceres.map_urls[:kills])
      
      systems = xml.readNodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.readAttribute("solarSystemID").integerValue,
          :ship_kills => system.readAttribute("shipKills").integerValue,
          :faction_kills => system.readAttribute("factionKills").integerValue,
          :pod_kills => system.readAttribute("podKills").integerValue
        }
      end
      
      return systems, xml.cachedUntil
    end

    def sovereignty
      xml = self.download(Ceres.map_urls[:sovereignty])

      systems = xml.readNodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.readAttribute("solarSystemID").integerValue,
          :name => system.readAttribute("solarSystemName").integerValue,
          :alliance_id => system.readAttribute("allianceID").integerValue,
          :faction_id => system.readAttribute("factionID").integerValue,
          :sovereignty_level => system.readAttribute("sovereigntyLevel").integerValue,
          :constellation_sovereignty => (system.readAttribute("constellationSovereignty").integerValue != 0)
        }
      end

      return systems, xml.cachedUntil
    end
  end
end