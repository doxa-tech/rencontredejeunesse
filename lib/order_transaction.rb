class OrderTransaction
  include Rails.application.routes.url_helpers

  def initialize(order, payment)
    @order = order
    @payment = payment
    @user = order.user
  end

  # payment for an order
  def execute_order
    items = line_items.push(fee_item)
    items.push(discount_item) if @order.discount_amount > 0
    return execute(items)
  end

  # payment for an additional payment
  def execute_payment
    return execute([payment_item])
  end

  # complete order
  def execute(items)
    space_id = Rails.application.secrets.postfinance_space_id
    transaction_service = PostFinanceCheckout::TransactionService.new
    transaction_payment_page_service = PostFinanceCheckout::TransactionPaymentPageService.new
    transaction = transaction_create(items)

    begin
      service = transaction_service.create(space_id, transaction)
      return transaction_payment_page_service.payment_page_url(space_id, service.id)
    rescue PostFinanceCheckout::ApiError => e
      Rails.logger.fatal "Postfinance API error:"
      Rails.logger.fatal e.response_body
      return nil
    end
  end

  private

  def transaction_create(items)
    PostFinanceCheckout::TransactionCreate.new({
      billingAddress: address,
      shippingAddress: address,
      shippingMethod: "Digital",
      currency: 'CHF',
      customerEmailAddress: @user.email,
      customerPresence: PostFinanceCheckout::CustomersPresence::VIRTUAL_PRESENT,
      failedUrl: failed_orders_url,
      successUrl: success_orders_url,
      invoiceMerchantReference: @payment.payment_id,
      merchantReference: @payment.payment_id,
      language: "fr_CH",
      lineItems: items
    })
  end

  def line_items
    # group and count items (each item must appear at most 1 time)
    items = Hash.new(0)
    @order.order_items.includes(:item).each do |oi|
      items[oi.item] += oi.quantity
    end

    items.map do |item, quantity|
      PostFinanceCheckout::LineItemCreate.new({
        amountIncludingTax: item.price / 100,
        name: item.name,
        quantity: quantity,
        shippingRequired: true,
        type: PostFinanceCheckout::LineItemType::PRODUCT,
        uniqueId: item.number
      })
    end
  end

  def payment_item
    PostFinanceCheckout::LineItemCreate.new({
      amountIncludingTax: @payment.amount / 100,
      name: "Paiement supplémentaire",
      quantity: 1,
      shippingRequired: false,
      type: PostFinanceCheckout::LineItemType::PRODUCT,
      uniqueId: Order::ADDITIONAL_PAYMENT_NUMBER
    })
  end

  def fee_item
    PostFinanceCheckout::LineItemCreate.new({
      amountIncludingTax: @order.fee / 100,
      name: "Frais de transaction",
      quantity: 1,
      shippingRequired: false,
      type: PostFinanceCheckout::LineItemType::FEE,
      uniqueId: Order::FEE_NUMBER
    })
  end

  def discount_item
    PostFinanceCheckout::LineItemCreate.new({
      amountIncludingTax: @order.discount_amount / 100,
      name: "Rabais",
      quantity: 1,
      shippingRequired: false,
      type: PostFinanceCheckout::LineItemType::DISCOUNT,
      uniqueId: Order::DISCOUNT_NUMBER
    })
  end

  def address
    @address ||= PostFinanceCheckout::AddressCreate.new({
      city: @user.city,
      country: @user.country,
      emailAddress: @user.email,
      familyName: @user.lastname,
      givenName: @user.firstname,
      postCode: @user.npa,
      phoneNumber: @user.phone,
      street: @user.address
    })
  end

end