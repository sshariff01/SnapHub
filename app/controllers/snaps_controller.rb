class SnapsController < ApplicationController
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
      response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
      session[:access_token] = response.access_token
      @access_token = session[:access_token]
      
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
    if defined? session[:access_token]
      @access_token = session[:access_token]
    end
    
    @snaps = Snap.all
  end
end
