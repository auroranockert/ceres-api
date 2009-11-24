#
#  exceptions.rb
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
  # 1xx - User input errors
  class WalletNotPreviouslyLoadedError < CeresError; end      # Error Code: 100
  class WalletExhaustedError < CeresError; end                # Error Code: 101, 103
  class WalletPreviouslyLoadedError < CeresError; end         # Error Code: 102
  class InvalidIdentifierError < CeresError; end              # Error Code: 105 - 111, 114, 121 - 123
  class VersionError < CeresError; end                        # Error Code: 112, 113
  class AlreadyDownloadedError < CeresError; end              # Error Code: 115 - 117
  class KillsNotPreviouslyLoadedError < CeresError; end       # Error Code: 118
  class KillsExhaustedError < CeresError; end                 # Error Code: 119
  class KillsPreviouslyLoadedError < CeresError; end          # Error Code: 120
  class NotEnlistedInFactionalWarfareError < CeresError; end  # Error Code: 124, 125

  # 2xx - Authentication and Authorization
  class AuthorizationError < CeresError; end                  # Error Code: 200, 206, 208, 209, 213
  class AuthenticationError < CeresError; end                 # Error Code: 201 - 205, 210 - 212
  class AllianceOrCorporationError < CeresError; end          # Error Code: 207, 214

  # 5xx - Server errors
  class ServerError < CeresError; end                         # Error Code 500 - 525

  # 9xx - Other errors
  class APITemporarilyDisabledError < ServerError; end         # Error Code: 901, 902
  class RateLimitedError < StandardError; end                  # Error Code: 903 (Standard Error to make it *poof*)
end