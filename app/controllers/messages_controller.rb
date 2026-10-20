class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])

    @message = @conversation.messages.new(
      content: message_params[:content],
      role: "user"
    )

    if @message.save
      ai_response = LlmService.call(@message.content)

      @conversation.messages.create!(
        role: "assistant",
        content: ai_response
      )

      redirect_to conversation_path(@conversation)
    else
      redirect_to conversation_path(@conversation),
                  alert: "Impossible d'enregistrer votre message."
    end
  rescue StandardError => e
    Rails.logger.error(
      "Erreur MessagesController : #{e.class} - #{e.message}"
    )

    redirect_to conversation_path(params[:conversation_id]),
                alert: "Une erreur est survenue lors de la génération de la réponse IA."
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
