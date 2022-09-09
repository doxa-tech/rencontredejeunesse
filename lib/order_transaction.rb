class OrderTransaction
  include Rails.application.routes.url_helpers

  def initialize(order, payment)
    @order = order
    @payment = payment
    @user = order.user
  end

  def execute
    space_id = Rails.application.secrets.postfinance_space_id
    transaction_service = PostFinanceCheckout::TransactionService.new
    transaction_payment_page_service = PostFinanceCheckout::TransactionPaymentPageService.new
    
    begin
      service = transaction_service.create(space_id, transaction)
      return transaction_payment_page_service.payment_page_url(space_id, service.id)
    rescue PostFinanceCheckout::ApiError => e
      puts e.response_body
      fail e
    end
  end

  private

  def transaction
    line_items = items.push(fee)
    line_items.push(discount) if @order.discount_amount > 0

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
      lineItems: line_items
    })
  end

  def items
    @order.order_items.includes(:item).map do |oi|
      PostFinanceCheckout::LineItemCreate.new({
        amountIncludingTax: oi.item.price / 100,
        name: oi.item.name,
        quantity: oi.quantity,
        shippingRequired: true,
        type: PostFinanceCheckout::LineItemType::PRODUCT,
        uniqueId: oi.item.number
      })
    end
  end

  def fee
    PostFinanceCheckout::LineItemCreate.new({
      amountIncludingTax: @order.fee / 100,
      name: "Frais de transaction",
      quantity: 1,
      shippingRequired: false,
      type: PostFinanceCheckout::LineItemType::FEE,
      uniqueId: Order::FEE_NUMBER
    })
  end

  def discount
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