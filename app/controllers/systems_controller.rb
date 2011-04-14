class SystemsController < ApplicationController
  before_filter :require_user
  
  def new
    @system = User.new
  end
  
  def create
    @system = System.new(params[:system])
    if @system.save
      flash[:notice] = "System created!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @system = System.find(params[:id])
  end

  def edit
    @system = System.find(params[:id])
  end
  
  def index
    @systems = System.find(:all,
      :conditions => [ "id IN (SELECT system_id FROM subscriptions WHERE user_id = ?)", current_user.id ] )
  end

  def update
    @system = System.find(params[:id])
    if @system.update_attributes(params[:system])
      flash[:notice] = "System updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
