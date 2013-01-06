class User < ActiveRecord::Base
  has_many :weigh_ins
  has_many :memberships
  has_many :groups, through: :memberships
  
  has_secure_password
  
  attr_accessible :name, :email, :password, :password_confirmation
  
  validates :name, presence: true
  validates :email, presence: true,
    format: { with: /.+@.+\..+/i, unless: lambda { |u| u.email.blank? } },
    length: { maximum: 255 },
    uniqueness: true
    
  before_create { generate_token(:auth_token) }
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    Notifications.password_reset(self).deliver
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
    
  def self.find_by_email(email)
    where('lower(email) = ?', email.downcase).first
  end
  
  def name_and_email
    "#{name} (#{email})"
  end
  
  def weight_delta
    start = weigh_ins.order(:date).first.weight
    latest = weigh_ins.order(:date).last.weight
    
    latest - start
  end
  
  def weight_delta_percent
    start = weigh_ins.order(:date).first.weight
    
    (100*weight_delta/start).round(2)
  end
end
