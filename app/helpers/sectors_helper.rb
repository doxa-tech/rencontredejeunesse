module SectorsHelper

  def options_for_categories
    options_for_select(
      OptionOrder.SECTOR_CATEGORIES.collect{ |c| [t("sector.categories.#{c}"), c] }.to_h
    )
  end

  # used in JS
  def self.sectors_with_label
    sectors = OptionOrder::SECTORS
    sectors.each do |k1, _|
      sectors[k1].each do |k2, _|
        sectors[k1][k2] = I18n.t("sector.attributes.#{k2}")
      end
    end
    return sectors
  end

end
