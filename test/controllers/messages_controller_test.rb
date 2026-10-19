require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include LlmServiceTestHelper

  setup do
    @conversation = conversations(:one)
  end

  test "ajoute la réponse de l'assistant pour le propriétaire" do
    sign_in users(:one)
    reply = { intro: "Autre idée", routes: [], follow_up_question: "Celle-ci ?" }.to_json

    with_llm_reply(reply) do
      assert_difference -> { @conversation.messages.count } => 2 do
        post conversation_messages_path(@conversation), params: { message: { content: "Plutôt en forêt" } }
      end
    end

    assert_redirected_to conversation_path(@conversation)
    assert_equal reply, @conversation.messages.last.content
    assert_equal "Plutôt en forêt", @conversation.messages.second_to_last.content
  end

  test "un autre utilisateur ne peut pas écrire dans la conversation" do
    sign_in users(:two)

    assert_no_difference "Message.count" do
      post conversation_messages_path(@conversation), params: { message: { content: "Intrusion" } }
    end

    assert_response :not_found
  end

  test "refuse un message vide" do
    sign_in users(:one)
    @conversation.messages.create!(
      role: "assistant",
      content: { intro: "Ok", routes: [], follow_up_question: "?" }.to_json
    )

    assert_no_difference "Message.count" do
      post conversation_messages_path(@conversation),
           params: { message: { content: "   " } },
           as: :turbo_stream
    end

    assert_response :unprocessable_entity
    assert_select ".alert", text: "Écrivez un message avant d'envoyer."
    assert_select ".message-user", count: 1
  end
end
