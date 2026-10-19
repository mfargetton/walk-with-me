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

    @conversation.messages.create!(role: "assistant", content: LlmService.ask(@conversation))
    redirect_to conversation_path(@conversation)
  rescue RubyLLM::Error, JSON::ParserError => e
    Rails.logger.error("MessagesController: #{e.class} - #{e.message}")
    redirect_to conversation_path(@conversation),
                alert: "Une erreur est survenue lors de la génération de la réponse."
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
