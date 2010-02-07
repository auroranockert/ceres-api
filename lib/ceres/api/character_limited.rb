#
#  character_limited.rb
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
    def character_sheet
      xml = self.download(Ceres.character_urls[:sheet])
      
      sheet = {
        :id => xml.read_node("/eveapi/result/characterID").to_i,
        :name => xml.read_node("/eveapi/result/name").to_s,
        :race => xml.read_node("/eveapi/result/race").to_s,
        :bloodline => xml.read_node("/eveapi/result/bloodLine").to_s,
        :gender => xml.read_node("/eveapi/result/gender").to_s,
        :clone / :name => xml.read_node("/eveapi/result/cloneName").to_s,
        :clone / :skillpoints => xml.read_node("/eveapi/result/cloneSkillPoints").to_i,
        :balance => xml.read_node("/eveapi/result/balance").to_f,
        
        :attributes / :intelligence => xml.read_node("/eveapi/result/attributes/intelligence").to_i,
        :attributes / :memory => xml.read_node("/eveapi/result/attributes/memory").to_i,
        :attributes / :charisma => xml.read_node("/eveapi/result/attributes/charisma").to_i,
        :attributes / :perception => xml.read_node("/eveapi/result/attributes/perception").to_i,
        :attributes / :willpower => xml.read_node("/eveapi/result/attributes/willpower").to_i,
        
        :attributes / :intelligence / :enhancer / :name => node.read_node("/eveapi/result/attributeEnhancers/intelligenceBonus/augmentatorName").to_s,
        :attributes / :intelligence / :enhancer / :value => node.read_node("/eveapi/result/attributeEnhancers/intelligenceBonus/augmentatorValue").to_i,
        :attributes / :memory / :enhancer / :name => node.read_node("/eveapi/result/attributeEnhancers/memoryBonus/augmentatorName").to_s,
        :attributes / :memory / :enhancer / :value => node.read_node("/eveapi/result/attributeEnhancers/memoryBonus/augmentatorValue").to_i,
        :attributes / :charisma / :enhancer / :name => node.read_node("/eveapi/result/attributeEnhancers/charismaBonus/augmentatorName").to_s,
        :attributes / :charisma / :enhancer / :value => node.read_node("/eveapi/result/attributeEnhancers/charismaBonus/augmentatorValue").to_i,
        :attributes / :perception / :enhancer / :name => node.read_node("/eveapi/result/attributeEnhancers/perceptionBonus/augmentatorName").to_s,
        :attributes / :perception / :enhancer / :value => node.read_node("/eveapi/result/attributeEnhancers/perceptionBonus/augmentatorValue").to_i,
        :attributes / :willpower / :enhancer / :name => node.read_node("/eveapi/result/attributeEnhancers/willpowerBonus/augmentatorName").to_s,
        :attributes / :willpower / :enhancer / :value => node.read_node("/eveapi/result/attributeEnhancers/willpowerBonus/augmentatorValue").to_i,
                
        :skills => xml.read_nodes("/eveapi/result/rowset[@name='skills']/row").map do |skill|
          hash = {
            :id => skill.read_attribute("typeID").to_i,
            :skillpoints => skill.read_attribute("skillpoints").to_i
          }
          
          attribute = skill.read_attribute("level")
          if attribute
            hash[:level] = attribute.to_i
          end
          
          attribute = skill.read_attribute("unpublished")
          if attribute
            hash[:level] = (attribute.to_i == 1)
          end
                    
          hash
        end,
        
        :certificates => xml.read_nodes("/eveapi/result/rowset[@name='certificates']/row").map do |certificate|
          { :id => certificate.read_attribute("certificateID").to_i }
        end,
        
        :corporation => {
          :id => xml.read_node("/eveapi/result/corporationID").to_i,
          :name => xml.read_node("/eveapi/result/corporationName").to_s,
          
          :roles => xml.read_nodes("/eveapi/result/rowset[@name='corporationRoles']/row").map do |role|
            { :id => role.read_attribute("roleID").to_i, :name => role.read_attribute("roleName").to_s }
          end,
          
          :roles_at_headquarters => xml.read_nodes("/eveapi/result/rowset[@name='corporationRolesAtHQ']/row").map do |role|
            { :id => role.read_attribute("roleID").to_i, :name => role.read_attribute("roleName").to_s }
          end,
          
          :roles_at_base => xml.read_nodes("/eveapi/result/rowset[@name='corporationRolesAtBase']/row").map do |role|
            { :id => role.read_attribute("roleID").to_i, :name => role.read_attribute("roleName").to_s }
          end,
          
          :roles_otherwise => xml.read_nodes("/eveapi/result/rowset[@name='corporationRolesAtOther']/row").map do |role|
            { :id => role.read_attribute("roleID").to_i, :name => role.read_attribute("roleName").to_s }
          end,
          
          :titles => xml.read_nodes("/eveapi/result/rowset[@name='corporationTitles']/row").map do |title|
            { :id => title.read_attribute("titleID").to_i, :name => title.read_attribute("titleName").to_s }
          end
        }
      }
      
      return sheet, xml.cached_until
    end
    
    def skill_in_training
      xml = self.download(Ceres.character_urls[:training])
      
      if xml.read_node("/eveapi/result/skillInTraining").to_i == 0
        skill = nil
      else
        skill = {
          :id => xml.read_node("/eveapi/result/trainingTypeID").to_i,
          :to_level => xml.read_node("/eveapi/result/trainingToLevel").to_i,
          
          :start / :at => xml.read_node("/eveapi/result/trainingStartTime").to_date,
          :start / :skillpoints => xml.read_node("/eveapi/result/trainingStartSP").to_i,
          :end / :at => xml.read_node("/eveapi/result/trainingEndTime").to_date,
          :end / :skillpoints => xml.read_node("/eveapi/result/trainingDestinationSP").to_i
        }
      end
      
      return skill, xml.cached_until
    end
    
    def skill_queue
      xml = self.download(Ceres.character_urls[:skill_queue])
      
      queue = []
      
      xml.read_nodes("/eveapi/result/rowset/row").each do |entry|
        queue[entry.read_attribute("queuePosition").to_i] = {
          :id => entry.read_attribute("typeID").to_i,
          :to_level => entry.read_attribute("level").to_i,
          
          :start / :at => entry.read_attribute("startTime").to_date,
          :start / :skillpoints => entry.read_attribute("startSP").to_i,
          :end / :at => entry.read_attribute("endTime").to_date,
          :end / :skillpoints => entry.read_attribute("endSP").to_i
        }
      end
      
      return queue, xml.cached_until
    end
    
    def character_faction_warfare_statistics
      xml = self.download(Ceres.character_urls[:faction_warfare])
      
      fw = {
        :faction / :id => xml.read_node("/eveapi/result/factionID").to_i,
        :faction / :name=> xml.read_node("/eveapi/result/factionName").to_i,
        
        :enlisted_at => xml.read_node("/eveapi/result/enlisted").to_date,
        
        :rank / :current => xml.read_node("/eveapi/result/currentRank").to_i,
        :rank / :highest => xml.read_node("/eveapi/result/highestRank").to_i,
        
        :kills / :yesterday => xml.read_node("/eveapi/result/killsYesterday").to_i,
        :kills / :last_week => xml.read_node("/eveapi/result/killsLastWeek").to_i,
        :kills / :total => xml.read_node("/eveapi/result/killsTotal").to_i,
        
        :victory_points / :yesterday => xml.read_node("/eveapi/result/victoryPointsYesterday").to_i,
        :victory_points / :last_week => xml.read_node("/eveapi/result/victoryPointsLastWeek").to_i,
        :victory_points / :total => xml.read_node("/eveapi/result/victoryPointsTotal").to_i
      }
    end
    
    def character_medals
      xml = self.download(Ceres.character_urls[:standings])
      
      medals = {
        :current_corporation => xml.read_nodes("/eveapi/result/rowset[@name='currentCorporation']/row").map do |medal|
          {
            :id => medal.read_attribute("medalID").to_i,
            :issuer_id => medal.read_attribute("issuerID").to_i,
            
            :reason => medal.read_attribute("reason").to_s,
            :status => medal.read_attribute("standing").to_s,
            :issued_at => medal.read_attribute("issued").to_date
          }
        end,
        
        :other_corporation => xml.read_nodes("/eveapi/result/rowset[@name='otherCorporations']/row").map do |medal|
          {
            :id => medal.read_attribute("medalID").to_i,
            :issuer_id => medal.read_attribute("issuerID").to_i,
            
            :reason => medal.read_attribute("reason").to_s,
            :status => medal.read_attribute("standing").to_s,
            :issued_at => medal.read_attribute("issued").to_date,
            
            :corporation_id => medal.read_attribute("corporationID").to_i,
            :title => medal.read_attribute("title").to_s,
            :description => medal.read_attribute("description").to_s
          }
        end
      }
      
      return medals, xml.cached_until
    end
    
    def character_standings
      xml = self.download(Ceres.character_urls[:standings])
      
      standings = {
        :to => {
          :characters => xml.read_nodes("/eveapi/result/standingsTo/rowset[@name='characters']/row").map do |other|
            {
              :id => other.read_attribute("toID").to_i,
              :name => other.read_attribute("toName").to_s,
              :standings => other.read_attribute("standing").to_f
            }
          end,
          
          :corporations => xml.read_nodes("/eveapi/result/standingsTo/rowset[@name='corporations']/row").map do |other|
            {
              :id => other.read_attribute("toID").to_i,
              :name => other.read_attribute("toName").to_s,
              :standings => other.read_attribute("standing").to_f
            }
          end
        },
        
        :from => {
          :agents => xml.read_nodes("/eveapi/result/standingsFrom/rowset[@name='agents']/row").map do |other|
            {
              :id => other.read_attribute("fromID").to_i,
              :name => other.read_attribute("fromName").to_s,
              :standings => other.read_attribute("standing").to_f
            }
          end,
          
          :corporations => xml.read_nodes("/eveapi/result/standingsFrom/rowset[@name='NPCCorporations']/row").map do |other|
            {
              :id => other.read_attribute("fromID").to_i,
              :name => other.read_attribute("fromName").to_s,
              :standings => other.read_attribute("standing").to_f
            }
          end,
          
          :factions => xml.read_nodes("/eveapi/result/standingsFrom/rowset[@name='factions']/row").map do |other|
            {
              :id => other.read_attribute("fromID").to_i,
              :name => other.read_attribute("fromName").to_s,
              :standings => other.read_attribute("standing").to_f
            }
          end
        }
      }
      
      return standings, xml.cached_until
    end
    
  private
  
    def parse_attribute_enhancer(xml, type)
      if node = xml.read_node("/eveapi/result/attributeEnhancers/#{type.to_s}Bonus")
        { :name => node.read_node("./augmentatorName").to_s, :value => node.read_node("./augmentatorValue").to_i }
      else
        nil
      end
    end
  end
end