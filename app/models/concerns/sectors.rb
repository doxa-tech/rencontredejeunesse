module Sectors
  extend ActiveSupport::Concern

  SECTORS = {
    log:
      { hosts: 0, lounge: 1, volunteers: 2, setup: 3, disassembly: 4, cleaning: 5, decoration: 6 },
    animation:
      { fun_park: 7, photography: 8, lights: 9, goodies: 10 },
    security:
      { security: 11, doors: 12, lodging: 13, welcoming: 14, care: 15 },
    session:
      { prayer: 16, opening: 17 },
    technical:
      { video: 18, technical_setup: 19 }
  }

  class_methods do

    def SECTORS_TO_ENUM
      SECTORS.values.reduce Hash.new, :merge
    end

    def SECTOR_CATEGORIES
      SECTORS.keys
    end

  end

end
