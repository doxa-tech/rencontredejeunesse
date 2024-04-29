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

  namespace :information do

    desc "Send the information about hosting"
    task hosting: :environment do
      emails = User.joins(orders: :registrants).where(
        orders: { status: :paid, 
          registrants: { item_id: [80, 71, 68, 69] }
        }
      ).where("orders.created_at <= ?", DateTime.parse("2024-04-29 20:00")).distinct.pluck(:email)
      emails.each_slice(50) do |g|
        OrderMailer.hosting(g).deliver_now
        puts "#{g.length} give emails sent"
        sleep(10)
      end
    end

  end

end