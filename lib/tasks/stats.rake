namespace :stats do

  desc "Statistics for RJ 26"
  task rj25: :environment do
    data = {
      "Early": {
        "weekend": [122]
      },
      "Préloc": {
        "weekend": [124]
      },
      "Standard": {
        "weekend": [125]
      },
      "Last minute": {
        "weekend": [126],
        "friday": [130],
        "saturday": [131],
        "saturday night": [132],
        "saturday": [133]
      }
    }
    data.each do |site, tickets|
      puts "#{site}:"
      tickets.each do |time, items|
        r = Registrant.joins(:order).where(orders: {status: :paid}, item_id: items)
        money = r.inject(0) { |sum, v| sum + v.item.price }
        puts "#{time}: #{r.size} tickets, #{money / 100} CHF"
      end
    end

  end

end