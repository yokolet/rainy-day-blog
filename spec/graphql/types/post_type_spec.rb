# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::PostType, type: :graphql do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:title).of_type('String!') }
  it { is_expected.to have_field(:content).of_type('String!') }
  it { is_expected.to have_field(:user).of_type('User!') }
  it { is_expected.to have_field(:comments).of_type('[Comment!]') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
end
