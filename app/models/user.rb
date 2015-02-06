class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :authorizations, dependent: :delete_all
  has_many :questions
  has_many :answers
  has_many :comments
  has_one :profile

  delegate :first_name, :last_name, :nickname, to: :profile

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  accepts_nested_attributes_for :profile

  def self.find_for_oauth(auth)
  	authorization = Authorization.find_or_create_by(uid: auth.uid, provider: auth.provider)

    user = authorization.user

    if user.nil?
      email_is_verified = auth.info.email && ( auth.info.verified || auth.info.verified_email )
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email

      if user.nil?
        user = User.new(
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    if authorization.user != user
      authorization.user = user
      authorization.save!
    end

    user
  end

  def display_name
    self.profile.display_name || self.email
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def profile
    super || build_profile
  end

  def self.send_daily_digest
    find_each do |user|
      DailyMailer.delay.digest(user)
    end
  end
end
