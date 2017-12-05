class Ability
  include CanCan::Ability

  def initialize(user)

    # :create, :read, :update, :delete
    # :create - new, create
    # :read - index, show
    # :update - edit, update
    # :delete - destroy

     if user.nil?
         can :read, [Room, City]
     elsif user.role? "admin"
        can [:manage, :authorize], [City, Amenity, Role, Room]
        can [:create, :my_bookings, :update, :confirmation], [Booking]
        can [:create, :my_rooms], Room
        can [:create], [SpecialPrice], :room => { :user_id => user.id }
       
     elsif user.role? "host"
        can [:read, :update, :destroy, :my_bookings], Booking do |booking|
           booking.user_id == user.id
        end
        
        can [:update, :destroy], Review do |review|
            review.user_id == user.id
        end

        can [:update, :destroy], [Room] do |room|
          room.user_id == user.id
        end
        can [:create,:read, :my_rooms, :confirmation], [Room, Booking]

        can [:update,:confirmation], Booking
        can :create, SpecialPrice#, :room => { :user_id => user.id }
        can :create, Review
        can :read, [ City, Amenity]
        
     elsif user.role? "guest"
        can [:create, :read, :my_rooms, :my_bookings], [Room,Booking]
        can :create, Review        
        can [:read], [City,Room,Booking, Review]
        can [:update, :destroy], Review do |review|
             review.user_id == user.id
        end
        
        can [:update, :destroy, :my_bookings], Booking do |booking|
            booking.user_id == user.id
        end
      end 
    # # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
