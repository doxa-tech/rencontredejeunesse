namespace :stats do

  desc "Statistics for RJ 25"
  task rj25: :environment do
    data = {
      "Aigle": {
        "weekend": [92, 88],
        "friday": [96],
        "saturday": [104],
        "saturday night": [100]
      },
      "Oron": {
        "weekend": [91, 87],
        "friday": [95],
        "saturday": [103],
        "saturday night": [99]
      },
      "Tavannes": {
        "weekend": [90, 86],
        "friday": [97],
        "saturday": [105],
        "saturday night": [101]
      },
      "Ambilly": {
        "weekend": [93, 89],
        "friday": [94],
        "saturday": [102],
        "saturday night": [98]
      }
    }
    data.each do |site, tickets|
      puts "#{site}:"
      tickets.each do |time, items|
        size = Registrant.joins(:order).where(orders: {status: :paid}, item_id: items).size
        puts "#{time}: #{size} tickets"
      end
    end

  end

end