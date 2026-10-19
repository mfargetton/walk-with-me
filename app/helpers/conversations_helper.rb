module ConversationsHelper
  def hiking_response_for(message)
    return unless message.role == "assistant"

    HikingResponse.from_json(message.content)
  rescue JSON::ParserError
    nil
  end
end
