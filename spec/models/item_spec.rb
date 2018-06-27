require 'rails_helper'

RSpec.describe "Item", :type => :model do

  describe "#active" do
    
    it "is valid when item is active and no dates are specified" do
      item = create(:item, active: true, valid_from: nil, valid_until: nil)
      expect(Item.active).to include item
    end

    it "is valid when item is active and valid_until and valid_from are specified" do
      item = create(:item, active: true, valid_from: Date.yesterday, valid_until: Date.tomorrow)
      expect(Item.active).to include item
    end

    it "is valid when item is active and valid_until is specified" do
      item = create(:item, active: true, valid_from: nil, valid_until: Date.tomorrow)
      expect(Item.active).to include item
    end

    it "is valid when item is active and valid_from is specified" do
      item = create(:item, active: true, valid_from: Date.yesterday, valid_until: nil)
      expect(Item.active).to include item
    end

    it "is not valid when item is not active" do
      item = create(:item, active: false, valid_from: Date.yesterday, valid_until: Date.tomorrow)
      expect(Item.active).not_to include item
    end

  end

end
