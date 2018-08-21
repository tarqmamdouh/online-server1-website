class Tcomment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  has_attachment :photo

end
