namespace :users do

  task clean: [:export, :reset, :import]

  task export: :environment do
    data = User.with_account.to_json(except: :id)
    File.open(filename, "a") do |f|
      f.truncate(0)
      f.write data
    end
    puts "Users successfully exported !"
  end

  task import: :environment do
    data = File.read(filename)
    json = JSON.parse(data)
    json.each do |attributes|
      user = User.new(attributes)
      user.save(validate: false)
    end
    puts "Users successfully imported !"
  end

  task reset: :environment do
    DatabaseCleaner.clean_with(:truncation, only: ["users"])
    puts "Users table successfully reset !"
  end

  task generate_verify_token: :environment do
    User.all.each do |user|
      user.update_attribute(:verify_token, SecureRandom.urlsafe_base64)
    end
  end

  def filename
    @filename ||= Rails.root.join("lib", "assets", "users.json")
  end

end
