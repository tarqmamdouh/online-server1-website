class Tcomment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  has_attachment :photo

  #validates_presence_of :content, :if => :should_validate_password?
end

