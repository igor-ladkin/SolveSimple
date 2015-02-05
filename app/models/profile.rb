class Profile < ActiveRecord::Base
  belongs_to :user

  def display_name
  	case
  	when self.first_name && self.last_name
  		"#{self.first_name} #{self.last_name}"
  	when self.first_name
  		self.first_name
  	when self.last_name
  		self.last_name
  	when self.nickname
  		self.nickname
  	end	
  end
end
