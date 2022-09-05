
namespace :invoice do

  task custom: :environment do

        
    DatabaseCleaner.strategy = :transaction

    DatabaseCleaner.start

    user = FactoryBot.create(:user, 
      email: "foo@bar.com",
      firstname: "OM",
      lastname: "Suisse Romande",
      address: "Chemin de Bel-Air 3",
      city: "Neuchâtel",
      npa: 2000
    )

    item = FactoryBot.create(:item,
      name: "Emplacement stand - RJ 2022 Neuchâtel",
      description: "Location d'un emplacement pour un stand à la RJ.",
      price: 15000,
    )

    order = FactoryBot.create(:order, 
      user: user,
      order_items: [FactoryBot.build(:order_item,
        item: item,
        quantity: 1
      )]
    )
    order.payments.last.update(method: :invoice, status: 41)

    order.reload

    puts order.payments.last.amount
    puts order.payments.last.to_yaml

    pdf = InvoicePdf.new(order.invoice_pdf_adapter)

    pdf.render_file("invoice.pdf")

    DatabaseCleaner.clean

  end

end

