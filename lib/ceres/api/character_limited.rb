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
        :id => xml.readNode("/eveapi/result/characterID").integerValue,
        :name => xml.readNode("/eveapi/result/name").stringValue,
        :race => xml.readNode("/eveapi/result/race").stringValue,
        :bloodline => xml.readNode("/eveapi/result/bloodLine").stringValue,
        :gender => xml.readNode("/eveapi/result/gender").stringValue,
        :clone / :name => xml.readNode("/eveapi/result/cloneName").stringValue,
        :clone / :skillpoints => xml.readNode("/eveapi/result/cloneSkillPoints").integerValue,
        :balance => xml.readNode("/eveapi/result/balance").floatValue,
        
        :attributes / :intelligence => xml.readNode("/eveapi/result/attributes/intelligence").integerValue,
        :attributes / :memory => xml.readNode("/eveapi/result/attributes/memory").integerValue,
        :attributes / :charisma => xml.readNode("/eveapi/result/attributes/charisma").integerValue,
        :attributes / :perception => xml.readNode("/eveapi/result/attributes/perception").integerValue,
        :attributes / :willpower => xml.readNode("/eveapi/result/attributes/willpower").integerValue,
        
        :attributes / :intelligence / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/intelligenceBonus/augmentatorName").stringValue
        :attributes / :intelligence / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/intelligenceBonus/augmentatorValue").integerValue
        :attributes / :memory / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/memoryBonus/augmentatorName").stringValue
        :attributes / :memory / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/memoryBonus/augmentatorValue").integerValue
        :attributes / :charisma / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/charismaBonus/augmentatorName").stringValue
        :attributes / :charisma / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/charismaBonus/augmentatorValue").integerValue
        :attributes / :perception / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/perceptionBonus/augmentatorName").stringValue
        :attributes / :perception / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/perceptionBonus/augmentatorValue").integerValue
        :attributes / :willpower / :enhancer / :name => node.readNode("/eveapi/result/attributeEnhancers/willpowerBonus/augmentatorName").stringValue
        :attributes / :willpower / :enhancer / :value => node.readNode("/eveapi/result/attributeEnhancers/willpowerBonus/augmentatorValue").integerValue
                
        :skills => xml.readNodes("/eveapi/result/rowset[@name='skills']/row").map do |skill|
          hash = {
            :id => skill.readAttribute("typeID").integerValue,
            :skillpoints => skill.readAttribute("skillpoints").integerValue
          }
          
          attribute = skill.readAttribute("level")
          if attribute
            hash[:level] = attribute.integerValue
          end
          
          attribute = skill.readAttribute("unpublished")
          if attribute
            hash[:level] = (attribute.integerValue == 1)
          end
                    
          hash
        end,
        
        :certificates => xml.readNodes("/eveapi/result/rowset[@name='certificates']/row").map do |certificate|
          { :id => certificate.readAttribute("certificateID").integerValue }
        end,
        
        :corporation => {
          :id => xml.readNode("/eveapi/result/corporationID").integerValue,
          :name => xml.readNode("/eveapi/result/corporationName").stringValue,
          
          :roles => xml.readNodes("/eveapi/result/rowset[@name='corporationRoles']/row").map do |role|
            { :id => role.readAttribute("roleID").integerValue, :name => role.readAttribute("roleName").stringValue }
          end,
          
          :roles_at_headquarters => xml.readNodes("/eveapi/result/rowset[@name='corporationRolesAtHQ']/row").map do |role|
            { :id => role.readAttribute("roleID").integerValue, :name => role.readAttribute("roleName").stringValue }
          end,
          
          :roles_at_base => xml.readNodes("/eveapi/result/rowset[@name='corporationRolesAtBase']/row").map do |role|
            { :id => role.readAttribute("roleID").integerValue, :name => role.readAttribute("roleName").stringValue }
          end,
          
          :roles_otherwise => xml.readNodes("/eveapi/result/rowset[@name='corporationRolesAtOther']/row").map do |role|
            { :id => role.readAttribute("roleID").integerValue, :name => role.readAttribute("roleName").stringValue }
          end,
          
          :titles => xml.readNodes("/eveapi/result/rowset[@name='corporationTitles']/row").map do |title|
            { :id => title.readAttribute("titleID").integerValue, :name => title.readAttribute("titleName").stringValue }
          end
        }
      }
      
      return sheet, xml.cachedUntil
    end
    
    def skill_in_training
      xml = self.download(Ceres.character_urls[:training])
      
      if xml.readNode("/eveapi/result/skillInTraining").integerValue == 0
        skill = nil
      else
        skill = {
          :id => xml.readNode("/eveapi/result/trainingTypeID").integerValue,
          :to_level => xml.readNode("/eveapi/result/trainingToLevel").integerValue,
          
          :start / :at => xml.readNode("/eveapi/result/trainingStartTime").dateValue,
          :start / :skillpoints => xml.readNode("/eveapi/result/trainingStartSP").integerValue,
          :end / :at => xml.readNode("/eveapi/result/trainingEndTime").dateValue,
          :end / :skillpoints => xml.readNode("/eveapi/result/trainingDestinationSP").integerValue
        }
      end
      
      return skill, xml.cachedUntil
    end
    
    def skill_queue
      xml = self.download(Ceres.character_urls[:skill_queue])
      
      queue = []
      
      xml.readNodes("/eveapi/result/rowset/row").each do |entry|
        queue[entry.readAttribute("queuePosition").integerValue] = {
          :id => entry.readAttribute("typeID").integerValue,
          :to_level => entry.readAttribute("level").integerValue,
          
          :start / :at => entry.readAttribute("startTime").dateValue,
          :start / :skillpoints => entry.readAttribute("startSP").integerValue,
          :end / :at => entry.readAttribute("endTime").dateValue,
          :end / :skillpoints => entry.readAttribute("endSP").integerValue
        }
      end
      
      return queue, xml.cachedUntil
    end
    
    def character_faction_warfare_statistics
      xml = self.download(Ceres.character_urls[:faction_warfare])
      
      fw = {
        :faction / :id => xml.readNode("/eveapi/result/factionID").integerValue,
        :faction / :name=> xml.readNode("/eveapi/result/factionName").integerValue,
        
        :enlisted_at => xml.readNode("/eveapi/result/enlisted").dateValue,
        
        :rank / :current => xml.readNode("/eveapi/result/currentRank").integerValue,
        :rank / :highest => xml.readNode("/eveapi/result/highestRank").integerValue,
        
        :kills / :yesterday => xml.readNode("/eveapi/result/killsYesterday").integerValue,
        :kills / :last_week => xml.readNode("/eveapi/result/killsLastWeek").integerValue,
        :kills / :total => xml.readNode("/eveapi/result/killsTotal").integerValue,
        
        :victory_points / :yesterday => xml.readNode("/eveapi/result/victoryPointsYesterday").integerValue,
        :victory_points / :last_week => xml.readNode("/eveapi/result/victoryPointsLastWeek").integerValue,
        :victory_points / :total => xml.readNode("/eveapi/result/victoryPointsTotal").integerValue
      }
    end
    
    def character_medals
      xml = self.download(Ceres.character_urls[:standings])
      
      medals = {
        :current_corporation => xml.readNodes("/eveapi/result/rowset[@name='currentCorporation']/row").map do |medal|
          {
            :id => medal.readAttribute("medalID").integerValue,
            :issuer_id => medal.readAttribute("issuerID").integerValue,
            
            :reason => medal.readAttribute("reason").stringValue,
            :status => medal.readAttribute("standing").stringValue,
            :issued_at => medal.readAttribute("issued").dateValue
          }
        end,
        
        :other_corporation => xml.readNodes("/eveapi/result/rowset[@name='otherCorporations']/row").map do |medal|
          {
            :id => medal.readAttribute("medalID").integerValue,
            :issuer_id => medal.readAttribute("issuerID").integerValue,
            
            :reason => medal.readAttribute("reason").stringValue,
            :status => medal.readAttribute("standing").stringValue,
            :issued_at => medal.readAttribute("issued").dateValue,
            
            :corporation_id => medal.readAttribute("corporationID").integerValue,
            :title => medal.readAttribute("title").stringValue,
            :description => medal.readAttribute("description").stringValue
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
              :id => other.readAttribute("toID").integerValue,
              :name => other.readAttribute("toName").stringValue,
              :standings => other.readAttribute("standing").floatValue
            }
          end,
          
          :corporations => xml.readNodes("/eveapi/result/standingsTo/rowset[@name='corporations']/row").map do |other|
            {
              :id => other.readAttribute("toID").integerValue,
              :name => other.readAttribute("toName").stringValue,
              :standings => other.readAttribute("standing").floatValue
            }
          end
        },
        
        :from => {
          :agents => xml.readNodes("/eveapi/result/standingsFrom/rowset[@name='agents']/row").map do |other|
            {
              :id => other.readAttribute("fromID").integerValue,
              :name => other.readAttribute("fromName").stringValue,
              :standings => other.readAttribute("standing").floatValue
            }
          end,
          
          :corporations => xml.readNodes("/eveapi/result/standingsFrom/rowset[@name='NPCCorporations']/row").map do |other|
            {
              :id => other.readAttribute("fromID").integerValue,
              :name => other.readAttribute("fromName").stringValue,
              :standings => other.readAttribute("standing").floatValue
            }
          end,
          
          :factions => xml.readNodes("/eveapi/result/standingsFrom/rowset[@name='factions']/row").map do |other|
            {
              :id => other.readAttribute("fromID").integerValue,
              :name => other.readAttribute("fromName").stringValue,
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
        { :name => node.readNode("./augmentatorName").stringValue, :value => node.readNode("./augmentatorValue").integerValue }
      else
        nil
      end
    end
  end
end