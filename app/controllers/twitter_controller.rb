class TwitterController < ApplicationController
  def user_tweet
    require "twitter"
  
    # Certain methods require authentication. To get your Twitter OAuth credentials,
    # register an app at http://dev.twitter.com/apps
    
    client = Twitter::Streaming::Client.new do |config|
      config.consumer_key = 'Dx5V1VzAGrFRfosfH7mn4G6bu'
      config.consumer_secret =  't4XG4rcexsh2bpSVkyar9P2NDvuoUFeteQ2wsjFEIUt6vY0E21'
      config.access_token = '2728693344-R0UZ5iJnt31OnuCSyQkyGqAD7wBbyPe8GO68pxI'
      config.access_token_secret = 'KdcTYayXEh4zGn6oNNdEvvWtjaM623clrRI07eePQZD8L'
    end

    topics = ["coffee"]
    client.filter(:track => topics.join(",")) do |object|
      puts object.text if object.is_a?(Twitter::Tweet)
    end
    
  end
  
end
