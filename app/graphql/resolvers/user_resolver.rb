# frozen_string_literal: true

module Resolvers
  class UserResolver < BaseResolver
    type Types::UserType, null: false

    description 'Get a user info'

    argument :id,
             type: ::GraphQL::Types::ID,
             required: true,
             description: 'User id'

    def resolve(id:)
      User.where(id: id).select(:id, :identifier, :provider, :name).first
    end
  end
end

