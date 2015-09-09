class Invitation < ActiveRecord::Base
  include Tokenable
  
  belongs_to :inviter, class_name: 'User'

  validates_presence_of :invitee_name
  validates_presence_of :invitee_email
  validates_presence_of :message
  validates_presence_of :inviter
end