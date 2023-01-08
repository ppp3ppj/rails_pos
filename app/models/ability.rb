# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # return if user.blank?
    user ||= User.new  
    # return unless user.present?

    # admin if user.admin?
    # end

    # def admin
    # can :manage, :all
    can :manage, :all
  end
    
end
