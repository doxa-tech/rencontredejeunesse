shared_examples "a ticket PDF responder" do

describe "The following method should return an array of tickets" do
    it "tickets" do
      expect(responder.tickets).to be_an Array
    end
    it "tickets elements" do
      responder.tickets.each do |ticket|
        expect(ticket.title).to be_a String
        expect(ticket.subtitle1).to be_a String
        expect(ticket.subtitle2).to be_a String
        expect(ticket.subtitle3).to be_a String
        expect(ticket.dates).to be_a String
        expect(ticket.times).to be_a String
        expect(ticket.loc1).to be_a String
        expect(ticket.loc2).to be_a String
        expect(ticket.loc3).to be_a String
        expect(ticket.loc4).to be_a String
        expect(ticket.price).to be_a String
        expect(ticket.orga1).to be_a String
        expect(ticket.orga2).to be_a String
        expect(ticket.orga3).to be_a String
        expect(ticket.orga4).to be_a String
        expect(ticket.logo).to be_a String
        expect(ticket.issued_for).to be_a String
        expect(ticket.main_code).to be_a String
        expect(ticket.main_code_str).to be_a String
        expect(ticket.sub1_code).to be_a String
        expect(ticket.sub2_code).to be_a String
        expect(ticket.contact).to be_a String
      end
    end
  end

end
