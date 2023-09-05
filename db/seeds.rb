# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user1 = User.create(email: 'user1@example.com', password: 'password1')
user2 = User.create(email: 'user2@example.com', password: 'password2')

# Create recipe records associated with the users
Recipe.create(
  name: 'Spaghetti Carbonara',
  description: 'Classic Italian pasta dish with eggs, cheese, and pancetta.',
  user: user1
)

Recipe.create(
  name: 'Chicken Alfredo',
  description: 'Creamy pasta with grilled chicken and Alfredo sauce.',
  user: user1
)

Recipe.create(
  name: 'Vegetable Stir-Fry',
  description: 'Healthy stir-fry with assorted vegetables and tofu.',
  user: user2
)