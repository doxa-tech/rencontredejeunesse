class Admin::Rj24Controller < Admin::BaseController

    def stats
        @weekend = Registrant.joins(:order).where(orders: { status: "paid" }, item_id: [67,68,70,71,79,80]).count
        @friday = Registrant.joins(:order).where(orders: { status: "paid" }, item_id: 75).count
        @saturday_day = Registrant.joins(:order).where(orders: { status: "paid" }, item_id: 76).count
        @saturday_evening = Registrant.joins(:order).where(orders: { status: "paid" }, item_id: 77).count
        @sunday = Registrant.joins(:order).where(orders: { status: "paid" }, item_id: 78).count
        @hosting = Registrant.joins(:order).where(orders: { status: "paid" }, item_id: [68,69,71,80]).count
    end

end
