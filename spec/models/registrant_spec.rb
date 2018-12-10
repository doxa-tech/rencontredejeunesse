require 'rails_helper'

RSpec.describe "Registrant", :type => :model do

  it "should generate an ticket id" do
    registrant = create(:registrant)
    expect(registrant.ticket_id).to be_present  
  end

end
