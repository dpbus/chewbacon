class User < ApplicationRecord
  has_many :weigh_ins
  has_many :memberships
  has_many :groups, through: :memberships

  has_secure_password

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

  def weight_delta(start_date = 100.years.ago, end_date = Time.zone.now)
    if (weigh_ins.where("date >= ? AND date <= ?", start_date,end_date.to_date.end_of_day).count > 0)
      start = weigh_ins.order(:date).where("date >= ?", start_date).first.weight
      latest = weigh_ins.order(:date).where("date <= ?", end_date.to_date.end_of_day).last.weight

      latest - start
    else
      0.0
    end

    rescue
      start = 0
      latest = 0
  end

  def weight_delta_percent(start_date = 100.years.ago, end_date = Time.zone.now)
    if (weigh_ins.where("date >= ?", start_date).count > 0)
      start = weigh_ins.order(:date).where("date >= ?", start_date).first.weight
      (100*weight_delta(start_date, end_date)/start).round(2)
    else
      0.0
    end
  end
end
