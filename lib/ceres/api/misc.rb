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
      
      alliances = xml.read_nodes("/eveapi/result/rowset/row").map do |alliance|
        {
          :id => alliance.read_attribute("allianceID").to_i,
          :name => alliance.read_attribute("name").to_s,
          :short_name => alliance.read_attribute("shortName").to_s,
          :executor_id => alliance.read_attribute("executorCorpID").to_i,
          :member_count => alliance.read_attribute("memberCount").to_s,
          :start_date => alliance.read_attribute("name").to_date,
          :member_corporations => alliance.read_nodes("rowset/row").map do |corporation|
            { :id => corporation.read_attribute("corporationID").to_i, :start_date => corporation.read_attribute("startDate").to_date }
          end
        }
      end
      
      return alliances, xml.cached_until
    end
    
    def certificate_tree
      xml = self.download(Ceres.misc_urls[:certificate_tree])
      
      categories = xml.read_nodes("/eveapi/result/rowset/row").map do |category|
        {
          :id => category.read_attribute("categoryID").to_i,
          :name => category.read_attribute("categoryName").to_s,
          :classes => category.read_nodes("rowset/row").map do |klass|
            {
              :id => klass.read_attribute("classID").to_i,
              :name => klass.read_attribute("className").to_s,
              :certificates => klass.read_nodes("rowset/row").map do |certificate|
                {
                  :id => certificate.read_attribute("certificateID").to_i,
                  :grade => certificate.read_attribute("grade").to_i,
                  :corporation_id => certificate.read_attribute("corporationID").to_i,
                  :description => certificate.read_attribute("description").to_s,
                  
                  :required_skills => certificate.read_nodes("rowset[@name='requiredSkills']/row").map do |required_skill|
                    { :id => required_skill.read_attribute("typeID").to_s, :level => required_skill.read_attribute("level").to_i }
                  end,
                  
                  :required_certificates => certificate.read_nodes("rowset[@name='requiredCertificates']/row").map do |required_certificate|
                    { :id => required_certificate.read_attribute("certificateID").to_s, :grade => required_certificate.read_attribute("grade").to_i }
                  end
                }
              end
            }
          end
        }
      end
      
      return categories, xml.cached_until
    end
    
    def errors
      xml = self.download(Ceres.misc_urls[:errors])
      
      errors = xml.read_nodes("/eveapi/result/rowset/row").map do |error|
        { :id => error.read_attribute("errorCode").to_i, :text => error.read_attribute("errorText").to_s }
      end
      
      return errors, xml.cached_until
    end
    
    def ref_types
      xml = self.download(Ceres.misc_urls[:ref_types])
      
      refs = xml.read_nodes("/eveapi/result/rowset/row").map do |ref|
        { :id => ref.read_attribute("refTypeID").to_i, :text => ref.read_attribute("refTypeName").to_s }
      end
      
      return refs, xml.cached_until
    end
    
    def skill_tree
      xml = self.download(Ceres.misc_urls[:skill_tree])
      
      skill_groups = xml.read_nodes("/eveapi/result/rowset/row").map do |skill_group|
        {
          :id => skill_group.read_attribute("groupID").to_i,
          :name => skill_group.read_attribute("groupName").to_s,
          :skills => skill_group.read_nodes("rowset/row").map do |skill|
            {
              :id => skill.read_attribute("typeID").to_i,
              :name => skill.read_attribute("typeName").to_s,
              :group_id => skill.read_attribute("groupID").to_s,
              :description => skill.read_node("description").to_s,
              :rank => skill.read_node("rank").to_s,
              :attribute / :primary => skill.read_node("requiredAttributes/primaryAttribute").to_s,
              :attribute / :secondary => skill.read_node("requiredAttributes/secondaryAttribute").to_s,
              
              :required_skills => skill.read_nodes("rowset[@name='requiredSkills']/row").map do |required_skill|
                { :id => required_skill.read_attribute("typeID").to_s, :level => required_skill.read_attribute("skillLevel").to_i }
              end,
              
              :bonuses => skill.read_nodes("rowset[@name='skillBonusCollection']/row").map do |bonus|
                { :type => bonus.read_attribute("bonusType").to_s, :value => bonus.read_attribute("bonusValue").to_s }
              end
              
            }
          end
        }
      end
      
      return skill_groups, xml.cached_until
    end
    
    def identifiers_to_names(*identifiers)
      xml = self.download(Ceres.misc_urls[:identifiers_to_names], :ids => identifiers.map { |x| x.to_s }.join(","))
      
      names = xml.read_nodes("/eveapi/result/rowset/row").map do |name|
        { :id => name.read_attribute("characterID").to_i, :name => name.read_attribute("name").to_s }
      end
      
      return names, xml.cached_until
    end
    
    def names_to_identifiers(*names)
      xml = self.download(Ceres.misc_urls[:names_to_identifiers], :names => names.map { |x| x.to_s }.join(","))
      
      identifiers = xml.read_nodes("/eveapi/result/rowset/row").map do |id|
        { :id => id.read_attribute("characterID").to_i, :name => id.read_attribute("name").to_s }
      end
      
      return identifiers, xml.cached_until
    end
  end
end
