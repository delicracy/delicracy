class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  field :details, type: String
  
  belongs_to :basis, class_name: 'Statement', optional: true # TODO: do u need optinal true?
  belongs_to :user
end
