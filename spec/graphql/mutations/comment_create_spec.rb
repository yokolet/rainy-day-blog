# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "comment create", type: :graphql do
  context "mutation" do
    it "should raise exception without authenticated user" do
      context = {
        current_user: nil
      }
      attrs = attributes_for(:comment)
      variables = {
        "body": attrs[:body],
        "pid": 0,
        "rid": nil
      }
      result = RainyDayBlogSchema.execute(query, variables: variables, context: context)
      expect(result["errors"].first.dig("extensions", "code")).to eql(GraphqlErrorType::AUTHENTICATION_REQUIRED)
    end

    it "should return created post" do
      user = create(:user)
      context = {
        current_user: user
      }
      attrs = attributes_for(:comment)
      post = create(:post, user_id: user.id)
      variables = {
        "body": attrs[:body],
        "pid": post[:id]
      }
      result = RainyDayBlogSchema.execute(query, variables: variables, context: context)
      expect(result.dig("data", "commentCreate", "comment", "id")).not_to be_nil
      expect(result.dig("data", "commentCreate", "comment", "body")).to eql(attrs[:body])
      expect(result.dig("data", "commentCreate", "comment", "userId")).not_to be_nil
      expect(result.dig("data", "commentCreate", "comment", "identifier")).to eql(user.identifier)
    end
  end

  def query
    <<-gql
    mutation comment($body: String!, $pid: ID!, $rid: ID) {
      commentCreate(input: {
        body: $body,
        postId: $pid,
        replyId: $rid
      }) {
        comment {
          id
          body
          postId
          userId
          identifier
          updatedAt
        }
      }
    }
    gql
  end
end
