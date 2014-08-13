class SnapsController < ApplicationController
  protect_from_forgery :except => :process_subscription
                       
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
  
  def index
    if defined? session[:access_token]
      @access_token = session[:access_token]
    end
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
      render "view"      
    end

  end
  
  def test
    if defined? session[:access_token]
      @access_token = session[:access_token]
    end
  end
  
  def view
    @subscriptions = Instagram.subscriptions
    if defined? session[:access_token]
      @access_token = session[:access_token]
    end
    
    @snaps = Snap.all
  end
  
  def subscribe
    Thread.new do |t|
      options = {:object_id => HASHTAG}
      Instagram.create_subscription('tag', "http://snaphub.herokuapp.com/snaps/process_subscription", aspect = 'media', options)
      t.exit
    end
    
    redirect_to "/snaps/view"
  end
  
  def process_subscription
    if params["hub.challenge"]
      render :text => params["hub.challenge"]
    else
      logger.info params.inspect
      response = Instagram.tag_recent_media(HASHTAG)
      
      response.each do |media|
        logger.info media.inspect
        
        if not Snap.exists?(:media_id => media.id)
          if media.videos["standard_resolution"]["url"]
            media_url = media.videos["standard_resolution"]["url"]
          else
            media_url = media.images["standard_resolution"]["url"]
          end 
          
          snap = Snap.new(:media_id => media.id,:img_url => media_url, :caption => media.caption["text"])
          snap.save
        end
      end
      
      render :text => "success"
    end
  end
end