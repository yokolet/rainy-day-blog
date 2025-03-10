require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  it { should validate_presence_of(:identifier) }
  it { should validate_presence_of(:provider) }
  it { should validate_uniqueness_of(:identifier).scoped_to(:provider) }
  it { should validate_uniqueness_of(:token) }
  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
end
