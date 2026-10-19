require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "appartient à sa conversation" do
    assert_equal conversations(:one), messages(:one).conversation
  end

  test "exige un contenu et un rôle connu" do
    message = Message.new(conversation: conversations(:one), role: "autre")

    assert_not message.valid?
    assert_includes message.errors[:role], "is not included in the list"
    assert_includes message.errors[:content], "can't be blank"
  end
end
