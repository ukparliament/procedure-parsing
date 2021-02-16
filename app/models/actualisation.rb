class Actualisation < ActiveRecord::Base
  
  belongs_to :business_item
  belongs_to :step
end
