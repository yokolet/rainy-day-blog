# frozen_string_literal: true

module Types
  class PostsType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :excerpt, String, null: false
    field :identifier, String, null: false
    field :comment_count, Integer, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
