# Documentation

## Getting started

Create the superuser:
```
# create the user
rails superuser
# create the permissions
rails adeia_elements
# Add the permission to the superuser
rake adeia:superuser user_id=1
```
You can now use the superuser with the email "kocher.ke@gmail.com" and the password "12341".

## Order

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

The project use the adeia gem to manage the permissions. ([see documentation](https://github.com/JS-Tech/adeia))

## Testing

The project use Cucumber and Rspec for testing. Both use Capybara to interact with the app. Cucumber uses Selenium with the headless chrome driver.
Run the tests:
```
rake cucumber
rspec spec/
```