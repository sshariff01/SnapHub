class SnapsController < ApplicationController
  def subscriptions
  end
  
  def view
    @snaps = Snap.where(:removed => false)
  end
  
  def get_new
    @snaps = Snap.where(:added => false) # Snaps to be added
    @all_snaps = Snap.where(:removed => false) # All snaps, not including ones that have been moderated out
    
    @snaps.each do |snap|
      snap.added = true
      snap.save
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def admin
    @snaps = Snap.where(:removed => false)
  end
  
  def remove
    @snap_to_remove = Snap.find_by_id(params["snap"]["id"])
    @snap_to_remove.removed = true;
    if @snap_to_remove.save
        redirect_to "/snaps/admin"
    else
      render :text => "Snap could not be removed! Please return to '/snaps/admin' and try removing again or contact your administrator if this issue persists."  
    end
    
  end
  
end