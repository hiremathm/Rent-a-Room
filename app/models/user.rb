class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable    
  before_save :default_role

  belongs_to :role
  has_many :rooms
  has_many :bookings
  has_many :reviews
  
  # validates_presence_of :username, :mobile
  # validates_numericality_of :mobile
  # validates_length_of :mobile, is: 10
  # validates_uniqueness_of :username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :github, :google_oauth2]

  def role?(role)
    self.role.name == role
  end

  def default_role
    if self.role == nil
      self.role_id = Role.last.id
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.first_name
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name   
      user.image = auth.info.image 
      user.mobile = "9731937369"
      Rails.logger.debug "Inside Model auth: #{auth.info}"
    end
  end

  def self.find_or_create_from_auth_hash(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = "shivasorab@gmail.com"
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name
      user.image = auth.info.image
      Rails.logger.debug "Inside Model auth: #{auth.info}"
    end
  end
end