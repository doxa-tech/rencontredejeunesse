class Adapters::OrderPassRjPDFAdapter < Adapters::OrderPassPDFAdapter
  def initialize(order)
    super(order)
  end
end