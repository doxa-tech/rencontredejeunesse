class Volunteer < ApplicationRecord
  belongs_to :user

  enum sector: [:install, :uninstall, :door, :welcome, :park, :accommodation, :install_technique, :uninstall_technique]

end
