class LlmService
  def self.call(message_content)
    chat = RubyLLM.chat

    chat.with_instructions(HikingPrompt::SYSTEM_PROMPT)

    response = chat.ask(message_content)

    HikingResponse.from_json(response.content)

    response.content
  end
end
