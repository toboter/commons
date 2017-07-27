class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user
      can [:show, :view_file], Subject, Subject do |s|
        s.readable_by?(user)
      end
      can [:edit, :update, :destroy], Subject, Subject do |s|
        s.editable_by?(user)
      end
      can :update_multiple, Subject if user.is_admin?
      can [:new, :create], Subject if user.is_admin? || user.is_creator?
      
    else
      can [:read, :view_file], Subject, published?: true
    end
    
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