#
#  misc.rb
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
    def alliances
      xml = self.download(Ceres.misc_urls[:alliances])
      
      alliances = xml.readNodes("/eveapi/result/rowset/row").map do |alliance|
        {
          :id => alliance.readAttribute("allianceID").to_i,
          :name => alliance.readAttribute("name").to_s,
          :short_name => alliance.readAttribute("shortName").to_s,
          :executor_id => alliance.readAttribute("executorCorpID").to_i,
          :member_count => alliance.readAttribute("memberCount").to_s,
          :start_date => alliance.readAttribute("name").to_date,
          :member_corporations => alliance.readNodes("rowset/row").map do |corporation|
            { :id => corporation.readAttribute("corporationID").to_i, :start_date => corporation.readAttribute("startDate").to_date }
          end
        }
      end
      
      return alliances, xml.cachedUntil
    end
    
    def certificate_tree
      xml = self.download(Ceres.misc_urls[:certificate_tree])
      
      categories = xml.readNodes("/eveapi/result/rowset/row").map do |category|
        {
          :id => category.readAttribute("categoryID").to_i,
          :name => category.readAttribute("categoryName").to_s,
          :classes => category.readNodes("rowset/row").map do |klass|
            {
              :id => klass.readAttribute("classID").to_i,
              :name => klass.readAttribute("className").to_s,
              :certificates => klass.readNodes("rowset/row").map do |certificate|
                {
                  :id => certificate.readAttribute("certificateID").to_i,
                  :grade => certificate.readAttribute("grade").to_i,
                  :corporation_id => certificate.readAttribute("corporationID").to_i,
                  :description => certificate.readAttribute("description").to_s,
                  
                  :required_skills => certificate.readNodes("rowset[@name='requiredSkills']/row").map do |required_skill|
                    { :id => required_skill.readAttribute("typeID").to_s, :level => required_skill.readAttribute("level").to_i }
                  end,
                  
                  :required_certificates => certificate.readNodes("rowset[@name='requiredCertificates']/row").map do |required_certificate|
                    { :id => required_certificate.readAttribute("certificateID").to_s, :grade => required_certificate.readAttribute("grade").to_i }
                  end
                }
              end
            }
          end
        }
      end
      
      return categories, xml.cachedUntil
    end
    
    def errors
      xml = self.download(Ceres.misc_urls[:errors])
      
      errors = xml.readNodes("/eveapi/result/rowset/row").map do |error|
        { :id => error.readAttribute("errorCode").to_i, :text => error.readAttribute("errorText").to_s }
      end
      
      return errors, xml.cachedUntil
    end
    
    def ref_types
      xml = self.download(Ceres.misc_urls[:ref_types])
      
      refs = xml.readNodes("/eveapi/result/rowset/row").map do |ref|
        { :id => ref.readAttribute("refTypeID").to_i, :text => ref.readAttribute("refTypeName").to_s }
      end
      
      return refs, xml.cachedUntil
    end
    
    def skill_tree
      xml = self.download(Ceres.misc_urls[:skill_tree])
      
      skill_groups = xml.readNodes("/eveapi/result/rowset/row").map do |skill_group|
        {
          :id => skill_group.readAttribute("groupID").to_i,
          :name => skill_group.readAttribute("groupName").to_s,
          :skills => skill_group.readNodes("rowset/row").map do |skill|
            {
              :id => skill.readAttribute("typeID").to_i,
              :name => skill.readAttribute("typeName").to_s,
              :group_id => skill.readAttribute("groupID").to_s,
              :description => skill.readNode("description").to_s,
              :rank => skill.readNode("rank").to_s,
              :attribute / :primary => skill.readNode("requiredAttributes/primaryAttribute").to_s,
              :attribute / :secondary => skill.readNode("requiredAttributes/secondaryAttribute").to_s,
              
              :required_skills => skill.readNodes("rowset[@name='requiredSkills']/row").map do |required_skill|
                { :id => required_skill.readAttribute("typeID").to_s, :level => required_skill.readAttribute("skillLevel").to_i }
              end,
              
              :bonuses => skill.readNodes("rowset[@name='skillBonusCollection']/row").map do |bonus|
                { :type => bonus.readAttribute("bonusType").to_s, :value => bonus.readAttribute("bonusValue").to_s }
              end
              
            }
          end
        }
      end
      
      return skill_groups, xml.cachedUntil
    end
    
    def identifiers_to_names(*identifiers)
      xml = self.download(Ceres.misc_urls[:identifiers_to_names], ids: identifiers.map { |x| x.to_s }.join(","))
      
      names = xml.readNodes("/eveapi/result/rowset/row").map do |name|
        { :id => name.readAttribute("characterID").to_i, :name => name.readAttribute("name").to_s }
      end
      
      return names, xml.cachedUntil
    end
    
    def names_to_identifiers(*names)
      xml = self.download(Ceres.misc_urls[:names_to_identifiers], names: names.map { |x| x.to_s }.join(","))
      
      identifiers = xml.readNodes("/eveapi/result/rowset/row").map do |id|
        { :id => id.readAttribute("characterID").to_i, :name => id.readAttribute("name").to_s }
      end
      
      return identifiers, xml.cachedUntil
    end
  end
end
