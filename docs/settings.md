## Initial Settings

### Create a Rails App
- Command
```bash
$ rails new rainy-day-blog --rc=./.railsrc-blog
```

- `.railsrc-blog`
```bash
--skip-action-mailer
--skip-action-mailbox
--skip-action-cable
--skip-action-text
--skip-active-job
--skip-active-storage
--skip-javascript
-d postgresql
-T
```

- Create databases\
Since PostgreSQL will be used, databases should be created.
```bash
$ rails db:create
```

- Verify Rails will start up
```bash
$ rails s
```

Then, open http://localhost:3000/ .
It should not raise any error.

### Set Up Testing Environment

#### Gems

- Update Gemfile
```ruby
# Gemfile

group :test do
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
  gem "webmock"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "faker"
  gem "factory_bot_rails"
  gem "pry"
end
```

**IMPORTANT**\
The order matters -- factory_bot_rails should come after rspec-rails.
This is for the factor_bot generator to create factory models under spec directory.
Unless, the generator creates under test directory.

- Install gems and Rspec
```bash
$ bundle install
$ rails g rspec:install
```

#### Configurations

- Database Cleaner \
  Open spec/rails_helper.rb and set false to config.use_transactional_fixtures
  since that is taken care of by the database cleaner.

```ruby
# spec/rails_helper.rb
...
RSpec.configure do |config|
  ...
  config.use_transactional_fixtures = false
  ...
end
```
Create a file, spec/support/database_cleaner.rb, for database cleaner setup.
```ruby
# spec/support/database_cleaner.rb
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```
Add a require statement in spec/rails_helper.rb.
```ruby
...
require 'support/database_cleaner'
...
```

- Factory Bot\
  Create a file, spec/support/factory_bot.rb, for factory_bot setup.

```ruby
# spec/support/factory_bot.rb
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

Add a require statement in spec/rails_helper.rb.
```ruby
...
require 'support/factory_bot'
...
```

- Shoulda Matchers\
  Create a file, spec/support/shoulda-matchers.rb, for shoulda-matchers setup.
```ruby
# spec/support/shoulda-matchers.rb
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

Add a require statement in spec/rails_helper.rb.
```ruby
...
require 'support/shoulda-matchers'
...
```

- Webmock\
  Create a file, spec/support/webmock.rb, for a setup.
```ruby
# spec/support/webmock.rb
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
```

Add a require statement in spec/rails_helper.rb.
```ruby
...
require 'support/webmock'
...
```

### References
- [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner/blob/main/README.markdown)
- [How To Set Up Rails With RSpec, Capybara, and Database_cleaner](https://betterprogramming.pub/how-to-set-up-rails-with-rspec-capybara-and-database-cleaner-aacb000070ef)
- [Setting up RSpec and DatabaseCleaner to support multiple databases](https://medium.com/productboard-engineering/setting-up-rspec-and-databasecleaner-to-support-multiple-databases-c42bfe251112)
- [factory_bot/GETTING_STARTED.md](https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md)
- [How to Stub External Services in Tests](https://thoughtbot.com/blog/how-to-stub-external-services-in-tests)
