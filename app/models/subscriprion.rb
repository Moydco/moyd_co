class TokenStorage
  include Mongoid::Document
  field :product,            type: String
  field :description,        type: String
  field :rate,               type: Integer
  field :interval,           type: String
  field :month,              type: Integer
  field :maintenance,        type: Boolean, default: false
  field :item_type,          type: String,  default: 'hours'
  field :item_quantity,      type: Integer
  field :cumulable,          type: Boolean, default: false
  field :recurring,          type: Boolean, default: true

  belongs_to :user

  validates_presence_of :product, :description, :rate
  validates_inclusion_of :item_type, in: %w(hours ticket)
  validates_inclusion_of :month, in: 1..12
end