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
    characters:                     "/account/Characters.xml.aspx",
  }

  @character_urls = {
    sheet:                          "/char/CharacterSheet.xml.aspx",

    training:                       "/char/SkillInTraining.xml.aspx",
    skill_queue:                    "/char/SkillQueue.xml.aspx",

    assets:                         "/char/AssetList.xml.aspx",
    market_orders:                  "/char/MarketOrders.xml.aspx",
    industry_jobs:                  "/char/IndustryJobs.xml.aspx",
    kills:                          "/char/KillLog.xml.aspx",

    faction_warfare:                "/char/FacWarStats.xml.aspx",

    medals:                         "/char/Medals.xml.aspx",

    wallet_balance:                 "/char/AccountBalance.xml.aspx",
    wallet_transactions:            "/char/WalletTransactions.xml.aspx",
    wallet_journal:                 "/char/WalletJournal.xml.aspx",

    standings:                      "/char/Standings.xml.aspx"
  }

  @corporation_urls = {
    sheet:                          "/corp/CorporationSheet.xml.aspx",

    assets:                         "/corp/AssetList.xml.aspx",
    market_orders:                  "/corp/MarketOrders.xml.aspx",
    industry_jobs:                  "/corp/IndustryJobs.xml.aspx",
    kills:                          "/corp/KillLog.xml.aspx",

    faction_warfare:                "/corp/FacWarStats.xml.aspx",

    medals:                         "/corp/Medals.xml.aspx",
    medals_issued:                  "/corp/MemberMedals.xml.aspx",
    titles:                         "/corp/Titles.xml.aspx",

    wallet_balance:                 "/corp/AccountBalance.xml.aspx",
    wallet_transactions:            "/corp/WalletTransactions.xml.aspx",
    wallet_journal:                 "/corp/WalletJournal.xml.aspx",

    member_security:                "/corp/MemberSecurity.xml.aspx",
    member_tracking:                "/corp/MemberTracking.xml.aspx",

    member_security_log:            "/corp/MemberSecurityLog.xml.aspx",
    container_log:                  "/corp/ContainerLog.xml.aspx",

    standings:                      "/corp/Standings.xml.aspx",

    shareholders:                   "/corp/Sharholders.xml.aspx"
  }

  @faction_warfare_urls = {
    statistics:                     "/eve/FacWarStats.xml.aspx",
    top_100:                        "/eve/FacWarTopStats.xml.aspx",
    occupancy:                      "/map/FacWarSystems.xml.aspx"
  }

  @map_urls = {
    conquerable_stations:           "/eve/ConquerableStationList.xml.aspx",
    jumps:                          "/map/Jumps.xml.aspx",
    kills:                          "/map/Kills.xml.aspx",
    sovereignty:                    "/map/Sovereignty.xml.aspx"
  }

  @misc_urls = {
    alliances:                      "/eve/AllianceList.xml.aspx",
    certificate_tree:               "/eve/CertificateTree.xml.aspx",
    identifiers_to_names:           "/eve/CharacterName.xml.aspx",
    names_to_identifiers:           "/eve/CharacterID.xml.aspx",
    errors:                         "/eve/ErrorList.xml.aspx",
    ref_types:                      "/eve/RefTypes.xml.aspx",
    skill_tree:                     "/eve/SkillTree.xml.aspx"
  }

  @starbase_urls = {
    list:                           "/corp/StarbaseList.xml.aspx",
    details:                        "/corp/StarbaseDetail.xml.aspx"
  }

  @server_urls = {
    status:                         "/Server/ServerStatus.xml.aspx"
  }
  
  def self.base_url; @base_url; end
  def self.account_urls; @account_urls; end
  def self.character_urls; @character_urls; end
  def self.corporation_urls; @corporation_urls; end
  def self.faction_warfare_urls; @faction_warfare_urls; end
  def self.map_urls; @map_urls; end
  def self.misc_urls; @misc_urls; end
  def self.starbase_urls; @starbase_urls; end
  def self.server_urls; @server_urls; end
end
