module Records

  class Rj < Record
    self.table_name = 'records_rj'

    has_one :order, as: :product
  end

end
