class Invoice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :number, type: String

  belongs_to :user

  mount_uploader :invoice, InvoiceUploader

  validates_presence_of :number
  validates_uniqueness_of :number
end
