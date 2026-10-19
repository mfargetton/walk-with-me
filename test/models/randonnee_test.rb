require "test_helper"

class RandonneeTest < ActiveSupport::TestCase
  test "refuse un niveau inconnu" do
    randonnee = Randonnee.new(level: "expert", duration: "1 jour")

    assert_not randonnee.valid?
  end

  test "résume les critères renseignés" do
    assert_equal "débutant · 1 jour · 8 km", randonnees(:one).summary
  end
end
