# Recipe API

## Task description

The task is to design a HTTP based API as the backend to be consumed by a single page
application (from a browser). You can freely choose the API design.
Your users should be able to:
1. see a list of all recipes 
2. search for a recipe or an ingredient 
3. retrieve details of a specific recipe(title, description, ingredients, image)
4. add a recipe
5. edit/delete its own recipes
6. see a user's shopping list
7. add ingredients to a shopping list
8. add a recipe's ingredients to a shopping list
9. invite friends to your shopping list
10. friends can add ingredients or recipes to it
11. friends can remove only ingredients which they had added before

Additionally, users must present a JWT to authorize requests. You can accept JWTs with a
configurable public key, own logic to create JWTs is not required.
Users shall receive an e-mail the day after they submitted their first recipe.

## Requirements

Ruby - 3.0.0

Rails - 7.0.4

Sidekiq - 6.5.5

Redis - 5.0.7

## Running

1. After installing the project itself run `bundle install`;

2. To run API locally you should create database(you should have PostgreSQL user `root:root`):

    Creation of database: `rails db:create`
   
   Filling DB with start data: `rails db:seed`

3. To check that all is OK you can run `bundle exec rspec`;

4. To start the application itself run `rails s` in your project console;

5. To starting sidekiq run `bundle exec sidekiq -q default` in your project console;

## Usage

You can use annotation(postman folder with all possible commands) to test this API.
