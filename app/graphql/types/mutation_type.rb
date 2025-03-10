# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :post_create, mutation: Mutations::PostCreate
    field :comment_create, mutation: Mutations::CommentCreate
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
