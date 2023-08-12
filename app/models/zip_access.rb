class ZipAccess < ApplicationRecord
  belongs_to :user

  validates :zipcode, presence: true
end
