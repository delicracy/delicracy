class Category
  include Mongoid::Document
  field :name, type: String
  field :type, type: String

  has_many :races
end
