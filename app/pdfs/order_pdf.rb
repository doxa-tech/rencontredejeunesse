class OrderPdf < Prawn::Document
  def initialize(order)
    super(page_size: "A4")
    @order = order
    define_grid(:columns => 4, :rows => 4)
    # grid.show_all
 

    grid(0,0).bounding_box do
      image "#{Rails.root}/app/assets/images/orders/pdf/logo.jpg", width: 40
    end
   
    grid([1,0],[1,1]).bounding_box do
      order_number
    end
  end

  def order_number
    text "Order \##{@order.order_id}", size: 24, style: :bold
  end
end