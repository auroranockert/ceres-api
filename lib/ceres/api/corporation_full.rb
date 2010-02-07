#
#  corporation_full.rb
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
    def corporation_assets
      xml = self.download(Ceres.corporation_urls[:assets])
      
      assets = xml.readNodes("/eveapi/result/rowset/row").map do |asset|
        {
          :id => asset.readAttribute("itemID").integerValue,
          :location_id => asset.readAttribute("locationID").integerValue,
          :type_id => asset.readAttribute("typeID").integerValue,
          :quantity => asset.readAttribute("quantity").integerValue,
          :flags => asset.readAttribute("flag").integerValue,
          :singleton => (asset.readAttribute("singleton").integerValue == 1),
          :contents => asset.readNodes("rowset/row").map do |item|
            {
              :id => item.readAttribute("itemID").integerValue,
              :type_id => item.readAttribute("typeID").integerValue,
              :quantity => item.readAttribute("quantity").integerValue,
              :flags => item.readAttribute("flag").integerValue,
              :singleton => (item.readAttribute("singleton").integerValue == 1),
            }
          end
        }
      end
      
      return assets, xml.cachedUntil
    end
  end
end

# market_orders:                  "#{@base_url}/corp/MarketOrders.xml.aspx",
# industry_jobs:                  "#{@base_url}/corp/IndustryJobs.xml.aspx",
# kills:                          "#{@base_url}/corp/KillLog.xml.aspx",
# faction_warfare:                "#{@base_url}/corp/FacWarStats.xml.aspx",
# titles:                         "#{@base_url}/corp/Titles.xml.aspx",
# wallet_balance:                 "#{@base_url}/corp/AccountBalance.xml.aspx",
# wallet_transactions:            "#{@base_url}/corp/WalletTransactions.xml.aspx",
# wallet_journal:                 "#{@base_url}/corp/WalletJournal.xml.aspx",
# member_security:                "#{@base_url}/corp/MemberSecurity.xml.aspx",
# member_tracking:                "#{@base_url}/corp/MemberTracking.xml.aspx",
# member_security_log:            "#{@base_url}/corp/MemberSecurityLog.xml.aspx",
# container_log:                  "#{@base_url}/corp/ContainerLog.xml.aspx",
# standings:                      "#{@base_url}/corp/Standings.xml.aspx",
# shareholders:                   "#{@base_url}/corp/Sharholders.xml.aspx"
