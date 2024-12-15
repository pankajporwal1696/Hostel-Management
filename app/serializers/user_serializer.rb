class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :type
end
