class Ticket < ApplicationRecord
  belongs_to :user
  has_many :tcomments, dependent: :destroy
  has_attachment :image
  validates :subject , presence: true , length: {minimum: 10 , maximum: 50}
  validates :content , presence: true, length: {minimum: 20 , maximum: 600}
  validates :user_id , presence: true

end