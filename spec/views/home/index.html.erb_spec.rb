require 'rails_helper'

RSpec.describe "home/index.html.erb", type: :view do
  it "renders id app" do
    render
    expect(rendered).to match(/app/)
  end
end
