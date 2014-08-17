class InstagramController < ApplicationController
  protect_from_forgery :except => :subscription_callback
                       
  require "instagram"
  
  # enable :sessions
  
  CALLBACK_URL = "http://snaphub.herokuapp.com/redirect/callback"
  HASHTAG = "testphotographytag2014"
  
  Instagram.configure do |config|
    config.client_id = "39af25cb82ed4404915821b9448489f3"
    config.client_secret = "2aa3108232c44ceaa3b8c3ddd571aac0"
    # For secured endpoints only
    #config.client_ips = '<Comma separated list of IPs>'
  end
  
  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  end
  
  def callback
    if request.post?
      # Instagram API request to subscribe to HASHTAG here
      
    else
      if params[:code]
        response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
        session[:access_token] = response.access_token
        @access_token = session[:access_token]
      end
      @snaps = Snap.all
      render '/snaps/view'
    end
  end
  
  def subscribe
    Thread.new do |t|
      options = {:object_id => HASHTAG}
      Instagram.create_subscription('tag', "http://snaphub.herokuapp.com/instagram/subscription_callback", aspect = 'media', options)
      t.exit
    end
    
    redirect_to '/snaps/view'
  end
  
  def subscription_callback
    if params["hub.challenge"]
      render :text => params["hub.challenge"]
    else
      logger.info params.inspect
      response = Instagram.tag_recent_media(HASHTAG)
      
      response.each do |media|
        logger.info media.inspect
        
        if not Snap.exists?(:media_id => media.id)
          if media.type == "video"
            media_url = media.videos["standard_resolution"]["url"]
            media_type = "video"
          else
            media_url = media.images["standard_resolution"]["url"]
            media_type = "image_instagram"
          end 
          
          snap = Snap.new(:media_id => media.id, :media_author => media.user["username"], :media_type => media_type, :media_url => media_url, :caption => media.caption["text"], :added => false)
          snap.save
        end
      end
      
      render :text => "success"
    end
  end
  
end
