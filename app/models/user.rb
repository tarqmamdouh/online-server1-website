class User < ApplicationRecord
  has_many :articles
  has_many :comments, dependent: :destroy
  attr_accessor :terms_of_service
  validates :terms_of_service, :acceptance => true
  # Include default devise modules. Others available are:

  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :encryptable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username , presence: true , uniqueness: {case_sensitive:false},
            length: {minimum: 3 , maximum: 25}

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
validates :name , presence: true
  validates_format_of :name, with: /^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$/, :multiline => true


  attr_accessor :login
  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end

  def password_salt
    'no salt'
  end

  def password_salt=(new_salt)
    end
  def self.search(param)
    param.strip!
    param.downcase!
    to_send_back =(username_matches(param)).uniq
    return nil unless to_send_back
    to_send_back
  end
  def self.username_matches(param)
    matches('username',param)
  end
  def self.matches(field_name, param)
    User.where("#{field_name} like ?","%#{param}%")
  end
  def except_current_user(users)
    users.reject{|user| user.id == self.id}
  end

end
