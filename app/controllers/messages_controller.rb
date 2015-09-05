class MessagesController < ApplicationController
  respond_to :js, only: :reply

  skip_before_action  :authenticate_user!,  only: [:contact]
  skip_after_action   :verify_policy_scoped

  before_action :set_conversation,  only:    [:show, :reply, :reply_server]
  after_action  :verify_authorized, except:  [:index, :contact]

  def new
    @convocation  = Convocation.find(params[:convocation_id])
    @message      = Message.new
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

  def update
     @message.update(message_params)
  end

  def contact
    @message = Message.new
  end

  def index
    @convocation  = Convocation.find(params[:convocation_id])
    @messages     = @convocation.messages.all
    @messages.each do |message|
      message.read = true
      message.save
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :read)
  end
end
