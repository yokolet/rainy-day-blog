## Models

### User

This app uses OAuth to authenticate a user.
The User model will have an enum type of OAuth provider and identifier.
The identifier varies depending on OAuth providers.
It might be an username (or login name) or email.
The User model's unique key is a combination of provider and identifier.

#### User Model Creation

Create a User mode by the command below:
```bash
$ rails g model User identifier:string name:string provider:integer token:string token_expiry:datetime
```
Create a migration to add constraints to the User model
```bash
$ rails g migration AddConstraintsToUser
```

```ruby
class AddConstraintsToUser < ActiveRecord::Migration[7.1]
  def change
    change_column_null(:users, :provider, false)
    change_column_null(:users, :identifier, false)
    add_index :users, [:identifier, :provider], unique: true
    add_index :users, :token, unique: true
  end
end
```

```bash
$ rails db:migrate
```

Add enum and constraints to User class
```ruby
# app/models/user.rb

class User < ApplicationRecord
  before_validation :set_default_token

  enum provider: [:twitter, :gitlab, :github]

  validates_presence_of :identifier, :provider
  validates_uniqueness_of :identifier, scope: :provider
  validates_uniqueness_of :token

  private
  def set_default_token
    self.token = SecureRandom.uuid if self.token.blank?
  end
end
```

#### User Model Spec
Create a factory for User.
```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    identifier { Faker::Internet.username(specifier: 5..10) }
    name { Faker::Name.name }
    provider { [0, 1, 2].sample }
  end
end
```

Create specs for User.
```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  it { should validate_presence_of(:identifier) }
  it { should validate_presence_of(:provider) }
  it { should validate_uniqueness_of(:identifier).scoped_to(:provider) }
  it { should validate_uniqueness_of(:token) }
end
```


### Post

#### Post Model Creation and User Model Update

Each post is written by an existing user.
The model has a reference to a user.
The Post model has two fields: title and content.

Create a User mode by the command below:
```bash
$ rails g model Post title:string{50} content:text user:references
```

Create a migration to add constraints to the Post model
```bash
$ rails g migration AddConstraintsToPost
```

```ruby
class AddConstraintsToPost < ActiveRecord::Migration[7.1]
  def change
    change_column_null(:posts, :title, false)
    change_column_null(:posts, :content, false)
    change_column(:posts, :content, :text, limit: 1000)
    remove_foreign_key(:posts, :users)
    add_foreign_key(:posts, :users, on_delete: :cascade)
  end
end
```
[Note] The last line of changing text type limitation doesn't work when
the db is PostgreSQL.

```bash
$ rails db:migrate
```

Now, a user can have multiple posts.
In light of the change, the User model should have an association to Post model.

```ruby
# app/models/user.rb
class User < ApplicationRecord
  #...
  has_many :posts, dependent: :destroy
  #...
end
```

The Post model looks like below:
```ruby
# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :content
  validates_length_of :title, minimum: 1, maximum: 50
  validates_length_of :content, minimum: 1, maximum: 1000
end
```

#### Post Model Spec and User Spec Update

Create a factory for Post.
```ruby
# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraphs }
    user { nil }
  end
end
```

Add a line to the User spec.
```ruby
# spec/models/user_spec.rb
#...
RSpec.describe User, type: :model do
  #...
  #...
  it { should have_many(:posts).dependent(:destroy) }
end
```

Create a Post spec.
```ruby
# spec/models/post_spec.rb
require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { build(:post, user: build_stubbed(:user)) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
  it { should validate_length_of(:title).is_at_least(1).is_at_most(50) }
  it { should validate_length_of(:content).is_at_least(1).is_at_most(1000) }
  it { should belong_to(:user) }
end
```

Run specs.
```bash
$ bundle exec rspec
```



### Refernces
- [ActiveRecord::Enum](https://api.rubyonrails.org/classes/ActiveRecord/Enum.html)
- [How To Setup Default Values For Attributes In Ruby On Rails](https://jtway.co/how-to-setup-default-values-for-attributes-in-ruby-on-rails-dd1d2ba38b82)
- [How to Use the Active Record Callbacks](https://reintech.io/blog/how-to-use-the-active-record-callbacks)

