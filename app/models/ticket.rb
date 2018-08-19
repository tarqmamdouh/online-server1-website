class Ticket < ApplicationRecord
  belongs_to :user
  has_many :tcomments, dependent: :destroy
  validates :subject , presence: true , length: {minimum: 3 , maximum: 50}
  validates :content , presence: true, length: {minimum: 10 , maximum: 400}
  validates :user_id , presence: true
end