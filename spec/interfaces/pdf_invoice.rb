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
  end

  describe "The following method should return an array of product" do
    it "products" do
      expect(responder.products).to be_an Array
      expect(responder.products).to all( be_a_kind_of responder.product)
    end
  end
end