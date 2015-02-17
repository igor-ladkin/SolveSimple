class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, [User, Profile]
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], user: user
    can [:thumbs_up, :thumbs_down], [Question, Answer] do |resource|
      resource.user != user
    end
    can :approve, Answer do |answer|
      answer.question.user == user 
    end
  end
end
