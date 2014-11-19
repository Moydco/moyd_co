class Subscription
  include Mongoid::Document
  field :product,            type: String
  field :description,        type: String
  field :rate,               type: Integer
  field :interval,           type: String
  field :month,              type: Integer
  field :maintenance,        type: Boolean, default: false
  field :item_type,          type: String,  default: 'hours'
  field :item_quantity,      type: Integer
  field :combinable,         type: Boolean, default: false
  field :recurring,          type: Boolean, default: true
  field :enabled,            type: Boolean, default: true

  belongs_to :user

  validates_presence_of  :product, :description, :rate
  validates_inclusion_of :item_type, in: %w(hours tickets)
  validates_inclusion_of :month, in: 1..12, allow_nil: true
end