# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "post create", type: :graphql do
  context "mutation" do
    it "should raise exception without authenticated user" do
      context = {
        current_user: nil
      }
      attrs = attributes_for(:post)
      variables = {
        "title": attrs[:title],
        "content": attrs[:content]
      }
      result = RainyDayBlogSchema.execute(query, variables: variables, context: context)
      expect(result["errors"].first.dig("extensions", "code")).to eql(GraphqlErrorType::AUTHENTICATION_REQUIRED)
    end

    it "should return created post" do
      user = create(:user)
      context = {
        current_user: user
      }
      attrs = attributes_for(:post)
      variables = {
        "title": attrs[:title],
        "content": attrs[:content]
      }
      result = RainyDayBlogSchema.execute(query, variables: variables, context: context)
      expect(result.dig("data", "postCreate", "post", "id")).not_to be_nil
      expect(result.dig("data", "postCreate", "post", "title")).to eql(attrs[:title])
      expect(result.dig("data", "postCreate", "post", "user", "id")).not_to be_nil
      expect(result.dig("data", "postCreate", "post", "user", "identifier")).to eql(user.identifier)
    end
  end

  def query
    <<-gql
    mutation post($title: String!, $content: String!) {
      postCreate(input: {
        title: $title,
        content: $content
      }) {
        post {
          id
          title
          content
          updatedAt
          user {
            id
            identifier
            provider
          }
        }
      }
    }
    gql
  end
end
