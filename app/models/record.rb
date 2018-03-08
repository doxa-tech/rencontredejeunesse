class Record < ApplicationRecord

  self.abstract_class = true

  has_one :order, as: :product, dependent: :nullify

  private

  def calculate_entries
    self.entries = selected_participants.size
  end

  def selected_participants
    participants.select { |p| !p.marked_for_destruction? }
  end

end
