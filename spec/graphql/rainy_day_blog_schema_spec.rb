# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RainyDayBlogSchema do
  it 'has the base mutation' do
    expect(described_class.mutation).to eq(::Types::MutationType)
  end

  it 'has the base query' do
    expect(described_class.query).to eq(::Types::QueryType)
  end
end
