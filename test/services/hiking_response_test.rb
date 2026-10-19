require "test_helper"

class HikingResponseTest < ActiveSupport::TestCase
  test "lit un objet JSON entouré de balises markdown" do
    response = HikingResponse.from_json(<<~JSON)
      ```json
      {"intro":"Une idée","routes":[{"title":"Lac Blanc"}],"follow_up_question":"On précise ?"}
      ```
    JSON

    assert_equal "Une idée", response.intro
    assert_equal "Lac Blanc", response.routes.first.title
    assert_equal "On précise ?", response.follow_up_question
  end

  test "refuse un JSON qui n'est pas un objet" do
    assert_raises JSON::ParserError do
      HikingResponse.from_json("[]")
    end
  end
end
