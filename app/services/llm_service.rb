class LlmService
  def self.ask(randonnee, conversation)
    chat = RubyLLM.chat

    chat.with_instructions(HikingPrompt::SYSTEM_PROMPT)

    response = chat.ask(randonnee, conversation)

    HikingResponse.from_json(response.content)

    response.content
  end
end
