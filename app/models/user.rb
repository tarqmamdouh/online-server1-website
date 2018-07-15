class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username , presence: true , uniqueness: {case_sensitive:false},
            length: {minimum: 3 , maximum: 25}
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
end
