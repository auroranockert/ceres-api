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
      
      assets = xml.read_nodes("/eveapi/result/rowset/row").map do |asset|
        {
          :id => asset.read_attribute("itemID").to_i,
          :location_id => asset.read_attribute("locationID").to_i,
          :type_id => asset.read_attribute("typeID").to_i,
          :quantity => asset.read_attribute("quantity").to_i,
          :flags => asset.read_attribute("flag").to_i,
          :singleton => (asset.read_attribute("singleton").to_i == 1),
          :contents => asset.read_nodes("rowset/row").map do |item|
            {
              :id => item.read_attribute("itemID").to_i,
              :type_id => item.read_attribute("typeID").to_i,
              :quantity => item.read_attribute("quantity").to_i,
              :flags => item.read_attribute("flag").to_i,
              :singleton => (item.read_attribute("singleton").to_i == 1),
            }
          end
        }
      end
      
      return assets, xml.cached_until
    end
    
    def character_orders
      xml = self.download(Ceres.character_urls[:market_orders])
      
      orders = xml.read_nodes("/eveapi/result/rowset/row").map do |order|
        {
          :id => order.read_attribute("orderID").to_i,
          :character_id => order.read_attribute("charID").to_i,
          :station_id => order.read_attribute("stationID").to_i,
          :volume / :original => order.read_attribute("volEntered").to_i,
          :volume / :remaining => order.read_attribute("volRemaining").to_i,
          :volume / :minimum => order.read_attribute("minVolume").to_i,
          :state => [:active, :closed, :expired, :cancelled, :pending, :character_deleted][order.read_attribute("orderState").to_i],
          :type_id => order.read_attribute("typeID").to_i,
          :range => parse_range(order.read_attribute("range").to_i),
          :duration => order.read_attribute("duration").to_i,
          :escrow => order.read_attribute("escrow").to_f,
          :price => order.read_attribute("price").to_f,
          :type => [:sell, :buy][order.read_attribute("bid").to_i],
          :issued_at => order.read_attribute("issued").to_date
        }
      end
      
      return assets, xml.cached_until
    end
    
    def character_jobs
      xml = self.download(Ceres.character_urls[:industry_jobs])
      
      jobs = xml.read_nodes("/eveapi/result/rowset/row").map do |job|
        {
          :id => job.read_attribute("jobID").to_i,
          :character_id => job.read_attribute("installerID").to_i,
          :assembly_line_id => job.read_attribute("assemblyLineID").to_i,
          :container / :id => job.read_attribute("containerID").to_i,
          :container / :type_id => job.read_attribute("containerLocationID").to_i,
          :container / :location_id => job.read_attribute("containerTypeID").to_i,
          :installed_item / :id => job.read_attribute("installedItemID").to_i,
          :installed_item / :type_id => job.read_attribute("installedItemTypeID").to_i,
          :installed_item / :location_id => job.read_attribute("installedItemLocationID").to_i,
          :installed_item / :quantity => job.read_attribute("installedItemQuantity").to_i,
          :installed_item / :productivity_level => job.read_attribute("installedItemProductivityLevel").to_i,
          :installed_item / :material_level => job.read_attribute("installedItemMaterialLevel").to_i,
          :installed_item / :runs_remaining => job.read_attribute("installedItemLicensedProductionRunsRemaining").to_i,
          :installed_item / :copy => (job.read_attribute("installedItemCopy") == 1),
          :installed_item / :flags => job.read_attribute("installedItemFlag").to_i,
          :output / :type_id => job.read_attribute("outputTypeID").to_i,
          :output / :location_id => job.read_attribute("outputLocationID").to_i,
          :output / :flags => job.read_attribute("outputFlag").to_i,
          :runs => job.read_attribute("runs").to_i,
          :material / :multiplier => job.read_attribute("materialMultiplier").to_f,
          :material / :character_multiplier => job.read_attribute("charMaterialMultiplier").to_f,
          :time / :multiplier => job.read_attribute("timeMultiplier").to_f,
          :time / :character_multiplier => job.read_attribute("charTimeMultiplier").to_f,
          :completed => (job.read_attribute("completed").to_i == 1),
          :completed_successfully => (job.read_attribute("completedSuccessfully").to_i == 1),
          :completed_status => [:failed, :delivered, :aborted, :gm_intervention, :unanchored, :destroyed][job.read_attribute("completedStatus").to_i],
          :activity_id => job.read_attribute("activityID").to_i,
          :installed_at => job.read_attribute("installTime").to_date,
          :began_at => job.read_attribute("beginProductionTime").to_date,
          :ended_at => job.read_attribute("endProductionTime").to_date,
          :paused_at => job.read_attribute("pauseProductionTime").to_date
        }
      end
      
      return jobs, xml.cached_until
    end
    
    def character_balance
      xml = self.download(Ceres.character_urls[:wallet_balance])
      
      return xml.read_node("/eveapi/result/rowset/row").read_attribute("balance").to_f, xml.cached_until
    end
    
    def character_transactions(before_transaction_id = nil)
      if before_transaction_id
        xml = self.download(Ceres.character_urls[:wallet_transactions], beforeTransID => before_transaction_id.to_s)
      else
        xml = self.download(Ceres.character_urls[:wallet_transactions])
      end
      
      transactions = xml.read_nodes("/eveapi/result/rowset/row").map do |transaction|
        {
          :id => transaction.read_attribute("transactionID").to_i,
          :date => transaction.read_attribute("transactionDateTime").to_date,
          :quantity => transaction.read_attribute("quantity").to_i,
          
          :item / :type_id => transaction.read_attribute("typeID").to_i,
          :item / :type_name => transaction.read_attribute("typeName").to_s,
          :price => transaction.read_attribute("price").to_f,
          :client / :id => transaction.read_attribute("clientID").to_i,
          :client / :name => transaction.read_attribute("clientName").to_s,
          :station / :id => transaction.read_attribute("stationID").to_i,
          :station / :name => transaction.read_attribute("stationName").to_s,
          
          :type => transaction.read_attribute("transactionType").to_s.intern,
          :for => transaction.read_attribute("transactionFor").to_s.intern
        }
      end
      
      return transactions, xml.cached_until
    end
    
    def character_journal(before_ref_id = nil)
      if before_ref_id
        xml = self.download(Ceres.character_urls[:wallet_journal], :beforeRefID => before_ref_id.to_s)
      else
        xml = self.download(Ceres.character_urls[:wallet_journal])
      end
      
      entries = xml.read_nodes("/eveapi/result/rowset/row").map do |entry|
        {
          :date => entry.read_attribute("date").to_date,
          :ref_id => entry.read_attribute("refID").to_i,
          :ref_type_id => entry.read_attribute("refTypeID").to_i,
          :first / :id => entry.read_attribute("ownerID1").to_i,
          :first / :name => entry.read_attribute("ownerName1").to_s,
          :second / :id => entry.read_attribute("ownerID2").to_i,
          :second / :name => entry.read_attribute("ownerName2").to_s,
          :argument / :id => entry.read_attribute("argID1").to_i,
          :argument / :name => entry.read_attribute("argName1").to_s,
          :amount => entry.read_attribute("amount").to_f,
          :balance => entry.read_attribute("balance").to_f,
          :reason => entry.read_attribute("reason").to_s
        }
      end
      
      return entries, xml.cached_until
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
