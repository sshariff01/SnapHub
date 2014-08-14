class SnapsController < ApplicationController
  def index
    if defined? session[:access_token]
      @access_token = session[:access_token]
    end
  end
  
  def view
    # @subscriptions = Instagram.subscriptions
    # if defined? session[:access_token]
      # @access_token = session[:access_token]
    # end
    
    @snaps = Snap.all
  end
  
  def get_all
    @snaps = Snap.all
    
    respond_to do |format|
      format.js
    end
  end
  
end