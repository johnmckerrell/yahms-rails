class SystemsController < ApplicationController
  before_filter :require_user
  before_filter :load_system, :only => [ :show, :edit, :update, :revoke_access, :grant_access ]
  
  def revoke_access
    @current_subscription = Subscription.find(:first,
      :conditions => { :user_id => current_user.id, :system_id => @system.id },
      :include => [ :user ] )
    user = User.find(:first, :conditions => { :login => params[:login] } )
    if @current_subscription.access_level == 'admin' and user and user != @current_user
      Subscription.delete_all( { :user_id => user.id, :system_id => @system.id } )
    end
    redirect_to system_url(@system.id)
  end

  def grant_access
    user = User.find(:first, :conditions => { :login => params[:login] } )
    if user and user != @current_user
      access_level = params[:access_level] == 'admin' ? 'admin' : 'readonly'
      existing = Subscription.find(:first, :conditions => { :system_id => @system.id, :user_id => user.id })
      if existing
        existing.access_level = access_level
        existing.save!
      else
        Subscription.create!( :system_id => @system.id,
          :user_id => user.id,
          :access_level => access_level )
      end
    end
    redirect_to system_url(@system.id)
  end

  def new
    @system = User.new
  end
  
  def create
    @system = System.new(params[:system])
    if @system.save and Subscription.create!(
      :access_level => 'admin',
      :user_id => @current_user.id,
      :system_id => @system.id )

      flash[:notice] = "System created!"
      redirect_back_or_default systems_url
    else
      render :action => :new
    end
  end
  
  def show
    @base_stations = BaseStation.find(:all,
      :conditions => [ "system_id = ?", @system.id ] )
    @current_subscription = Subscription.find(:first,
      :conditions => { :user_id => current_user.id, :system_id => @system.id },
      :include => [ :user ] )
    if @current_subscription.access_level == 'admin'
      @subscriptions = Subscription.find(:all, :conditions => { :system_id => @system.id })
    end
  end

  def edit
  end
  
  def index
    @systems = System.find(:all,
      :conditions => [ "id IN (SELECT system_id FROM subscriptions WHERE user_id = ?)", current_user.id ] )
  end

  def update
    if @system.update_attributes(params[:system])
      flash[:notice] = "System updated!"
      redirect_to systems_url
    else
      render :action => :edit
    end
  end

  private
  def load_system
    @system = System.find_authorized_system(params[:id], current_user.id)
  end

end
