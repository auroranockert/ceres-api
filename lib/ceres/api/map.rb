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
      
      stations = xml.read_nodes("/eveapi/result/rowset/row").map do |station|
        {
          :id => station.read_attribute("stationID").to_i,
          :type_id => station.read_attribute("stationTypeID").to_i,
          :name => station.read_attribute("stationName").to_s,
          :solar_system_id => station.read_attribute("solarSystemID").to_i,
          :corporation / :id => station.read_attribute("corporationID").to_i,
          :corporation / :name => station.read_attribute("corporationName").to_s
        }
      end
      
      return stations, xml.cached_until
    end
    
    def jumps
      xml = self.download(Ceres.map_urls[:jumps])
      
      systems = xml.read_nodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.read_attribute("solarSystemID").to_i,
          :jumps => system.read_attribute("shipJumps").to_i
        }
      end
      
      return systems, xml.cached_until
    end
    
    def kills
      xml = self.download(Ceres.map_urls[:kills])
      
      systems = xml.read_nodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.read_attribute("solarSystemID").to_i,
          :kills / :ship => system.read_attribute("shipKills").to_i,
          :kills / :faction => system.read_attribute("factionKills").to_i,
          :kills / :pod => system.read_attribute("podKills").to_i
        }
      end
      
      return systems, xml.cached_until
    end

    def sovereignty
      xml = self.download(Ceres.map_urls[:sovereignty])
      
      systems = xml.read_nodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.read_attribute("solarSystemID").to_i,
          :name => system.read_attribute("solarSystemName").to_s,
          :corporation_id => system.read_attribute("corporationID").to_i,
          :alliance_id => system.read_attribute("allianceID").to_i,
          :faction_id => system.read_attribute("factionID").to_i
        }
      end

      return systems, xml.cached_until
    end
  end
end