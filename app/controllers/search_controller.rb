require 'thread'
require 'thwait'
require 'Mail'

class SearchController < ApplicationController

  # Public variables of this class stores search result and email address for mailing
  @@result
  @@user

  def new
    @hash_tags = []
    @freq_words = []
    @@user = current_user   # mail() method will retrieve user email address here
    @user  = current_user   # @user is used in other controllers and views as usual

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
      @twitter = $twitter.search(@query, result_type: "top").take(100)
      @twitter.each do |tweet|
        @hash_tags.push(parse(tweet.text))
      end
      @twitter = @twitter[0..19]

    end
    threads << Thread.new do
      tagResult = Instagram.tag_search(@query)
      @instagram = Instagram.tag_recent_media(tagResult[0].name, {:count => 20})
    end
    threads << Thread.new do
      @googleplus = GooglePlus::Activity.search('#'+@query, {:maxResults => 20})
    end

    ThreadsWait.all_waits(*threads)
    if params[:freq_words]
      @patterns = FpGrowth.mine(@hash_tags, threshhold = 3)
      @freq_words = pattern_parse(@patterns, @query)
    end

    @freq_search_option = params[:freq_words]
    @@result = render_to_string 'search/new', :layout => false
  end

  def mail
    if @@user.nil?
      render :json => { status: 404, :error => 'User not logged in. Email cannot be sent.' }
    else
      Mail.deliver do
        to @@user.email
        from 'noreply@visocialize-276.herokuapp.com'
        mime_version '1.0'
        content_type 'text/html'
        subject 'Your Visocialize search results'
        body @@result
      end
      render :json => { status: :ok }
    end
  end

  private

  def parse(text)
    var = (text.split(' ').delete_if {|x| x[0] != '#'}).map {|i| i.downcase}
    return var
  end

  def pattern_parse(patterns, search)
    words = []
    patterns.each do |pattern|
      pattern.content.each do |word|
        if (word[1..word.length] != search.downcase && !(words.include?(word[1..word.length])))
          words.push(word[1..word.length])
        end
      end
    end
    return words
  end


end
