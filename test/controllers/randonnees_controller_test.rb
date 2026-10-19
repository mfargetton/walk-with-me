require "test_helper"

class RandonneesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include LlmServiceTestHelper

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "crée la conversation, les deux messages, puis redirige" do
    reply = { intro: "Voici une idée", routes: [], follow_up_question: "On précise ?" }.to_json

    with_llm_reply(reply) do
      assert_difference -> { Randonnee.count } => 1, -> { Conversation.count } => 1, -> { Message.count } => 2 do
        post randonnees_path, params: {
          randonnee: { level: "débutant", duration: "2 jours", distance: "10 km", content: "Alpes" }
        }
      end
    end

    conversation = Conversation.order(:created_at).last
    assert_redirected_to conversation_path(conversation)
    assert_equal @user, conversation.user
    assert_equal "débutant · 2 jours · 10 km", conversation.title
    assert_equal [ "user", "assistant" ], conversation.messages.pluck(:role)
    assert_equal reply, conversation.messages.last.content
  end

  test "redirige tout de suite et signale l'échec de génération dans la conversation" do
    with_llm_reply(-> { raise RubyLLM::Error, "boom" }) do
      assert_difference -> { Randonnee.count } => 1, -> { Conversation.count } => 1, -> { Message.count } => 2 do
        post randonnees_path, params: {
          randonnee: { level: "débutant", duration: "2 jours", distance: "10 km", content: "Alpes" }
        }
      end
    end

    conversation = Conversation.order(:created_at).last
    assert_redirected_to conversation_path(conversation)
    assert_equal HikingReply::ERROR_MESSAGE, conversation.messages.last.content
  end

  test "réaffiche le formulaire si les critères sont invalides" do
    assert_no_difference [ "Randonnee.count", "Conversation.count" ] do
      post randonnees_path, params: { randonnee: { level: "expert", duration: "" } }
    end

    assert_response :unprocessable_entity
  end
end
