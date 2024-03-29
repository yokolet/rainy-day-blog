# frozen_string_literal: true

module Resolvers
  class PostsResolver < BaseResolver
    type [Types::PostsType], null: true

    description 'Get a post list'

    def resolve
      sql = <<-SQL
SELECT
    posts.id, posts.title, left(posts.content, 30) as excerpt, posts.updated_at,
    users.identifier, count(comments.id) as comment_count
FROM "posts"
left join users on posts.user_id = users.id left join comments on comments.post_id = posts.id
                GROUP BY "posts"."id", "users"."identifier"
                ORDER BY "posts"."updated_at" DESC
      SQL
      results = ActiveRecord::Base.connection.execute(sql)
      results.map {|e| e}
    end
  end
end
