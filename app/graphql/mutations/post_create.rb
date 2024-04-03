# frozen_string_literal: true

module Mutations
  class PostCreate < BaseMutation
    description "Creates a new post"

    field :post, Types::PostType, null: false

    argument :title, String, required: true
    argument :content, String, required: true

    def resolve(**post_input)
      authenticate!
      post_input[:user_id] = context[:current_user]&.id
      post = ::Post.new(**post_input)
      raise GraphQL::ExecutionError.new(
        GraphqlErrorType::POST_CREATE_ERROR,
        extensions: {code: GraphqlErrorType::POST_CREATE_ERROR}
      ) unless post.save

      sql = <<-SQL
select posts.id, posts.title, posts.content, posts.updated_at,
       users.id as user_id, users.identifier, users.provider, users.created_at, users.updated_at as user_updated_at
from posts left join users on posts.user_id = users.id
where posts.id = ?;
      SQL
      post_type = execute_sql(sql, [post.id]).map do |e|
        {
          id: e["id"],
          title: e["title"],
          content: e["content"],
          updated_at: e["updated_at"],
          user: {
            id: e["user_id"],
            identifier: e["identifier"],
            provider: User.providers.invert[e["provider"]],
            created_at: e["created_at"],
            updated_at: e["user_updated_at"]
          }
        }
      end.first
      { post: post_type }
    rescue => e
      raise GraphQL::ExecutionError.new(
        e.message,
        extensions: {
          code: (e.respond_to?(:extensions) && e.extensions[:code]) || GraphqlErrorType::INTERNAL_SERVER_ERROR
        })
    end
  end
end
