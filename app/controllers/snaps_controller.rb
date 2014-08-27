class SnapsController < ApplicationController
  def index
    if defined? session[:access_token]
      @access_token = session[:access_token]
    end
  end
  
  def view
    @snaps = Snap.all
  end
  
  def get_new
    @snaps = Snap.where(:added => false)
    @all_snaps = Snap.all
    
    @snaps.each do |snap|
      snap.added = true
      snap.save
      # if !snap.save
        # render :text => "There was a problem updating the added attribute!"
      # end
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def admin
    @snaps = Snap.all
  end
  
  def remove
    
    render :text => params["snap"]["id"]
  end
  
end