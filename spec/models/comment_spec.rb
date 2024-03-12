require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build(:comment, user: build_stubbed(:user), post: build_stubbed(:post)) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(1).is_at_most(300) }
  it { should belong_to(:user) }
  it { should belong_to(:post) }
end
