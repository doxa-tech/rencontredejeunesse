# Documentation

## Getting started

Create the superuser:

```sh
# create the user
rails seed:superuser
# create the permissions
rails seed:adeia_elements
# Add the permission to the superuser
rake adeia:superuser user_id=1
# Confirm its email
rails c
User.find(1).update_attribute :confirmed, true
```

You can now use the superuser with the email "kocher.ke@gmail.com" and the password "12341".

## Order

Database design:

The core table is `orders`. Every order made by a client has a record in it. There are two types of order, designed with a single table inheritance: `regular` and `event`.

- `regular`: an order of `items`, the record has many `items` (many-to-many association).
- `event`: an order of `tickets`, the record has many `tickets` (many-to-many association). In fact, `tickets` are `items` (the table is called `items`) . The difference is in the junctions table: the junctions table `registrants` contains the personal information of the client ordering a ticket.

Order bundles: an order bundle is a collection of `items`. In case of an event for example, the ticket options (1-day, 2-days, etc) are collected in an order bundle so that it can be sold in a form.
The table is called `order_bundles`. A record has many `items`, a `key` as an identifier and belongs to an `order_type`.
An `order_type` defines the type of the bundle, i.g the type of order it matches (`regular` or `event`). A type can belong to another type (self inheritance), allowing subtypes of `regular` or `event`.

### Create a bundle

```ruby
options = {"loc1"=>"CDV", "loc2"=>"Mille-Boilles 4", "loc3"=>"2000 Neuchâtel", "loc4"=>"Suisse", "dates"=>"04.02.23", "orga1"=>"Association Rencontre de Jeunesse", "orga2"=>"1607 Palézieux", "orga3"=>"Suisse", "orga4"=>"www.rencontredejeunesse.ch", "times"=>"09h00-22h00", "upinfo"=>"https://rencontredejeunesse.ch", "contact"=>"info@rencontredejeunesse.ch", "sub1_code"=>"#login23", "subtitle3"=>"À présenter le jour de l'événement"} 

OrderBundle.create(name: "RJ Login 23", description: "La journée qui réunit les leaders de Suisse romande", key: "rj-login-23", open: true, options: options, order_type: "event")
```

## Volunteers (with Option Order)

To create the volunteer form:

```ruby
# create the form
form = Form.create!(name: "volunteers-1")
Form::Field.create!(name: "sector", field_type: "select_field", required: true, options: { sectors: ["park", "welcome"]}, form: form)
Form::Field.create!(name: "comment", field_type: "text", required: false, form: form)

# create the volunteer bundle
supertype = OrderType.create!(name: "event")
type = OrderType.create!(name: "volunteer", supertype: supertype, form_id: form.id)
bundle = OrderBundle.create!(name: "Bénévole RJ19", description: "Deviens bénévole à la RJ 2019 !", key: "volunteers-rj-19", order_type: type, open: false, limit: 1)
Item.create!(name: "Pass WE pour bénévole", description: "Ton pass pour le WE de la RJ", price: 5000, number: 1000, order_bundle: bundle)
```

## Permissions

The project uses the adeia gem to manage the permissions. ([see documentation](https://github.com/JS-Tech/adeia))

## Notifications

The application can send push notifications using the gem RPush. 
In order to work, you have to:

- Include the `fcm_server_key` in your secrets.yml. You find it in the Firebase console.
- Create an RPush app using these instructions: https://github.com/rpush/rpush#firebase-cloud-messaging

## Testing

The project uses Cucumber and Rspec for testing. Both use Capybara to interact with the app. Cucumber uses Selenium with the headless chrome driver.
Run the tests:

```
rake cucumber
rspec spec/
```