class Book < ActiveRecord::Base
  validates_length_of :title, :minimum => 10
end
