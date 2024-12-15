class HostelSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :city, :state, :country, :pincode
end
