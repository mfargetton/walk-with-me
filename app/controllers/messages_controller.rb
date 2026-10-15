class MessagesController < ApplicationController
  def create
    # Récuperer la conversation
    @conversation = Conversation.find(params[:conversation_id])

    # Créer le message utilisateur
    @message = Message.new
    @message.content = params.require(:message).permit(:content)[:content]
    @message.role = "user"
    @message.conversation_id = @conversation.id

    # Enregistrer le message utilisateur
    if @message.save
      puts "Message utilisateur enregistré avec succès !"

      # Appeler lz service IA (LLM)
      ai_response = LlmService.call(@message.content)

      # Créer le message de réponse IA
      @ai_message = Message.new
      @ai_message.role = "assistant"
      @ai_message.content = ai_response
      @ai_message.conversation_id = @conversation.id

      # 6Enregistrer la réponse IA
      if @ai_message.save
        puts "Réponse IA enregistrée avec succès !"

        redirect_to conversation_path(@conversation)
      else
        puts "Erreur lors de l'enregistrement de la réponse IA"

        redirect_to conversation_path(@conversation),
                    alert: "Impossible d'enregistrer la réponse IA."
      end

    else
      # Gérer enregistrement utilisateur
      puts "Erreur lors de l'enregistrement du message utilisateur"

      redirect_to conversation_path(@conversation),
                  alert: "Impossible d'enregistrer votre message."
    end
  rescue StandardError => e
    Rails.logger.error("Erreur MessagesController : #{e.class} - #{e.message}")

    redirect_to conversation_path(params[:conversation_id]),
                alert: "Une erreur est survenue lors de la génération de la réponse IA."
  end
end
