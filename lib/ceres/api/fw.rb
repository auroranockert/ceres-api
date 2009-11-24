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
        :totals / :kills / :yesterday => xml.readNode("/eveapi/result/totals/killsYesterday").integerValue,
        :totals / :kills / :last_week => xml.readNode("/eveapi/result/totals/killsLastWeek").integerValue,
        :totals / :kills / :total => xml.readNode("/eveapi/result/totals/killsTotal").integerValue,
          
        :totals / :victory_points / :yesterday => xml.readNode("/eveapi/result/totals/victoryPointsYesterday").integerValue,
        :totals / :victory_points / :last_week => xml.readNode("/eveapi/result/totals/victoryPointsLastWeek").integerValue,
        :totals / :victory_points / :total => xml.readNode("/eveapi/result/totals/victoryPointsTotal").integerValue,
        
        :wars => xml.readNodes("/eveapi/result/rowset[@name='factionWars']/row").map do |war|
          {
            :id => war.readAttribute("factionID").integerValue,
            :name => war.readAttribute("factionName").stringValue,
            :against / :id => war.readAttribute("againstID").integerValue,
            :against / :name => war.readAttribute("againstName").stringValue
          }
        end
      }
      
      [
        [500001, :factions / :caldari],
        [500002, :factions / :minmatar],
        [500003, :factions / :amarr],
        [500004, :factions / :gallente]
      ].each do |faction_id, faction_symbol|
        faction = xml.readNode("/eveapi/result/rowset[@name='factions']/row[@factionID='#{faction_id}']")

        hash[faction_symbol / :id] = faction.readAttribute("factionID").integerValue
        hash[faction_symbol / :name] = faction.readAttribute("factionName").stringValue
        hash[faction_symbol / :pilots] = faction.readAttribute("pilots").integerValue
        hash[faction_symbol / :systems_controlled] = faction.readAttribute("systemsControlled").integerValue
             
        hash[faction_symbol / :kills / :yesterday] = faction.readAttribute("killsYesterday").integerValue
        hash[faction_symbol / :kills / :last_week] = faction.readAttribute("killsLastWeek").integerValue
        hash[faction_symbol / :kills / :total] = faction.readAttribute("killsTotal").integerValue
             
        hash[faction_symbol / :victory_points / :yesterday] = faction.readAttribute("victoryPointsYesterday").integerValue
        hash[faction_symbol / :victory_points / :last_week] = faction.readAttribute("victoryPointsLastWeek").integerValue
        hash[faction_symbol / :victory_points / :total] = faction.readAttribute("victoryPointsTotal").integerValue
      end
      
      return result, xml.cachedUntil
    end
    
    def faction_warfare_top_100
      xml = self.download(Ceres.faction_warfare_urls[:top_100])
      
      def parse_stats(xml, path, type)
        xml.findNodes(path).map do |character|
          hash = {
            :id => character.readAttribute("characterID").integerValue,
            :name => character.readAttribute("characterName").stringValue
          }

          case type
          when :kills
            hash[:kills] = character.readAttribute("kills").integerValue
          when :victory_points
            hash[:victory_points] = character.readAttribute("victoryPoints")
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
      
      return result, xml.cachedUntil
      
    end
    
    def occupancy
      xml = self.download(Ceres.faction_warfare_urls[:occupancy])
      
      systems = xml.readNodes("/eveapi/result/rowset/row").map do |system|
        {
          :id => system.readAttribute("solarSystemID").integerValue,
          :name => system.readAttribute("solarSystemName").stringValue,
          :contested => (system.readAttribute("contested").stringValue == "True"),
          
          :faction / :id => system.readAttribute("occupyingFactionID").integerValue,
          :faction / :name => system.readAttribute("occupyingFactionName").stringValue
        }
      end
      
      return systems, xml.cachedUntil
    end
  end
end