class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'

  validates_presence_of :invitee_name
  validates_presence_of :invitee_email
  validates_presence_of :message
  validates_presence_of :inviter

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end