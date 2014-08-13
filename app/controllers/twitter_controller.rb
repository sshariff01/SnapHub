class TwitterController < ApplicationController
  def user_tweet
    require "twitter"
  
    # Certain methods require authentication. To get your Twitter OAuth credentials,
    # register an app at http://dev.twitter.com/apps
    Twitter.configure do |config|
      config.consumer_key = 'Dx5V1VzAGrFRfosfH7mn4G6bu'
      config.consumer_secret =  't4XG4rcexsh2bpSVkyar9P2NDvuoUFeteQ2wsjFEIUt6vY0E21'
      config.oauth_token = '2728693344-R0UZ5iJnt31OnuCSyQkyGqAD7wBbyPe8GO68pxI'
      config.oauth_token_secret = 'KdcTYayXEh4zGn6oNNdEvvWtjaM623clrRI07eePQZD8L'
    end
  
    # Initialize your Twitter client
    client = Twitter::Client.new
  
    # Post a status update
    client.update("I just posted a status update via the Twitter Ruby Gem !")
    redirect_to request.referer, :notice => 'Tweet successfully posted'
  end
  
end
