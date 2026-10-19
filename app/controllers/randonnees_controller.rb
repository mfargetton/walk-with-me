class RandonneesController < ApplicationController
  before_action :authenticate_user!

  def new
    @randonnee = Randonnee.new
  end

  def create
    @randonnee = Randonnee.new(randonnee_params)
    unless @randonnee.valid?
      render :new, status: :unprocessable_entity
      return
    end

    @conversation = create_conversation_with_reply(@randonnee)
    redirect_to conversation_path(@conversation)
  rescue ActiveRecord::RecordInvalid
    @randonnee = Randonnee.new(randonnee_params)
    @randonnee.valid?
    render :new, status: :unprocessable_entity
  rescue RubyLLM::Error, JSON::ParserError => e
    Rails.logger.error("RandonneesController: #{e.class} - #{e.message}")
    @randonnee = Randonnee.new(randonnee_params)
    flash.now[:alert] = "La génération de la randonnée a échoué. Réessayez dans un instant."
    render :new, status: :unprocessable_entity
  end

  private

  def create_conversation_with_reply(randonnee)
    ActiveRecord::Base.transaction do
      randonnee.save!
      conversation = current_user.conversations.create!(
        randonnee: randonnee,
        title: randonnee.summary
      )
      conversation.messages.create!(
        role: "user",
        content: HikingPrompt.user_message(randonnee)
      )
      conversation.messages.create!(
        role: "assistant",
        content: LlmService.ask(conversation)
      )
      conversation
    end
  end

  def randonnee_params
    params.require(:randonnee).permit(:level, :duration, :distance, :content)
  end
end
