class BuyerRegistration < ActiveRecord::Base
  belongs_to :show
  belongs_to :buyer

  validates_presence_of :show_id, :buyer_id
end
