class RandonneesController < ApplicationController
  # Méthode new
  #
  def new
    @randonnee = Randonnee.new
  end

  def create
    @randonnee = Randonnee.new(randonnee_params)
    if @randonnee.save
      redirect_to conversation_path(@randonnee)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def randonnee_params
    params.require(:randonnee).permit(:level, :duration, :distance, :content, :system_prompt)
  end
end
