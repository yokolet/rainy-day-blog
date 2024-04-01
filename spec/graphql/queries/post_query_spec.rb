# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "post", type: :graphql do
  context "query with no post" do
    it "should return error without any post" do
      result = RainyDayBlogSchema.execute(query, variables: { id: 100 })
      expect(result.dig("data")).to be_nil
      expect(result.dig("errors")).not_to be_empty
      expect(result.dig("errors").first["message"]).to eq("ARGUMENT_ERROR")
    end
  end

  context "query with post" do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    let!(:comments) { create_list(:comment, 2, post_id: post.id, user_id: user.id) }
    subject(:result) do
      RainyDayBlogSchema.execute(query, variables: { id: post.id })
    end

    it "should return post with comments" do
      expect(result.dig("data", "post", "title")).to eql(post.title)
      expect(result.dig("data", "post", "content")).to eql(post.content)
      expect(result.dig("data", "post", "user", "identifier")).to eql(user.identifier)
      expect(result.dig("data", "post", "comments").length).to eq(comments.length)
      expect(result.dig("data", "post", "comments").first["body"]).not_to be_nil
    end
  end

  def query
    <<-gql
    query post($id: ID!) {
      post(id: $id) {
        id
        title
        content
        user {
          id
          identifier
          provider
        }
        comments {
          id
          body
        }
      }
    }
    gql
  end
end
