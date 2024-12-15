class JwtDenylist < ApplicationRecord
  self.table_name = 'jwt_denylists'

  validates :jti, presence: true, uniqueness: true
end
