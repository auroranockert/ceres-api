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
        :id => xml.readNode("/eveapi/result/characterID").to_i,
        :name => xml.readNode("/eveapi/result/name").to_s,
        :race => xml.readNode("/eveapi/result/race").to_s,
        :bloodline => xml.readNode("/eveapi/result/bloodLine").to_s,
        :gender => xml.readNode("/eveapi/result/gender").to_s,
        :clone / :name => xml.readNode("/eveapi/result/cloneName").to_s,
        :clone / :skillpoints => xml.readNode("/eveapi/result/cloneSkillPoints").to_i,
        :balance => xml.readNode("/eveapi/result/balance").floatValue,
        
        :attributes / :intelligence => xml.readNode("/eveapi/result/attributes/intelligence").to_i,
        :attributes / :memory => xml.readNode("/eveapi/result/attributes/memory").to_i,
        :attributes / :charisma => xml.readNode("/eveapi/result/attributes/charisma").to_i,
        :attributes / :perception => xml.readNode("/eveapi/result/attributes/perception").to_i,
        :attributes / :willpower => xml.readNode("/eveapi/result/attributes/willpower").to_i,
        
        :attributes / :intelligence / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/intelligenceBonus/augmentatorName").to_s,
        :attributes / :intelligence / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/intelligenceBonus/augmentatorValue").to_i,
        :attributes / :memory / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/memoryBonus/augmentatorName").to_s,
        :attributes / :memory / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/memoryBonus/augmentatorValue").to_i,
        :attributes / :charisma / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/charismaBonus/augmentatorName").to_s,
        :attributes / :charisma / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/charismaBonus/augmentatorValue").to_i,
        :attributes / :perception / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/perceptionBonus/augmentatorName").to_s,
        :attributes / :perception / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/perceptionBonus/augmentatorValue").to_i,
        :attributes / :willpower / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/willpowerBonus/augmentatorName").to_s,
        :attributes / :willpower / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/willpowerBonus/augmentatorValue").to_i,
                
        :skills => xml.readNodes("/eveapi/result/rowset[@name='skills']/row").map do |skill|
          hash = {
            :id => skill.readAttribute("typeID").to_i,
            :skillpoints => skill.readAttribute("skillpoints").to_i
          }
          
          attribute = skill.readAttribute("level")
          if attribute
            hash[:level] = attribute.to_i
          end
          
          attribute = skill.readAttribute("unpublished")
          if attribute
            hash[:level] = (attribute.to_i == 1)
          end
                    
          hash
        end,
        
        :certificates => xml.readNodes("/eveapi/result/rowset[@name='certificates']/row").map do |certificate|
          { :id => certificate.readAttribute("certificateID").to_i }
        end,
        
        :corporation => {
          :id => xml.readNode("/eveapi/result/corporationID").to_i,
          :name => xml.readNode("/eveapi/result/corporationName").to_s,
          
          :roles => xml.readNodes("/eveapi/result/rowset[@name='corporationRoles']/row").map do |role|
            { :id => role.readAttribute("roleID").to_i, :name => role.readAttribute("roleName").to_s }
          end,
          
          :roles_at_headquarters => xml.readNodes("/eveapi/result/rowset[@name='corporationRolesAtHQ']/row").map do |role|
            { :id => role.readAttribute("roleID").to_i, :name => role.readAttribute("roleName").to_s }
          end,
          
          :roles_at_base => xml.readNodes("/eveapi/result/rowset[@name='corporationRolesAtBase']/row").map do |role|
            { :id => role.readAttribute("roleID").to_i, :name => role.readAttribute("roleName").to_s }
          end,
          
          :roles_otherwise => xml.readNodes("/eveapi/result/rowset[@name='corporationRolesAtOther']/row").map do |role|
            { :id => role.readAttribute("roleID").to_i, :name => role.readAttribute("roleName").to_s }
          end,
          
          :titles => xml.readNodes("/eveapi/result/rowset[@name='corporationTitles']/row").map do |title|
            { :id => title.readAttribute("titleID").to_i, :name => title.readAttribute("titleName").to_s }
          end
        }
      }
      
      return sheet, xml.cachedUntil
    end
    
    def skill_in_training
      xml = self.download(Ceres.character_urls[:training])
      
      if xml.readNode("/eveapi/result/skillInTraining").to_i == 0
        skill = nil
      else
        skill = {
          :id => xml.readNode("/eveapi/result/trainingTypeID").to_i,
          :to_level => xml.readNode("/eveapi/result/trainingToLevel").to_i,
          
          :start / :at => xml.readNode("/eveapi/result/trainingStartTime").to_date,
          :start / :skillpoints => xml.readNode("/eveapi/result/trainingStartSP").to_i,
          :end / :at => xml.readNode("/eveapi/result/trainingEndTime").to_date,
          :end / :skillpoints => xml.readNode("/eveapi/result/trainingDestinationSP").to_i
        }
      end
      
      return skill, xml.cachedUntil
    end
    
    def skill_queue
      xml = self.download(Ceres.character_urls[:skill_queue])
      
      queue = []
      
      xml.readNodes("/eveapi/result/rowset/row").each do |entry|
        queue[entry.readAttribute("queuePosition").to_i] = {
          :id => entry.readAttribute("typeID").to_i,
          :to_level => entry.readAttribute("level").to_i,
          
          :start / :at => entry.readAttribute("startTime").to_date,
          :start / :skillpoints => entry.readAttribute("startSP").to_i,
          :end / :at => entry.readAttribute("endTime").to_date,
          :end / :skillpoints => entry.readAttribute("endSP").to_i
        }
      end
      
      return queue, xml.cachedUntil
    end
    
    def character_faction_warfare_statistics
      xml = self.download(Ceres.character_urls[:faction_warfare])
      
      fw = {
        :faction / :id => xml.readNode("/eveapi/result/factionID").to_i,
        :faction / :name=> xml.readNode("/eveapi/result/factionName").to_i,
        
        :enlisted_at => xml.readNode("/eveapi/result/enlisted").to_date,
        
        :rank / :current => xml.readNode("/eveapi/result/currentRank").to_i,
        :rank / :highest => xml.readNode("/eveapi/result/highestRank").to_i,
        
        :kills / :yesterday => xml.readNode("/eveapi/result/killsYesterday").to_i,
        :kills / :last_week => xml.readNode("/eveapi/result/killsLastWeek").to_i,
        :kills / :total => xml.readNode("/eveapi/result/killsTotal").to_i,
        
        :victory_points / :yesterday => xml.readNode("/eveapi/result/victoryPointsYesterday").to_i,
        :victory_points / :last_week => xml.readNode("/eveapi/result/victoryPointsLastWeek").to_i,
        :victory_points / :total => xml.readNode("/eveapi/result/victoryPointsTotal").to_i
      }
    end
    
    def character_medals
      xml = self.download(Ceres.character_urls[:standings])
      
      medals = {
        :current_corporation => xml.readNodes("/eveapi/result/rowset[@name='currentCorporation']/row").map do |medal|
          {
            :id => medal.readAttribute("medalID").to_i,
            :issuer_id => medal.readAttribute("issuerID").to_i,
            
            :reason => medal.readAttribute("reason").to_s,
            :status => medal.readAttribute("standing").to_s,
            :issued_at => medal.readAttribute("issued").to_date
          }
        end,
        
        :other_corporation => xml.readNodes("/eveapi/result/rowset[@name='otherCorporations']/row").map do |medal|
          {
            :id => medal.readAttribute("medalID").to_i,
            :issuer_id => medal.readAttribute("issuerID").to_i,
            
            :reason => medal.readAttribute("reason").to_s,
            :status => medal.readAttribute("standing").to_s,
            :issued_at => medal.readAttribute("issued").to_date,
            
            :corporation_id => medal.readAttribute("corporationID").to_i,
            :title => medal.readAttribute("title").to_s,
            :description => medal.readAttribute("description").to_s
          }
        end
      }
      
      return medals, xml.cachedUntil
    end
    
    def character_standings
      xml = self.download(Ceres.character_urls[:standings])
      
      standings = {
        :to => {
          :characters => xml.readNodes("/eveapi/result/standingsTo/rowset[@name='characters']/row").map do |other|
            {
              :id => other.readAttribute("toID").to_i,
              :name => other.readAttribute("toName").to_s,
              :standings => other.readAttribute("standing").floatValue
            }
          end,
          
          :corporations => xml.readNodes("/eveapi/result/standingsTo/rowset[@name='corporations']/row").map do |other|
            {
              :id => other.readAttribute("toID").to_i,
              :name => other.readAttribute("toName").to_s,
              :standings => other.readAttribute("standing").floatValue
            }
          end
        },
        
        :from => {
          :agents => xml.readNodes("/eveapi/result/standingsFrom/rowset[@name='agents']/row").map do |other|
            {
              :id => other.readAttribute("fromID").to_i,
              :name => other.readAttribute("fromName").to_s,
              :standings => other.readAttribute("standing").floatValue
            }
          end,
          
          :corporations => xml.readNodes("/eveapi/result/standingsFrom/rowset[@name='NPCCorporations']/row").map do |other|
            {
              :id => other.readAttribute("fromID").to_i,
              :name => other.readAttribute("fromName").to_s,
              :standings => other.readAttribute("standing").floatValue
            }
          end,
          
          :factions => xml.readNodes("/eveapi/result/standingsFrom/rowset[@name='factions']/row").map do |other|
            {
              :id => other.readAttribute("fromID").to_i,
              :name => other.readAttribute("fromName").to_s,
              :standings => other.readAttribute("standing").floatValue
            }
          end
        }
      }
      
      return standings, xml.cachedUntil
    end
    
  private
  
    def parse_attribute_enhancer(xml, type)
      if node = xml.readNode("/eveapi/result/attributeEnhancers/#{type.to_s}Bonus")
        { :name => node.readNode("./augmentatorName").to_s, :value => node.readNode("./augmentatorValue").to_i }
      else
        nil
      end
    end
  end
end