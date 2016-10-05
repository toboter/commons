class Tag < ApplicationRecord
  has_many :taggings
  has_many :subjects, through: :taggings
  
  validates :name, presence: true
end
