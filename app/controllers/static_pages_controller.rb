class StaticPagesController < ApplicationController
  def about
    @user = current_user
  end

  def contact
    @user = current_user
  end
end
