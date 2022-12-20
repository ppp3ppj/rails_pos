
### Getting Started (In Ruby on rails directory)
1. Go to your ruby project
```
cd rails_sensors_project
```
2. Install bundler
```
gem install bundler
```
4. Install dependencies
```
bundle install
```
5. Set ENV vars
```
cp config/application_example.yml config/application.yml
cp config/database_example.yml config/database.yml
```
6. Prepare database

```
rails db:create db:migrate db:seed
```
or
```
rails db:prepare
```
and then
```
yarn install && yarn build:css
```

7. Development
```
./bin/dev or rails 
```
8. Now, Go to localhost:3000 to see the result!
