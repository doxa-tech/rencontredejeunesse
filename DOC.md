# Documentation

## Getting started

## Order

## Volunteers (with Option Order)

To create the volunteer form:
```ruby
# create the form
form = Form.create!(name: "volunteers-1")
form.fields << Form::Field.create!(name: "sector", field_type: "select_field", required: true, options: { sectors: ["park", "welcome"]})
form.fields << Form::Field.create!(name: "comment", field_type: "text", required: false)

# create the volunteer bundle
supertype = OrderType.create!(name: "event")
type = OrderType.create!(name: "volunteer", supertype: supertype, form: form)
bundle = Bundle.create!(name: "Bénévole RJ19", description: "Deviens bénévole à la RJ 2019 !", key: "volunteers-rj-19", order_type: type, open: false, limit: 1)
Item.create!(name: "Pass WE pour bénévole", description: "Ton pass pour le WE de la RJ", price: 5000, number: 1000, order_bundle: bundle)
```

## Permissions

## Testing