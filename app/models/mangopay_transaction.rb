class MangopayTransaction < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :tournament
end
