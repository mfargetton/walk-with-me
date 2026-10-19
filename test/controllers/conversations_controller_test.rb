require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "le propriétaire voit la réponse structurée et le formulaire" do
    sign_in users(:one)
    conversations(:one).messages.create!(
      role: "assistant",
      content: {
        intro: "Voici une idée",
        routes: [
          {
            title: "Lac Blanc",
            subtitle: "Boucle facile",
            start_location: "Chamonix",
            end_location: "Chamonix",
            distance_km: 6,
            estimated_duration: "3 h",
            difficulty: "facile",
            why_it_matches: "Accessible",
            description: "Sentier forestier",
            highlights: [ { name: "Lac", description: "Eau claire" } ],
            tips: [ "Partez tôt" ]
          }
        ],
        follow_up_question: "Tu veux plus court ?"
      }.to_json
    )

    get conversation_path(conversations(:one))

    assert_response :success
    assert_select "h2", text: "Lac Blanc"
    assert_select "form#new_message"
    assert_select "body", text: /true|false/, count: 0
  end

  test "affiche l'attente tant que la réponse n'est pas arrivée" do
    sign_in users(:one)

    get conversation_path(conversations(:one))

    assert_response :success
    assert_select "#reply-pending"
    assert_select "form#new_message", count: 0
  end

  test "un autre utilisateur ne peut pas ouvrir la conversation" do
    sign_in users(:two)

    get conversation_path(conversations(:one))

    assert_response :not_found
  end

  test "la liste relie chaque randonnée à sa conversation" do
    sign_in users(:one)

    get conversations_path

    assert_response :success
    assert_select "a.conversation-card[href=?]", conversation_path(conversations(:one))
    assert_select "h2", text: "Débutant · 1 jour"
  end
end
