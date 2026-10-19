class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    # Récupérer la conversation
    @conversation = current_user.conversations.find(params[:conversation_id])

    # Créer le message utilisateur
    @message = @conversation.messages.new(
      content: message_params[:content],
      role: "user"
    )

    # Enregistrer le message utilisateur
    if @message.save
      Rails.logger.info("Message utilisateur enregistré avec succès")

      # Appeler le service IA
      ai_response = LlmService.ask(
        @conversation.randonnee,
        @conversation,
        @message.content
      )

      # Créer et enregistrer la réponse IA
      @conversation.messages.create!(
        role: "assistant",
        content: ai_response
      )

      # Retourner à la conversation
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
