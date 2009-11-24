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

# industry_jobs:                  "#{@base_url}/char/IndustryJobs.xml.aspx",
# kills:                          "#{@base_url}/char/KillLog.xml.aspx",

module Ceres
  class API
    def character_assets
      xml = self.download(Ceres.character_urls[:assets])
      
      assets = xml.readNodes("/eveapi/result/rowset/row").map do |asset|
        {
          :id => asset.readAttribute("itemID").integerValue,
          :location_id => asset.readAttribute("locationID").integerValue,
          :type_id => asset.readAttribute("typeID").integerValue,
          :quantity => asset.readAttribute("quantity").integerValue,
          :flags => parse_inventory_flags(asset.readAttribute("flag").integerValue),
          :singleton => (asset.readAttribute("singleton").integerValue == 1),
          :contents => asset.readNodes("rowset/row").map do |item|
            {
              :id => item.readAttribute("itemID").integerValue,
              :type_id => item.readAttribute("typeID").integerValue,
              :quantity => item.readAttribute("quantity").integerValue,
              :flags => parse_inventory_flags(item.readAttribute("flag").integerValue),
              :singleton => (item.readAttribute("singleton").integerValue == 1),
            }
          end
        }
      end
      
      return assets, xml.cachedUntil
    end
    
    def character_orders
      xml = self.download(Ceres.character_urls[:market_orders])
      
      orders = xml.readNodes("/eveapi/result/rowset/row").map do |order|
        {
          :id => order.readAttribute("orderID").integerValue,
          :character_id => order.readAttribute("charID").integerValue,
          :station_id => order.readAttribute("stationID").integerValue,
          :volume / :original => order.readAttribute("volEntered").integerValue,
          :volume / :remaining => order.readAttribute("volRemaining").integerValue,
          :volume / :minimum => order.readAttribute("minVolume").integerValue,
          :state => [:active, :closed, :expired, :cancelled, :pending, :character_deleted][order.readAttribute("orderState").integerValue],
          :type_id => order.readAttribute("typeID").integerValue,
          :range => parse_range(order.readAttribute("range").integerValue),
          :duration => order.readAttribute("duration").integerValue,
          :escrow => order.readAttribute("escrow").floatValue,
          :price => order.readAttribute("price").floatValue,
          :type => [:sell, :buy][order.readAttribute("bid").integerValue],
          :issued_at => order.readAttribute("issued").dateValue
        }
      end
      
      return assets, xml.cachedUntil
    end
    
    def character_jobs
      xml = self.download(Ceres.character_urls[:industry_jobs])
      
      jobs = xml.readNodes("/eveapi/result/rowset/row").map do |job|
        {
          :id => job.readAttribute("jobID").integerValue,
          :character_id => job.readAttribute("installerID").integerValue,
          :assembly_line_id => job.readAttribute("assemblyLineID").integerValue,
          :container / :id => job.readAttribute("containerID").integerValue,
          :container / :type_id => job.readAttribute("containerLocationID").integerValue,
          :container / :location_id => job.readAttribute("containerTypeID").integerValue,
          :installed_item / :id => job.readAttribute("installedItemID").integerValue,
          :installed_item / :type_id => job.readAttribute("installedItemTypeID").integerValue,
          :installed_item / :location_id => job.readAttribute("installedItemLocationID").integerValue,
          :installed_item / :quantity => job.readAttribute("installedItemQuantity").integerValue,
          :installed_item / :productivity_level => job.readAttribute("installedItemProductivityLevel").integerValue,
          :installed_item / :material_level => job.readAttribute("installedItemMaterialLevel").integerValue,
          :installed_item / :runs_remaining => job.readAttribute("installedItemLicensedProductionRunsRemaining").integerValue,
          :installed_item / :copy => (job.readAttribute("installedItemCopy") == 1),
          :installed_item / :flags => parse_inventory_flags(job.readAttribute("installedItemFlag").integerValue),
          :output / :type_id => job.readAttribute("outputTypeID").integerValue,
          :output / :location_id => job.readAttribute("outputLocationID").integerValue,
          :output / :flags => parse_inventory_flags(job.readAttribute("outputFlag").integerValue),
          :runs => job.readAttribute("runs").integerValue,
          :material / :multiplier => job.readAttribute("materialMultiplier").floatValue,
          :material / :character_multiplier => job.readAttribute("charMaterialMultiplier").floatValue,
          :time / :multiplier => job.readAttribute("timeMultiplier").floatValue,
          :time / :character_multiplier => job.readAttribute("charTimeMultiplier").floatValue,
          :completed => (job.readAttribute("completed").integerValue == 1),
          :completed_successfully => (job.readAttribute("completedSuccessfully").integerValue == 1),
          :completed_status => [:failed, :delivered, :aborted, :gm_intervention, :unanchored, :destroyed][job.readAttribute("completedStatus").integerValue],
          :activity_id => job.readAttribute("activityID").integerValue,
          :installed_at => job.readAttribute("installTime").dateValue,
          :began_at => job.readAttribute("beginProductionTime").dateValue,
          :ended_at => job.readAttribute("endProductionTime").dateValue,
          :paused_at => job.readAttribute("pauseProductionTime").dateValue
        }
      end
      
      return jobs, xml.cachedUntil
    end
    
    def character_balance
      xml = self.download(Ceres.character_urls[:wallet_balance])
      
      return xml.readNode("/eveapi/result/rowset/row").readAttribute("balance").floatValue, xml.cachedUntil
    end
    
    def character_transactions(before_transaction_id = nil)
      if before_transaction_id
        xml = self.download(Ceres.character_urls[:wallet_transactions], beforeTransID: before_transaction_id.to_s)
      else
        xml = self.download(Ceres.character_urls[:wallet_transactions])
      end
      
      transactions = xml.readNodes("/eveapi/result/rowset/row").map do |transaction|
        {
          :id => transaction.readAttribute("transactionID").integerValue,
          :date => transaction.readAttribute("transactionDateTime").dateValue,
          :quantity => transaction.readAttribute("quantity").integerValue,
          
          :item / :type_id => transaction.readAttribute("typeID").integerValue,
          :item / :type_name => transaction.readAttribute("typeName").stringValue,
          :price => transaction.readAttribute("price").floatValue,
          :client / :id => transaction.readAttribute("clientID").integerValue,
          :client / :name => transaction.readAttribute("clientName").stringValue,
          :station / :id => transaction.readAttribute("stationID").integerValue,
          :station / :name => transaction.readAttribute("stationName").stringValue,
          
          :type => transaction.readAttribute("transactionType").stringValue.intern,
          :for => transaction.readAttribute("transactionFor").stringValue.intern
        }
      end
      
      return transactions, xml.cachedUntil
    end
    
    def character_journal(before_ref_id = nil)
      if before_ref_id
        xml = self.download(Ceres.character_urls[:wallet_journal], beforeRefID: before_ref_id.to_s)
      else
        xml = self.download(Ceres.character_urls[:wallet_journal])
      end
      
      entries = xml.readNodes("/eveapi/result/rowset/row").map do |entry|
        {
          :date => entry.readAttribute("date").dateValue,
          :ref_id => entry.readAttribute("refID").integerValue,
          :ref_type_id => entry.readAttribute("refTypeID").integerValue,
          :first / :id => entry.readAttribute("ownerID1").integerValue,
          :first / :name => entry.readAttribute("ownerName1").stringValue,
          :second / :id => entry.readAttribute("ownerID2").integerValue,
          :second / :name => entry.readAttribute("ownerName2").stringValue,
          :argument / :id => entry.readAttribute("argID1").integerValue,
          :argument / :name => entry.readAttribute("argName1").stringValue,
          :amount => entry.readAttribute("amount").floatValue,
          :balance => entry.readAttribute("balance").floatValue,
          :reason => entry.readAttribute("reason").stringValue
        }
      end
      
      return entries, xml.cachedUntil
    end
    
  private
    def parse_inventory_flags(flag)
      case flag
      when 0 then :none
      when 1 then :wallet
      when 2 then :factory
      when 4 then :hangar
      when 5 then :cargo
      when 6 then :briefcase
      when 7 then :skill
      when 8 then :reward
      when 9 then :connected
      when 10 then :disconnected
      when 11 .. 18 then :low_slot
      when 19 .. 26 then :mid_slot
      when 27 .. 34 then :high_slot
      when 35 then :fixed_slot
      when 56 then :capsule
      when 57 then :pilot
      when 58 then :passenger
      when 59 then :boarding_gate
      when 60 then :crew
      when 61 then :skill_in_training
      when 62 then :corporation_market
      when 63 then :locked
      when 64 then :unlocked
      when 70 .. 85 then :office_slot
      when 86 then :bonus
      when 87 then :drone_bay
      when 88 then :booster
      when 89 then :implant
      when 90 then :ship_hangar
      when 91 then :ship_offline
      when 92 .. 99 then :rig_slot
      when 100 then :factory_operation
      when 114 .. 121 then :corporation_access_group
      else
        raise ArgumentError, "oh dear, flag (#{flag}) not in code, please fix."
      end
    end
    
    def parse_range(range)
      case range
      when -1
        :station
      when 0
        :solar_system
      when 32767
        :region
      else
        range
      end
    end
  end
end
