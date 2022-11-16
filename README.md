# Recipe API

## Requirements

Ruby - 3.0.0

Rails - 7.0.4

Sidekiq - 6.5.5

## Running

1. After installing the project itself run `bundle install`;

2. To run API locally you should create database(you should have PostgreSQL user `root:root`):

    Creation of database: `rails db:create`
   
   Filling DB with start data: `rails db:seed`

3. To check that all is OK you can run `bundle exec rspec`;

4. To start the application itself run `rails s` in your project console;

## Usage

You can use annotation(postman folder with all possible commands) to test this API.
