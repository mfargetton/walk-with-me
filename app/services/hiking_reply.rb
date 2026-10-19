class HikingReply
  ERROR_MESSAGE = "La génération a échoué. Vous pouvez reformuler votre demande."

  def self.generate_later(conversation)
    conversation_id = conversation.id

    if Rails.env.test?
      generate(conversation_id)
    else
      Thread.new do
        Rails.application.executor.wrap { generate(conversation_id) }
      end
    end
  end

  def self.generate(conversation_id)
    conversation = Conversation.find(conversation_id)
    return unless conversation.messages.last&.role == "user"
    conversation.messages.create!(role: "assistant", content: LlmService.ask(conversation))
    update_title(conversation)
  rescue StandardError => e
    Rails.logger.error("HikingReply: #{e.class} - #{e.message}")
    Conversation.find_by(id: conversation_id)&.messages&.create(
      role: "assistant",
      content: ERROR_MESSAGE
    )
  end

  def self.update_title(conversation)
    content = conversation.messages.last&.content
    return if content.blank?
    route_title = HikingResponse.from_json(content).routes.filter_map { |route| route.title.presence }.first
    conversation.update!(title: route_title) if route_title
  end
  private_class_method :update_title
end
