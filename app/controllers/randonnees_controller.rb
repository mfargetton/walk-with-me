class RandonneesController < ApplicationController
  before_action :authenticate_user!
  def new
    @randonnee = Randonnee.new
  end

  def create
    @randonnee = Randonnee.new(randonnee_params)
    if @randonnee.save
      # sauvegarde les critère de la randonnée de la conversation
      @conversation = current_user.conversations.create(randonnee: @randonnee)
      # appeler Llm avec les critères de la randonné
      llm_response = LlmService.ask(@randonnee, @conversation)

      # enregistrer la réponse du Llm
      @conversation.message.create(
        role: "assistant",
        content: llm_response
      )

      redirect_to conversation_path(@conversation)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def randonnee_params
    params.require(:randonnee).permit(:level, :duration, :distance, :content, :system_prompt)
  end
end
