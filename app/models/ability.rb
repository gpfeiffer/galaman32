class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    else
      can :index, Club
      can :read, [Competition, Discipline, Qualification]
      can :show, User do |u|
        u == user
      end
      
    end

    if user.role? :parent
      can :read, [Swimmer, Club, Registration, Entry, Result, Event, Invitation]
      can :manage, Aim, { :swimmer => { :id => user.beneficiary_ids } }
    end
        
    if user.role? :swimmer
      can :read, [Swimmer, Club, Registration, Entry, Result, Event, Invitation]
      can :manage, Aim, { :swimmer => user.swimmer }
    end

    if user.role? :coach
      can :read, [Swimmer, Club, Registration, Entry, Result, Event, Invitation]
#      can :manage, Aim do |aim|
#        aim.swimmer.supporters.include? user
#      end
      can :manage, Aim 
    end
        

    # Define abilities for the passed in user here. For example:
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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
