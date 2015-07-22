class Contact < ActiveRecord::Base
  after_create :send_email_to_wetennis
  after_create :send_confirmation_email

  validates :email, presence: :true
  validates :object, presence: :true
  validates :content, presence: :true

  private


  def send_email_to_wetennis
    ContactMailer.send_message_to_wetennis(self).deliver
  end

  def send_confirmation_email
    ContactMailer.confirmation_email(self).deliver
  end
end
