# Rainy Day Blog

### Repository: [https://gitlab.com/yokolet/rainy-day-blog](https://gitlab.com/yokolet/rainy-day-blog)

<img src="./docs/pink-cherry-blossom-in-rain.jpeg" height="200">

Rainy Day Blog is a sample Rails app to showcase how to create a blog.

On a calm rainy day, surrounded by soft sound of pouring rain,
people might write blog posts feeling fresh air.
This is why the title is Rainy Day Blog.

### Key Technologies
- Ruby on Rails
  - PostgreSQL
  - Redis
  - RSpec
  - GraphQL Ruby
  - Vite Ruby
- Vue 3
  - Vite
  - Bun
  - Composition API
  - Vue Router
  - Pinia
  - VueUse
  - Vue Apollo
  - Font Awesome
  - Tailwind CSS
  - Daisy UI
- OAuth2 PKCE (Authorization Code Flow with Proof Key for Code Exchange)
- GraphQL

### Versions
- Ruby 3.2.3
- Rails 7.1.3.2
- PostgreSQL 15.6
- Redis 7.2.4
- Bun 1.0.30

### How to Run

##### Prerequisite

Install below:
- Ruby [https://www.ruby-lang.org/en/](https://www.ruby-lang.org/en/)
- Bundler [https://bundler.io/](https://bundler.io/)
- PostgreSQL [https://www.postgresql.org/](https://www.postgresql.org/)
- Redis [https://redis.io/](https://redis.io/)
- Bun [https://bun.sh/](https://bun.sh/)

Create an app at Twitter for OAuth2 PKCE authentication.
- [https://developer.twitter.com/en/docs/apps/overview](https://developer.twitter.com/en/docs/apps/overview)

##### Source Code

Clone the repo:
```bash
$ git clone https://gitlab.com/yokolet/rainy-day-blog.git
```

##### Install the App
```bash
$ cd rainy-day-blog
$ bundle install
$ rails db:create
$ rails db:migrate
$ rails db:seed
$ bun install
```

##### Setup Credentials

The app uses JWT secret token and client id and secret of your Twitter app.

JWT secret can be created in many ways, for example, using `node` command:
```bash
$ node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

The client id and secret of your Twitter app can be seen on the Twitter developer portal.

Use the command below to edit credentials. Change the editor to your favorite one.
```bash
$ EDITOR=vim rails credentials:edit
```

The credentials structure should be below:
```
jwt_secret: YOUR_JWT_SECRET
twitter:
  client_id: YOUR_TWITTER_APP_CLIENT_ID
  client_secret: YOUR_TWITTER_APP_CLIENT_SECRET
```

#### Run the App
```bash
$ bin/dev
```

### Run specs
```bash
$ bundle exec rspec
```
