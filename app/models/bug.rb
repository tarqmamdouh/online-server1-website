class Bug < ApplicationRecord
  belongs_to :user
  has_attachment :image
  validates :title , presence: true , length: {minimum: 3 , maximum: 50}
  validates :details , presence: true, length: {minimum: 10 , maximum: 400}
  validates :user_id , presence: true
  validates :username , presence: true, length: {minimum: 3 , maximum: 25}

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validates :name , presence: true
  validates_format_of :name, with: /^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$/, :multiline => true
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email , presence: true ,length: {maximum:105 },format: {with: VALID_EMAIL_REGEX}
end