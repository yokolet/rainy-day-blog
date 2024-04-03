# frozen_string_literal: true

module Mutations
  class CommentCreate < BaseMutation
    description "Creates a new comment"

    field :comment, Types::CommentType, null: false

    argument :body, String, required: true
    argument :post_id, ID, required: true
    argument :reply_id, ID, required: false

    def resolve(**comment_input)
      authenticate!
      comment_input[:user_id] = context[:current_user]&.id
      comment = ::Comment.new(**comment_input)
      raise GraphQL::ExecutionError.new(
        GraphqlErrorType::COMMENT_CREATE_ERROR,
        extensions: { code: GraphqlErrorType::COMMENT_CREATE_ERROR }
      ) unless comment.save

      sql = <<-SQL
select
    comments.id, comments.body, comments.post_id, comments.reply_id,
    comments.user_id, users.identifier,
    comments.updated_at
from comments left join users on comments.user_id = users.id
where comments.id = ?;
      SQL
      result = execute_sql(sql, [comment.id]).first
      { comment: result }
    rescue => e
      raise GraphQL::ExecutionError.new(
        e.message,
        extensions: {
          code: (e.respond_to?(:extensions) && e.extensions[:code]) || GraphqlErrorType::INTERNAL_SERVER_ERROR
        })
    end
  end
end
