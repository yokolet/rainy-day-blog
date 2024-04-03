# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    private

    def current_user
      context[:current_user]
    end

    def authenticate!
      return true if current_user
      raise GraphQL::ExecutionError.new(
        GraphqlErrorType::AUTHENTICATION_REQUIRED,
        extensions: { code: GraphqlErrorType::AUTHENTICATION_REQUIRED }
      )
    end

    def execute_sql(sql, params)
      cleaned_sql = Post.sanitize_sql_array([sql, *params])
      ActiveRecord::Base.connection.execute(cleaned_sql).map {|e| e}
    end
  end
end
