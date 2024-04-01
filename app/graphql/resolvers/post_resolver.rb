# frozen_string_literal: true

module Resolvers
  class PostResolver < BaseResolver
    type Types::PostType, null: false

    description 'Get a single post'

    argument :id,
             type: ::GraphQL::Types::ID,
             required: true,
             description: 'Post id'

    def resolve(id:)
      sql = <<-SQL
select posts.id, posts.title, posts.content, posts.updated_at,
       users.id as user_id, users.identifier, users.provider, users.created_at, users.updated_at as user_updated_at
from posts left join users on posts.user_id = users.id
where posts.id = ?;
      SQL
      post = execute_sql(sql, [id]).map do |e|
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

      if post.blank?
        raise RuntimeError.new(GraphqlErrorType::ARGUMENT_ERROR)
      end

      sql = <<-SQL
select comments.* from comments left join posts on comments.post_id = posts.id where posts.id = ?;
      SQL
      comments = execute_sql(sql, [id])
      post[:comments] = comments
      post
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: GraphqlErrorType::INTERNAL_SERVER_ERROR })
    end

    private

    def execute_sql(sql, params)
      cleaned_sql = Post.sanitize_sql_array([sql, *params])
      ActiveRecord::Base.connection.execute(cleaned_sql).map {|e| e}
    end
  end
end
