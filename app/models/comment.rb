class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  validates :content , presence: true, length: {minimum: 2 , maximum: 500}
end
