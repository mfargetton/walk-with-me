class MessagesController < ApplicationController
  def create
    @message = Message.new
    @message.content = params[:message][:content]
    @message.role = "user"
    @message.conversation_id = params[:conversation_id]

    if @message.save
      puts "Message utilisateur enregistré avec succès !"

      # Récupération de la réponse IA
      ai_response = LlmService.call(@message.content)

      # Enregistrement de la réponse dans la conversation
      @ai_message = Message.new
      @ai_message.role = "assistant"
      @ai_message.content = ai_response
      @ai_message.conversation_id = params[:conversation_id]

      if @ai_message.save
        puts "Réponse IA enregistrée avec succès !"
      else
        puts "Erreur lors de l'enregistrement de la réponse IA"
      end

      redirect_to conversation_path(params[:conversation_id])
    else
      puts "Erreur lors de l'enregistrement du message utilisateur"
      redirect_to conversation_path(params[:conversation_id]),
                  alert: "Impossible d'enregistrer votre message."
    end
  end
end
