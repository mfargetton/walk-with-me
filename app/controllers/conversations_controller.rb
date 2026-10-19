class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations.order(created_at: :desc)
  end

  def show
    @conversation = current_user.conversations.find(params[:id])
    @messages = @conversation.messages
    @message = Message.new
  end
end
