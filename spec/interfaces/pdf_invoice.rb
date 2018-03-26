shared_examples "a PDF invoice responder" do

  describe "The following method must return a string:" do
    it "recipient_adress" do
      expect(responder.recipient_adress).to be_a String
    end
    it "title" do
      expect(responder.title).to be_a String
    end
    it "order_date" do
      expect(responder.order_date).to be_a String
    end
    it "client_id" do
      expect(responder.client_id).to be_a String
    end
    it "reference_person" do
      expect(responder.reference_person).to be_a String
    end
    it "shipping_type" do
      expect(responder.shipping_type).to be_a String
    end
    it "payment_type" do
      expect(responder.payment_type).to be_a String
    end
    it "currency" do
      expect(responder.currency).to be_a String
    end
    it "shipping_adress" do
      expect(responder.shipping_adress).to be_a String
    end
    it "order_id" do
      expect(responder.order_id).to be_a String
    end
    it "total_products" do
      expect(responder.total_products).to be_a String
    end
    it "total" do
      expect(responder.total).to be_a String
    end
  end

  describe "The following method should return an array of products" do
    it "products" do
      expect(responder.products).to be_an Array
      responder.products.each do |product|
        expect(product.description).to be_a String
        expect(product.product_number).to be_a String
        expect(product.shipping_date).to be_a String
        expect(product.quantity).to be_a String
        expect(product.price).to be_a String
        expect(product.tva).to be_a String
        expect(product.display_amount).to be_a String
        expect(product.amount).to be_a Float
      end
    end
  end

  describe "The following method should return an array of payments" do
    it "payments" do
      expect(responder.payments).to be_an Array
      responder.payments.each do |payment|
        expect(payment.date).to be_a String
        expect(payment.payment_type).to be_a String
        expect(payment.display_amount).to be_a String
        expect(payment.amount).to be_a Float
      end
    end
  end
end
