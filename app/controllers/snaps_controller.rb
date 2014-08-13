class SnapsController < ApplicationController
  def index
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
  
end