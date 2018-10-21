shared_examples "an invoice PDF responder" do

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
    it "total_items" do
      expect(responder.total_items).to be_a String
    end
    it "total" do
      expect(responder.total).to be_a String
    end
  end

  describe "The following method should return an array of items" do
    it "items" do
      expect(responder.items).to be_an Array
      responder.items.each do |item|
        p item
        expect(item.name).to be_a String
        expect(item.number).to be_a String
        expect(item.shipping_date).to be_a String
        expect(item.quantity).to be_a String
        expect(item.tva).to be_a String
        expect(item.display_price).to be_a String
        expect(item.price).to be_a Float
      end
    end
  end

  describe "The following method should return an array of payments" do
    it "payments" do
      expect(responder.payments).to be_an Array
      responder.payments.each do |payment|
        p payment
        expect(payment.time).to be_a String
        expect(payment.payment_type).to be_a String
        expect(payment.display_amount).to be_a String
        expect(payment.amount).to be_a Float
      end
    end
  end
end
