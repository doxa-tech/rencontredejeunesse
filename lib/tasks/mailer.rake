namespace :mailer do

  namespace :refund do

    desc "Send the refund#announcement email in batches"
    task announcement: :environment do
      refund_emails.each_slice(50) do |g|
        RefundMailer.announcement(g).deliver_now
        puts "#{g.length} annoucement emails sent"
        sleep(10)
      end
    end

    desc "Send the refund#announcement email in batches"
    task give: :environment do
      give_emails.each_slice(50) do |g|
        RefundMailer.give(g).deliver_now
        puts "#{g.length} give emails sent"
        sleep(10)
      end
    end

    def give_emails
      Rails.env.production? ? User.pluck(:email) - refund_emails : ["kocher.ke@gmail.com"]
    end

    def refund_emails 
      if Rails.env.production?
        User.joins(orders: [registrants: [item: :order_bundle]]).where(
          orders: { status: :paid, 
            registrants: { items: { order_bundles: { key: Refund::BUNDLE_KEYS }}}
          }
        ).distinct.pluck(:email)
      else
        ["kocher.ke@gmail.com"]
      end
    end
    
  end

  namespace :announcement do

    desc "Send an announcement"
    task rj25_oron: :environment do
      emails = User.joins(orders: :registrants).where(
        orders: { status: :paid, created_at: Date.new(2025, 02, 01)..Date.new(2025, 04, 04), 
        registrants: { item_id: [103, 99, 95, 91, 87] }}
      ).pluck(:email).uniq
      emails.each_slice(50) do |g|
        OrderMailer.announcement(g, "Information pour la RJ à Oron", "rj25_oron").deliver_now
        puts "#{g.length} give emails sent"
        sleep(10)
      end
    end

  end

end
