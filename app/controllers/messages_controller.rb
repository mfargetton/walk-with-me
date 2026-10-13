class MessagesController < ApplicationController
  def create
    # 1. Créer le message de l'utilisateur
    @message = Message.new
    @message.content = params[:message][:content]
    @message.role = "user"
    @message.conversation_id = params[:conversation_id]

    # 2. Enregistrer le message utilisateur
    if @message.save
      puts "Message utilisateur enregistré avec succès !"

      # 3. Envoyer le message au service IA
      ai_response = LlmService.call(@message.content)

      # 4. Créer le message de réponse de l'IA
      @ai_message = Message.new
      @ai_message.role = "assistant"
      @ai_message.content = ai_response
      @ai_message.conversation_id = params[:conversation_id]

      # 5. Enregistrer la réponse de l'IA
      if @ai_message.save
        puts "Réponse IA enregistrée avec succès !"
      else
        puts "Erreur lors de l'enregistrement de la réponse IA"
      end

      # 6. Revenir à la conversation
      redirect_to conversation_path(params[:conversation_id])

    else
      puts "Erreur lors de l'enregistrement du message utilisateur"
      redirect_to conversation_path(params[:conversation_id]),
                  alert: "Impossible d'enregistrer votre message."
    end
  end
end
