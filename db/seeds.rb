# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def seedUsers(identifiers, providers)
  users = [
    {
      identifier: identifiers[0],
      provider: providers[0],
      token: SecureRandom.uuid,
      token_expiry: DateTime.now.advance(years: 5)
    },
    {
      identifier: identifiers[1],
      provider: providers[1],
      token: SecureRandom.uuid,
      token_expiry: DateTime.now.advance(years: 5)
    },
    {
      identifier: identifiers[2],
      provider: providers[2],
      token: SecureRandom.uuid,
      token_expiry: DateTime.now.advance(years: 5)
    },
    {
      identifier: identifiers[3],
      provider: providers[3],
      token: SecureRandom.uuid,
      token_expiry: DateTime.now.advance(years: -5)
    },
  ]

  User.upsert_all(
    users,
    unique_by: [:identifier, :provider],
    on_duplicate: :update,
    update_only: [:token, :token_expiry]
  )
end

def seedPosts(identifiers, providers)
  user_ids = identifiers.zip(providers).map do |ident, p|
    User.where(identifier: ident, provider: p).first.id
  end

  posts = [
    {
      user_id: user_ids[0],
      title: "The Daffodil Sky",
      content: "Architecto atque quia. Voluptates ullam aut. Repudiandae delectus explicabo."
    },
    {
      user_id: user_ids[1],
      title: "Recalled to Life",
      content: "Harum dolor impedit. Quo iste officia. Et ab nulla."
    },
    {
      user_id: user_ids[2],
      title: "Fair Stood the Wind for France",
      content: "Mollitia et consectetur. Et porro harum. Beatae facere quisquam."
    },
    {
      user_id: user_ids[3],
      title:  "Down to a Sunless Sea",
      content: "Vero architecto quia. Et tenetur exercitationem. Dolor laborum corrupti."
    },
  ]

  Post.upsert_all(posts)
end

def seedComments(identifiers, providers)
  user_ids = identifiers.zip(providers).map do |ident, p|
    User.where(identifier: ident, provider: p).first.id
  end
  post_ids = Post.where(user_id: user_ids).map {|e| e.id}
  comments = [
    {
      user_id: user_ids[0],
      post_id: post_ids[3],
      body: "Quaerat accusantium eum dicta."
    },
    {
      user_id: user_ids[1],
      post_id: post_ids[2],
      body: "Dolorum veniam qui laborum."
    },
    {
      user_id: user_ids[2],
      post_id: post_ids[1],
      body: "Ipsam quisquam voluptatem iure."
    },
    {
      user_id: user_ids[3],
      post_id: post_ids[0],
      body: "Debitis hic consequatur voluptatem."
    },
  ]
  Comment.upsert_all(comments)
  first_comments = Comment.where(post_id: post_ids)
  replies = [
    {
      user_id: user_ids[1],
      post_id: first_comments[0].post_id,
      reply_id: first_comments[0].id,
      body: "Qui est omnis laudantium.",
    },
    {
      user_id: user_ids[2],
      post_id: first_comments[1].post_id,
      reply_id: first_comments[1].id,
      body: "Non qui beatae iusto.",
    }
  ]
  Comment.upsert_all(replies)
end

identifiers = ["Yun Hintz Grady", "belva@fahey.test", "Pineapple", "petra@okeefe-lubowitz.example"]
providers = ["twitter", "gitlab", "twitter", "github"]

seedUsers(identifiers, providers)
seedPosts(identifiers, providers)
seedComments(identifiers, providers)
