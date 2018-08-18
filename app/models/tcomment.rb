class Tcomment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  validates :content , presence: true, length: {minimum: 2 , maximum: 500}
  has_one_attached :image
  #delegate :image_file_name, to: :image, allow_nil: true
  end
