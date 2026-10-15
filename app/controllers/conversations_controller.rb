class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.create
    redirect_to conversation_path(@conversation)
  end

  def index
    @conversations = current_user.conversations.order(created_at: :desc)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages
    # @randonne = Randonnee.new
  end
end
