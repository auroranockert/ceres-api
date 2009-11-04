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
          :id => alliance.readAttribute("allianceID").integerValue,
          :name => alliance.readAttribute("name").stringValue,
          :short_name => alliance.readAttribute("shortName").stringValue,
          :executor_id => alliance.readAttribute("executorCorpID").integerValue,
          :member_count => alliance.readAttribute("memberCount").stringValue,
          :start_date => alliance.readAttribute("name").dateValue,
          :member_corporations => alliance.readNodes("rowset/row").map do |corporation|
            { :id => corporation.readAttribute("corporationID").integerValue, :start_date => corporation.readAttribute("startDate").dateValue }
          end
        }
      end
      
      return alliances, xml.cachedUntil
    end
    
    def certificate_tree
      xml = self.download(Ceres.misc_urls[:certificate_tree])
      
      categories = xml.readNodes("/eveapi/result/rowset/row").map do |category|
        {
          :id => category.readAttribute("categoryID").integerValue,
          :name => category.readAttribute("categoryName").stringValue,
          :classes => category.readNodes("rowset/row").map do |klass|
            {
              :id => klass.readAttribute("classID").integerValue,
              :name => klass.readAttribute("className").stringValue,
              :certificates => klass.readNodes("rowset/row").map do |certificate|
                {
                  :id => certificate.readAttribute("certificateID").integerValue,
                  :grade => certificate.readAttribute("grade").integerValue,
                  :corporation_id => certificate.readAttribute("corporationID").integerValue,
                  :description => certificate.readAttribute("description").stringValue,
                  
                  :required_skills => certificate.readNodes("rowset[@name='requiredSkills']/row").map do |required_skill|
                    { :id => required_skill.readAttribute("typeID").stringValue, :level => required_skill.readAttribute("level").integerValue }
                  end,
                  
                  :required_certificates => certificate.readNodes("rowset[@name='requiredCertificates']/row").map do |required_certificate|
                    { :id => required_certificate.readAttribute("certificateID").stringValue, :grade => required_certificate.readAttribute("grade").integerValue }
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
        { :id => error.readAttribute("errorCode").integerValue, :text => error.readAttribute("errorText").stringValue }
      end
      
      return errors, xml.cachedUntil
    end
    
    def ref_types
      xml = self.download(Ceres.misc_urls[:ref_types])
      
      refs = xml.readNodes("/eveapi/result/rowset/row").map do |ref|
        { :id => ref.readAttribute("refTypeID").integerValue, :text => ref.readAttribute("refTypeName").stringValue }
      end
      
      return refs, xml.cachedUntil
    end
    
    def skill_tree
      xml = self.download(Ceres.misc_urls[:skill_tree])
      
      skill_groups = xml.readNodes("/eveapi/result/rowset/row").map do |skill_group|
        {
          :id => skill_group.readAttribute("groupID").integerValue,
          :name => skill_group.readAttribute("groupName").stringValue,
          :skills => skill_group.readNodes("rowset/row").map do |skill|
            {
              :id => skill.readAttribute("typeID").integerValue,
              :name => skill.readAttribute("typeName").stringValue,
              :group_id => skill.readAttribute("groupID").stringValue,
              :description => skill.readNode("description").stringValue,
              :rank => skill.readNode("rank").stringValue,
              :primary_attribute => skill.readNode("requiredAttributes/primaryAttribute").stringValue,
              :secondary_attribute => skill.readNode("requiredAttributes/secondaryAttribute").stringValue,
              
              :required_skills => skill.readNodes("rowset[@name='requiredSkills']/row").map do |required_skill|
                { :id => required_skill.readAttribute("typeID").stringValue, :level => required_skill.readAttribute("skillLevel").integerValue }
              end,
              
              :bonuses => skill.readNodes("rowset[@name='skillBonusCollection']/row").map do |bonus|
                { :type => bonus.readAttribute("bonusType").stringValue, :value => bonus.readAttribute("bonusValue").stringValue }
              end
              
            }
          end
        }
      end
      
      return skill_groups, xml.cachedUntil
    end
    
    def identifiers_to_names(*identifiers)
      xml = self.download(Ceres.misc_urls[:identifiers_to_names], ids: identifiers.map { |x| x.to_s.url_escape }.join(","))
      
      names = xml.readNodes("/eveapi/result/rowset/row").map do |name|
        { :id => name.readAttribute("characterID").integerValue, :name => name.readAttribute("name").stringValue }
      end
      
      return names, xml.cachedUntil
    end
    
    def names_to_identifiers(*names)
      xml = self.download(Ceres.misc_urls[:names_to_identifiers], names: names.map { |x| x.to_s.url_escape }.join(","))
      
      identifiers = xml.readNodes("/eveapi/result/rowset/row").map do |id|
        { :id => id.readAttribute("characterID").integerValue, :name => id.readAttribute("name").stringValue }
      end
      
      return identifiers, xml.cachedUntil
    end
  end
end
