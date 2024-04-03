# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :body, String, null: false
    field :post_id, Integer, null: false
    field :reply_id, Integer
    field :user_id, Integer, null: false
    field :identifier, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
