namespace :stats do

  desc "Statistics for RJ 25"
  task rj25: :environment do
    data = {
      "Aigle": {
        "weekend": [92, 88, 108],
        "friday": [96, 112],
        "saturday": [104, 116],
        "saturday night": [100, 120]
      },
      "Oron": {
        "weekend": [91, 87, 106],
        "friday": [95, 110],
        "saturday": [103, 114],
        "saturday night": [99, 118]
      },
      "Tavannes": {
        "weekend": [90, 86, 107],
        "friday": [97, 111],
        "saturday": [105, 115],
        "saturday night": [101, 119]
      },
      "Ambilly": {
        "weekend": [93, 89, 109],
        "friday": [94, 113],
        "saturday": [102, 117],
        "saturday night": [98, 121]
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