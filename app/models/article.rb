class Article < ApplicationRecord
  belongs_to :user
  has_many :article_categories
  has_many :categories, through: :article_categories
has_many :comments
  validates :title , presence: true , length: {minimum: 3 , maximum: 50}
  validates :description , presence: true, length: {minimum: 10 , maximum: 400}
  validates :user_id , presence: true
end