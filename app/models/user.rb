class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

      
  before_save :default_role

  belongs_to :role
  has_many :rooms
  has_many :bookings
  has_many :reviews
  
  validates_presence_of :first_name, :last_name, :username, :mobile
  validates_numericality_of :mobile
  validates_length_of :mobile, is: 10
  validates_uniqueness_of :username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

        def role?(role)
          self.role.name == role
        end

        def default_role
          if self.role == nil
            self.role_id = Role.last.id
          end
        end 
end
