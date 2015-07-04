class DisponibilitiesController < ApplicationController
  before_action :set_subscription
  skip_after_action :verify_authorized, only: [:new, :create, :update, :edit, :show]

  def new
    @disponibility = Disponibility.new
    @disponibility.subscription = @subscription
  end

  def create
    @disponibility = Disponibility.new(disponibility_params)
    @disponibility.subscription = @subscription
    if @disponibility.save
      redirect_to root_path
      flash[:notice] = "Vos disponibilités ont bien été enregistrées"
    else
      render 'new'
    end

  end

  def show
  end

  def edit
    @disponibility = @subscription.disponibility
  end

  def update
   @disponibility = @subscription.disponibility

   if @disponibility.update(disponibility_params)
    redirect_to root_path
    flash[:notice] = "Vos disponibilités ont bien été modifiés"
   else
    render "edit"
   end
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:subscription_id])
  end

  def disponibility_params
    params.require(:disponibility).permit(:week, :saturday, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :comment)
  end

end