#
#  urls.rb
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
  @base_url = "http://api.eve-online.com"
  
  
  @account_urls = {
    characters:                     "#{@base_url}/account/Characters.xml.aspx",
  }
  
  @character_urls = {
    sheet:                          "#{@base_url}/char/CharacterSheet.xml.aspx",
    
    training:                       "#{@base_url}/char/SkillInTraining.xml.aspx",
    skill_queue:                    "#{@base_url}/char/SkillQueue.xml.aspx",
    
    assets:                         "#{@base_url}/char/AssetList.xml.aspx",
    market_orders:                  "#{@base_url}/char/MarketOrders.xml.aspx",
    industry_jobs:                  "#{@base_url}/char/IndustryJobs.xml.aspx",
    kills:                          "#{@base_url}/char/KillLog.xml.aspx",
    
    faction_warfare:                "#{@base_url}/char/FacWarStats.xml.aspx",
    
    medals:                         "#{@base_url}/char/Medals.xml.aspx",
    
    wallet_balance:                 "#{@base_url}/char/AccountBalance.xml.aspx",
    wallet_transactions:            "#{@base_url}/char/WalletTransactions.xml.aspx",
    wallet_journal:                 "#{@base_url}/char/WalletJournal.xml.aspx",
  
    standings:                      "#{@base_url}/char/Standings.xml.aspx"
  }
  
  @corporation_urls = {
    sheet:                          "#{@base_url}/corp/CorporationSheet.xml.aspx",
    
    assets:                         "#{@base_url}/corp/AssetList.xml.aspx",
    market_orders:                  "#{@base_url}/corp/MarketOrders.xml.aspx",
    industry_jobs:                  "#{@base_url}/corp/IndustryJobs.xml.aspx",
    kills:                          "#{@base_url}/corp/KillLog.xml.aspx",
    
    faction_warfare:                "#{@base_url}/corp/FacWarStats.xml.aspx",
    
    medals:                         "#{@base_url}/corp/Medals.xml.aspx",
    medals_issued:                  "#{@base_url}/corp/MemberMedals.xml.aspx",
    titles:                         "#{@base_url}/corp/Titles.xml.aspx",
    
    wallet_balance:                 "#{@base_url}/corp/AccountBalance.xml.aspx",
    wallet_transactions:            "#{@base_url}/corp/WalletTransactions.xml.aspx",
    wallet_journal:                 "#{@base_url}/corp/WalletJournal.xml.aspx",
    
    member_security:                "#{@base_url}/corp/MemberSecurity.xml.aspx",
    member_tracking:                "#{@base_url}/corp/MemberTracking.xml.aspx",
    
    member_security_log:            "#{@base_url}/corp/MemberSecurityLog.xml.aspx",
    container_log:                  "#{@base_url}/corp/ContainerLog.xml.aspx",
    
    standings:                      "#{@base_url}/corp/Standings.xml.aspx",
    
    shareholders:                   "#{@base_url}/corp/Sharholders.xml.aspx"
  }
  
  @faction_warfare_urls = {
    statistics:                     "#{@base_url}/eve/FacWarStats.xml.aspx",
    top_100:                        "#{@base_url}/eve/FacWarTopStats.xml.aspx",
    occupancy:                      "#{@base_url}/map/FacWarSystems.xml.aspx"
  }
  
  @map_urls = {
    conquerable_stations:           "#{@base_url}/eve/ConquerableStationList.xml.aspx",
    jumps:                          "#{@base_url}/map/Jumps.xml.aspx",
    kills:                          "#{@base_url}/map/Kills.xml.aspx",
    sovereignty:                    "#{@base_url}/map/Sovereignty.xml.aspx"
  }
  
  @misc_urls = {
    alliances:                      "#{@base_url}/eve/AllianceList.xml.aspx",
    certificate_tree:               "#{@base_url}/eve/CertificateTree.xml.aspx",
    identifiers_to_names:           "#{@base_url}/eve/CharacterName.xml.aspx",
    names_to_identifiers:           "#{@base_url}/eve/CharacterID.xml.aspx",
    errors:                         "#{@base_url}/eve/ErrorList.xml.aspx",
    ref_types:                      "#{@base_url}/eve/RefTypes.xml.aspx",
    skill_tree:                     "#{@base_url}/eve/SkillTree.xml.aspx"      
  }
  
  @starbase_urls = {
    list:                           "#{@base_url}/corp/StarbaseList.xml.aspx",
    details:                        "#{@base_url}/corp/StarbaseDetail.xml.aspx"
  }
  
  @server_urls = {
    status:                         "#{@base_url}/Server/ServerStatus.xml.aspx"
  }
  
  def self.account_urls; @account_urls; end
  def self.character_urls; @character_urls; end
  def self.corporation_urls; @corporation_urls; end
  def self.faction_warfare_urls; @faction_warfare_urls; end
  def self.map_urls; @map_urls; end
  def self.misc_urls; @misc_urls; end
  def self.starbase_urls; @starbase_urls; end
  def self.server_urls; @server_urls; end
end
