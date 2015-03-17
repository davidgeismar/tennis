class MessagesController < ApplicationController
  before_action :set_conversation, only: [:show, :reply, :reply_server]
  after_action :verify_policy_scoped, :only => :index
  after_action :verify_authorized, except:  [:new, :create]
  respond_to :js, only: :reply


  def new
    @message = Message.new
    raise
  end

  def create
    @conversation = Conversation.new
    @conversation.user1 = current_user
    @conversation.user2 = Convocation.find(params[:convocation_id]).subscription.tournament.user
    @message = Message.new(message_params)
    @message.user = current_user
    @message.conversation = @conversation
    if @message.save
      redirect_to user_path
    else
      render :new
    end
  end

  def index
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end