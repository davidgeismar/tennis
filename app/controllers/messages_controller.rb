class MessagesController < ApplicationController
  after_action  :verify_authorized, except:  [:index, :contact]

  def new
    @convocation  = Convocation.find(params[:convocation_id])
    @message      = Message.new(convocation: @convocation)
    authorize @message
  end

  def create
    @convocation          = Convocation.find(params[:convocation_id])
    @message              = Message.new(message_params)
    @message.convocation  = @convocation
    @message.user         = current_user
    authorize @message

    if @message.save
      redirect_to user_path(current_user)
      flash[:notice] = "Votre message a bien été envoyé, vous recevrez une nouvelle convocation ou un appel du JA d'ici peu."
    else
      render :new
      flash[:alert] = "Un problème est survenu veuillez réessayer d'envoyer votre message"
    end
  end

  def show
    @convocation  = Convocation.find(params[:convocation_id])
    @message     = @convocation.message
    authorize @message
    @message.read = true
    @message.save
  end

  private

  def message_params
    params.require(:message).permit(
      :content,
      :read)
  end
end
