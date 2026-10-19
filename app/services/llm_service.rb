class LlmService
  def self.ask(conversation)
    messages = conversation.messages.to_a
    last_message = messages.last
    unless last_message&.role == "user"
      raise ArgumentError, "Le dernier message doit venir de l'utilisateur"
    end

    chat = RubyLLM.chat
    chat.with_instructions(HikingPrompt::SYSTEM_PROMPT)
    messages[0..-2].each do |message|
      chat.add_message(role: message.role.to_sym, content: message.content)
    end

    response = chat.ask(last_message.content)
    HikingResponse.from_json(response.content)
    response.content
  end
end
