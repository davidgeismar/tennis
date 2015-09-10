class DisponibilitiesController < ApplicationController
  before_action :set_subscription

  def new
    @disponibility = Disponibility.new
    @disponibility.subscription = @subscription
    authorize @disponibility
  end

  def create
    @disponibility = Disponibility.new(disponibility_params)
    @disponibility.subscription = @subscription
    authorize @disponibility

    if @disponibility.save && current_user.judge?
      redirect_to competition_subscriptions_path(@subscription.competition)
      flash[:notice] = "Les disponibilités du licencié ont bien été enregistrées"
    elsif  @disponibility.save
      redirect_to mytournaments_path
      flash[:notice] = "Vos disponibilités ont bien été enregistrées"
    else
      render 'new'
    end
  end

  def show
    authorize @subscription.disponibility
  end

  def edit
    @disponibility = @subscription.disponibility
    authorize @disponibility
  end

  def update
   @disponibility = @subscription.disponibility
   authorize @disponibility
   if @disponibility.update(disponibility_params)
    redirect_to competition_subscriptions_path(@subscription.competition)
    flash[:notice] = "Les disponibilités du licencié ont bien été enregistrées"
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
