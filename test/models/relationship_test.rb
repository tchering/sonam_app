require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  test "should belong to follower" do
    relationship = Relationship.new
    assert_respond_to relationship, :follower
  end

  test "should belong to followed" do
    relationship = Relationship.new
    assert_respond_to relationship, :followed
  end

  def setup
    @relationship = Relationship.new(follower_id: users(:one).id,
                                     followed_id: users(:two).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
