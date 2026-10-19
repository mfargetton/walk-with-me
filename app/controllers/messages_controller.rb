class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    @message = @conversation.messages.build(role: "user", content: message_params[:content])

    unless @message.save
      @messages = @conversation.messages.reload
      flash.now[:alert] = "Écrivez un message avant d'envoyer."
      render "conversations/show", status: :unprocessable_entity
      return
    end

    HikingReply.generate_later(@conversation)
    redirect_to conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
