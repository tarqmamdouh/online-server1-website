class User < ApplicationRecord
  has_many :articles
  has_many :comments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username , presence: true , uniqueness: {case_sensitive:false},
            length: {minimum: 3 , maximum: 25}
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  validates_inclusion_of :birthdate,
                         :in => Date.new(1900)..Time.now.years_ago(13).to_date,
                         :message => 'dosent meet requirements'

  attr_accessor :login
  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end
end
