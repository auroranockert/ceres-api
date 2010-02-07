#
#  fw.rb
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
    def faction_warfare_statistics
      xml = self.download(Ceres.faction_warfare_urls[:statistics])
      
      result = {
        :totals / :kills / :yesterday => xml.read_node("/eveapi/result/totals/killsYesterday").to_i,
        :totals / :kills / :last_week => xml.read_node("/eveapi/result/totals/killsLastWeek").to_i,
        :totals / :kills / :total => xml.read_node("/eveapi/result/totals/killsTotal").to_i,
          
        :totals / :victory_points / :yesterday => xml.read_node("/eveapi/result/totals/victoryPointsYesterday").to_i,
        :totals / :victory_points / :last_week => xml.read_node("/eveapi/result/totals/victoryPointsLastWeek").to_i,
        :totals / :victory_points / :total => xml.read_node("/eveapi/result/totals/victoryPointsTotal").to_i,
        
        :wars => xml.read_nodes("/eveapi/result/rowset[@name='factionWars']/row").map do |war|
          {
            :id => war.read_attribute("factionID").to_i,
            :name => war.read_attribute("factionName").to_s,
            :against / :id => war.read_attribute("againstID").to_i,
            :against / :name => war.read_attribute("againstName").to_s
          }
        end
      }
      
      [
        [500001, :factions / :caldari],
        [500002, :factions / :minmatar],
        [500003, :factions / :amarr],
        [500004, :factions / :gallente]
      ].each do |faction_id, faction_symbol|
        faction = xml.read_node("/eveapi/result/rowset[@name='factions']/row[@factionID='#{faction_id}']")

        hash[faction_symbol / :id] = faction.read_attribute("factionID").to_i
        hash[faction_symbol / :name] = faction.read_attribute("factionName").to_s
        hash[faction_symbol / :pilots] = faction.read_attribute("pilots").to_i
        hash[faction_symbol / :systems_controlled] = faction.read_attribute("systemsControlled").to_i
             
        hash[faction_symbol / :kills / :yesterday] = faction.read_attribute("killsYesterday").to_i
        hash[faction_symbol / :kills / :last_week] = faction.read_attribute("killsLastWeek").to_i
        hash[faction_symbol / :kills / :total] = faction.read_attribute("killsTotal").to_i
             
        hash[faction_symbol / :victory_points / :yesterday] = faction.read_attribute("victoryPointsYesterday").to_i
        hash[faction_symbol / :victory_points / :last_week] = faction.read_attribute("victoryPointsLastWeek").to_i
        hash[faction_symbol / :victory_points / :total] = faction.read_attribute("victoryPointsTotal").to_i
      end
      
      return result, xml.cached_until
    end
    
    def faction_warfare_top_100
      xml = self.download(Ceres.faction_warfare_urls[:top_100])
      
      def parse_stats(xml, path, type)
        xml.findNodes(path).map do |character|
          hash = {
            :id => character.read_attribute("characterID").to_i,
            :name => character.read_attribute("characterName").to_s
          }

          case type
          when :kills
            hash[:kills] = character.read_attribute("kills").to_i
          when :victory_points
            hash[:victory_points] = character.read_attribute("victoryPoints")
          end
        end
      end
      
      result = {
        :characters / :kills / :yesterday => parse_stats(xml, "/eveapi/result/characters/rowset[@name='KillsYesterday']/row", :kills),
        :characters / :kills / :last_week => parse_stats(xml, "/eveapi/result/characters/rowset[@name='KillsLastWeek']/row", :kills),
        :characters / :kills / :total => parse_stats(xml, "/eveapi/result/characters/rowset[@name='KillsTotal']/row", :kills),
          
        :characters / :victory_points / :yesterday => parse_stats(xml, "/eveapi/result/characters/rowset[@name='VictoryPointsYesterday']/row", :victory_points),
        :characters / :victory_points / :last_week => parse_stats(xml, "/eveapi/result/characters/rowset[@name='VictoryPointsLastWeek']/row", :victory_points),
        :characters / :victory_points / :total => parse_stats(xml, "/eveapi/result/characters/rowset[@name='VictoryPointsTotal']/row", :victory_points),
        
        :corporations / :kills / :yesterday => parse_stats(xml, "/eveapi/result/corporations/rowset[@name='KillsYesterday']/row", :kills),
        :corporations / :kills / :last_week => parse_stats(xml, "/eveapi/result/corporations/rowset[@name='KillsLastWeek']/row", :kills),
        :corporations / :kills / :total => parse_stats(xml, "/eveapi/result/corporations/rowset[@name='KillsTotal']/row", :kills),

        :corporations / :victory_points / :yesterday => parse_stats(xml, "/eveapi/result/corporations/rowset[@name='VictoryPointsYesterday']/row", :victory_points),
        :corporations / :victory_points / :last_week => parse_stats(xml, "/eveapi/result/corporations/rowset[@name='VictoryPointsLastWeek']/row", :victory_points),
        :corporations / :victory_points / :total => parse_stats(xml, "/eveapi/result/corporations/rowset[@name='VictoryPointsTotal']/row", :victory_points),
        
        :factions / :kills / :yesterday => parse_stats(xml, "/eveapi/result/factions/rowset[@name='KillsYesterday']/row", :kills),
        :factions / :kills / :last_week => parse_stats(xml, "/eveapi/result/factions/rowset[@name='KillsLastWeek']/row", :kills),
        :factions / :kills / :total => parse_stats(xml, "/eveapi/result/factions/rowset[@name='KillsTotal']/row", :kills),

        :factions / :victory_points / :yesterday => parse_stats(xml, "/eveapi/result/factions/rowset[@name='VictoryPointsYesterday']/row", :victory_points),
        :factions / :victory_points / :last_week => parse_stats(xml, "/eveapi/result/factions/rowset[@name='VictoryPointsLastWeek']/row", :victory_points),
        :factions / :victory_points / :total => parse_stats(xml, "/eveapi/result/factions/rowset[@name='VictoryPointsTotal']/row", :victory_points)
      }
      
      return result, xml.cached_until
      
    end
    
    def occupancy
      xml = self.download(Ceres.faction_warfare_urls[:occupancy])
      
      systems = xml.read_nodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.read_attribute("solarSystemID").to_i,
          :name => system.read_attribute("solarSystemName").to_s,
          :contested => (system.read_attribute("contested").to_s == "True"),
          
          :faction / :id => system.read_attribute("occupyingFactionID").to_i,
          :faction / :name => system.read_attribute("occupyingFactionName").to_s
        }
      end
      
      return systems, xml.cached_until
    end
  end
end