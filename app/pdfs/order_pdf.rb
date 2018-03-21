class OrderPdf < Prawn::Document
  def initialize(order)
    super(page_size: "A4", :margin => [50,50,50,50])
    @order = order
    @debug = false

    require 'barby'
    require 'barby/barcode/code_128'
    barcode = Barby::Code128C.new(@order.order_id)
    require 'barby/outputter/prawn_outputter'
    outputter = Barby::PrawnOutputter.new(barcode)

    bounding_box([0, cursor], :width => bounds.width, :height => 80) do
      stroke_bounds if @debug
      image "#{Rails.root}/app/assets/images/orders/pdf/logo.jpg", width: 40, at: [0,cursor+6]
      text_box "Association Rencontre de Jeunesse\n 1607 Palézieux\n Suisse", at: [80, cursor], size: 8
      text_box "www.rencontredejeunesse.ch\ninfo@rencontredejeunesse.ch", size: 8, align: :right
    end

    bounding_box([0, cursor], :width => bounds.width, :height => 200) do
      stroke_bounds if @debug
      text @order.title, size: 12#, style: :bold
      move_down 15

      bounding_box([0, cursor], :width => 110, :height => 80) do
        stroke_bounds if @debug
        text_box "Date de la commande
          Nunéro de Client
          Votre personne de référence
          Type de livraison
          Option de paiement
          Monnaie
          Addresse de livraison", size: 8
      end

      move_up 80

      bounding_box([120, cursor], :width => 120, :height => 80) do
        stroke_bounds if @debug
        text_box "#{@order.order_date}
          #{@order.client_id}
          #{@order.reference_person}
          #{@order.shipping_type}
          #{@order.payment_type}
          #{@order.currency}
          #{@order.shipping_adress}", size: 8
      end

      move_up 100

      bounding_box([291, cursor], :width => 180, :height => 100) do
        stroke_bounds if @debug
        text_box @order.recipient_adress, size: 10, leading: 1, character_spacing: 0.4
      end
      
      delta = 3
      min_x = 0
      min_y = 30
      max_x = 240
      max_y = 95
      drawCorner(min_x, min_y, delta, delta)
      drawCorner(min_x, max_y, delta, -delta)
      drawCorner(max_x, min_y, -delta, delta)
      drawCorner(max_x, max_y, -delta, -delta)

      outputter.annotate_pdf(self, x: 240/2 - outputter.width/2, y: 50, height: 30)
      text_box "#{@order.display_order_id}", size: 9, at: [240/2 - outputter.width/2, 45], character_spacing: 1.5
    end

    move_down 10

    sum = 0
    height = 10
    horizontal_padding = [0, 180]
    6.times {horizontal_padding << (bounds.width-180)/6}
    horizontal_position = horizontal_padding.map{|x| sum += x}

    bounding_box([horizontal_position[0], cursor], :width => horizontal_padding[1], :height => height) do
      stroke_bounds if @debug
      text_box "Description", at: [0, cursor], size: 7
    end
    move_up height
    bounding_box([horizontal_position[1], cursor], :width => horizontal_padding[2], :height => height) do
      stroke_bounds if @debug
      text_box "Numéro d'article", at: [0, cursor], size: 7
    end
    move_up height
    bounding_box([horizontal_position[2], cursor], :width => horizontal_padding[3], :height => height) do
      stroke_bounds if @debug
      text_box "Livraison", at: [0, cursor], size: 7
    end
    move_up height
    bounding_box([horizontal_position[3], cursor], :width => horizontal_padding[4], :height => height) do
      stroke_bounds if @debug
      text_box "Quantité", at: [0, cursor], size: 7, align: :right
    end
    move_up height
    bounding_box([horizontal_position[4], cursor], :width => horizontal_padding[5], :height => height) do
      stroke_bounds if @debug
      text_box "Prix", at: [0, cursor], size: 7, align: :right
    end
    move_up height
    bounding_box([horizontal_position[5], cursor], :width => horizontal_padding[6], :height => height) do
      stroke_bounds if @debug
      text_box "TVA", at: [0, cursor], size: 7, align: :right
    end
    move_up height
    bounding_box([horizontal_position[6], cursor], :width => horizontal_padding[7], :height => height) do
      stroke_bounds if @debug
      text_box "Montant", at: [0, cursor], size: 7, align: :right
    end

    move_down 4

    @order.products.each do |product|
      orderRow( product )
    end

    move_down 20

    bounding_box([180, cursor], :width => bounds.width-180, :height => 30) do
      stroke_bounds if @debug
      step = (bounds.width)/6
      bounding_box([0, cursor], :width => step*4, :height => height) do
        stroke_bounds if @debug
        text_box "Montant total", at: [0, cursor], size: 8
      end
      move_up height
      bounding_box([step*4, cursor], :width => step, :height => height) do
        stroke_bounds if @debug
        text_box "CHF incl.", at: [0, cursor], size: 8, align: :right
      end
      move_up height
      bounding_box([step*5, cursor], :width => step, :height => height) do
        stroke_bounds if @debug
        text_box @order.total_products, at: [0, cursor], size: 8, align: :right
      end
      stroke_horizontal_rule
    end

    bounding_box([180, cursor], :width => bounds.width-180, :height => 30) do
      stroke_bounds if @debug
      step = (bounds.width)/6
      bounding_box([0, cursor], :width => step*4, :height => height) do
        stroke_bounds if @debug
        text_box "Paiement", at: [0, cursor], size: 8
      end
      move_down 4

      @order.payments.each do |payment|
        paymentRow(payment)
      end

      move_down 10
      bounding_box([0, cursor], :width => step*4, :height => height) do
        stroke_bounds if @debug
        text_box "Montant dû", at: [0, cursor], size: 8
      end
      move_up height
      bounding_box([step*4, cursor], :width => step, :height => height) do
        stroke_bounds if @debug
        text_box "CHF incl.", at: [0, cursor], size: 8, align: :right
      end
      move_up height
      bounding_box([step*5, cursor], :width => step, :height => height) do
        stroke_bounds if @debug
        text_box @order.total, at: [0, cursor], size: 8, align: :right
      end
      stroke_horizontal_rule
    end

    move_down 50

    text "Ce document sert de justificatif d'achat. Veillez à l'avoir sur vous dans le cas où vous deviez retirer un ou plusieurs produits. Les conditions générales s'appliquent. ", size: 8
    
    bounding_box([10, 0], :width => 50, :height => 10) do
      stroke_bounds
    end

  end

  def drawCorner(x, y, delta1, delta2)
    self.join_style = :round
    stroke do
      move_to(x+delta1, y)
      line_to(x, y)
      line_to(x, y+delta2)
    end
  end

  def paymentRow payment
    step = (bounds.width)/6
    height = 10
    bounding_box([0, cursor], :width => step*2, :height => height) do
      stroke_bounds if @debug
      text_box payment.date, at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([step*2, cursor], :width => step*3, :height => height) do
      stroke_bounds if @debug
      text_box payment.payment_type, at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([step*5, cursor], :width => step, :height => height) do
      stroke_bounds if @debug
      text_box payment.display_amount, at: [0, cursor], size: 8, align: :right
    end
  end

  def orderRow product
    sum = 0
    height = 10
    horizontal_padding = [0, 180]
    6.times {horizontal_padding << (bounds.width-180)/6}
    horizontal_position = horizontal_padding.map{|x| sum += x}

    stroke_horizontal_rule
    move_down 4

    bounding_box([horizontal_position[0], cursor], :width => horizontal_padding[1], :height => height) do
      stroke_bounds if @debug
      text_box product.description, at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([horizontal_position[1], cursor], :width => horizontal_padding[2], :height => height) do
      stroke_bounds if @debug
      text_box product.product_number, at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([horizontal_position[2], cursor], :width => horizontal_padding[3], :height => height) do
      stroke_bounds if @debug
      text_box product.shipping_date, at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([horizontal_position[3], cursor], :width => horizontal_padding[4], :height => height) do
      stroke_bounds if @debug
      text_box product.quantity, at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([horizontal_position[4], cursor], :width => horizontal_padding[5], :height => height) do
      stroke_bounds if @debug
      text_box product.price, at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([horizontal_position[5], cursor], :width => horizontal_padding[6], :height => height) do
      stroke_bounds if @debug
      text_box product.tva, at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([horizontal_position[6], cursor], :width => horizontal_padding[7], :height => height) do
      stroke_bounds if @debug
      text_box product.display_amount, at: [0, cursor], size: 8, align: :right
    end

    move_down 10
  end

end