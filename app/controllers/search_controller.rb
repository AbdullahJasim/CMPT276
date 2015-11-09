require 'thread'
require 'thwait'

class SearchController < ApplicationController
  def new
    @user = current_user
    # Keywords are not passed in
    # Used to forbid users calling GET '/search' directly and
    # handles the error when user doesn't enter anything in queries
    if params[:q].nil? || params[:q].blank?
      redirect_to root_url
      return
    else
      @query = params[:q]
    end

    threads = []
    threads << Thread.new do
      @result = $twitter.search(@query, result_type: "recent").take(20)
    end
    threads << Thread.new do
      @instagram = Instagram.user_recent_media("460563723", {:count => 20})
    end
    threads << Thread.new do
      @googleplus = GooglePlus::Activity.search(@query, {:maxResults => 20})
    end
    ThreadsWait.all_waits(*threads)

  end
end
