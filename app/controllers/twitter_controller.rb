class TwitterController < ApplicationController
  def search_tag
    require "twitter"
  
    # Certain methods require authentication. To get your Twitter OAuth credentials,
    # register an app at http://dev.twitter.com/apps
    client_rest = Twitter::REST::Client.new do |config|
      config.consumer_key = 'Dx5V1VzAGrFRfosfH7mn4G6bu'
      config.consumer_secret =  't4XG4rcexsh2bpSVkyar9P2NDvuoUFeteQ2wsjFEIUt6vY0E21'
      config.access_token = '2728693344-R0UZ5iJnt31OnuCSyQkyGqAD7wBbyPe8GO68pxI'
      config.access_token_secret = 'KdcTYayXEh4zGn6oNNdEvvWtjaM623clrRI07eePQZD8L'
    end
    
    client_rest.search("#testphotographytag2014", :result_type => "recent").collect do |object|
      logger.info object.inspect
      if not Snap.exists?(:media_id => object.id)
        if object["entities"]["media"]
          snap = Snap.new(:media_id => object.id, :media_type => "image", :media_url => object["entities"]["media"]["media_url"], :caption => object.text)
          snap.save
        else
          snap = Snap.new(:media_id => object.id, :media_type => "tweet", :caption => object.text)
          snap.save
        end        
      end
    end
    
    render :text => "success"
  end
  
end
