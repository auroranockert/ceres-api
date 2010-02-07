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
          :id => asset.readAttribute("itemID").to_i,
          :location_id => asset.readAttribute("locationID").to_i,
          :type_id => asset.readAttribute("typeID").to_i,
          :quantity => asset.readAttribute("quantity").to_i,
          :flags => asset.readAttribute("flag").to_i,
          :singleton => (asset.readAttribute("singleton").to_i == 1),
          :contents => asset.readNodes("rowset/row").map do |item|
            {
              :id => item.readAttribute("itemID").to_i,
              :type_id => item.readAttribute("typeID").to_i,
              :quantity => item.readAttribute("quantity").to_i,
              :flags => item.readAttribute("flag").to_i,
              :singleton => (item.readAttribute("singleton").to_i == 1),
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
          :id => order.readAttribute("orderID").to_i,
          :character_id => order.readAttribute("charID").to_i,
          :station_id => order.readAttribute("stationID").to_i,
          :volume / :original => order.readAttribute("volEntered").to_i,
          :volume / :remaining => order.readAttribute("volRemaining").to_i,
          :volume / :minimum => order.readAttribute("minVolume").to_i,
          :state => [:active, :closed, :expired, :cancelled, :pending, :character_deleted][order.readAttribute("orderState").to_i],
          :type_id => order.readAttribute("typeID").to_i,
          :range => parse_range(order.readAttribute("range").to_i),
          :duration => order.readAttribute("duration").to_i,
          :escrow => order.readAttribute("escrow").floatValue,
          :price => order.readAttribute("price").floatValue,
          :type => [:sell, :buy][order.readAttribute("bid").to_i],
          :issued_at => order.readAttribute("issued").to_date
        }
      end
      
      return assets, xml.cachedUntil
    end
    
    def character_jobs
      xml = self.download(Ceres.character_urls[:industry_jobs])
      
      jobs = xml.readNodes("/eveapi/result/rowset/row").map do |job|
        {
          :id => job.readAttribute("jobID").to_i,
          :character_id => job.readAttribute("installerID").to_i,
          :assembly_line_id => job.readAttribute("assemblyLineID").to_i,
          :container / :id => job.readAttribute("containerID").to_i,
          :container / :type_id => job.readAttribute("containerLocationID").to_i,
          :container / :location_id => job.readAttribute("containerTypeID").to_i,
          :installed_item / :id => job.readAttribute("installedItemID").to_i,
          :installed_item / :type_id => job.readAttribute("installedItemTypeID").to_i,
          :installed_item / :location_id => job.readAttribute("installedItemLocationID").to_i,
          :installed_item / :quantity => job.readAttribute("installedItemQuantity").to_i,
          :installed_item / :productivity_level => job.readAttribute("installedItemProductivityLevel").to_i,
          :installed_item / :material_level => job.readAttribute("installedItemMaterialLevel").to_i,
          :installed_item / :runs_remaining => job.readAttribute("installedItemLicensedProductionRunsRemaining").to_i,
          :installed_item / :copy => (job.readAttribute("installedItemCopy") == 1),
          :installed_item / :flags => job.readAttribute("installedItemFlag").to_i,
          :output / :type_id => job.readAttribute("outputTypeID").to_i,
          :output / :location_id => job.readAttribute("outputLocationID").to_i,
          :output / :flags => job.readAttribute("outputFlag").to_i,
          :runs => job.readAttribute("runs").to_i,
          :material / :multiplier => job.readAttribute("materialMultiplier").floatValue,
          :material / :character_multiplier => job.readAttribute("charMaterialMultiplier").floatValue,
          :time / :multiplier => job.readAttribute("timeMultiplier").floatValue,
          :time / :character_multiplier => job.readAttribute("charTimeMultiplier").floatValue,
          :completed => (job.readAttribute("completed").to_i == 1),
          :completed_successfully => (job.readAttribute("completedSuccessfully").to_i == 1),
          :completed_status => [:failed, :delivered, :aborted, :gm_intervention, :unanchored, :destroyed][job.readAttribute("completedStatus").to_i],
          :activity_id => job.readAttribute("activityID").to_i,
          :installed_at => job.readAttribute("installTime").to_date,
          :began_at => job.readAttribute("beginProductionTime").to_date,
          :ended_at => job.readAttribute("endProductionTime").to_date,
          :paused_at => job.readAttribute("pauseProductionTime").to_date
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
          :id => transaction.readAttribute("transactionID").to_i,
          :date => transaction.readAttribute("transactionDateTime").to_date,
          :quantity => transaction.readAttribute("quantity").to_i,
          
          :item / :type_id => transaction.readAttribute("typeID").to_i,
          :item / :type_name => transaction.readAttribute("typeName").to_s,
          :price => transaction.readAttribute("price").floatValue,
          :client / :id => transaction.readAttribute("clientID").to_i,
          :client / :name => transaction.readAttribute("clientName").to_s,
          :station / :id => transaction.readAttribute("stationID").to_i,
          :station / :name => transaction.readAttribute("stationName").to_s,
          
          :type => transaction.readAttribute("transactionType").to_s.intern,
          :for => transaction.readAttribute("transactionFor").to_s.intern
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
          :date => entry.readAttribute("date").to_date,
          :ref_id => entry.readAttribute("refID").to_i,
          :ref_type_id => entry.readAttribute("refTypeID").to_i,
          :first / :id => entry.readAttribute("ownerID1").to_i,
          :first / :name => entry.readAttribute("ownerName1").to_s,
          :second / :id => entry.readAttribute("ownerID2").to_i,
          :second / :name => entry.readAttribute("ownerName2").to_s,
          :argument / :id => entry.readAttribute("argID1").to_i,
          :argument / :name => entry.readAttribute("argName1").to_s,
          :amount => entry.readAttribute("amount").floatValue,
          :balance => entry.readAttribute("balance").floatValue,
          :reason => entry.readAttribute("reason").to_s
        }
      end
      
      return entries, xml.cachedUntil
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
