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

    bounding_box([0, cursor], :width => bounds.width, :height => 140) do
      stroke_bounds if @debug
      image "#{Rails.root}/app/assets/images/orders/pdf/logo.jpg", width: 40, at: [0,cursor+6]
      text_box "Association Rencontre de Jeunesse\n 1607 Palézieux\n Suisse", at: [80, cursor], size: 8
      text_box "www.rencontredejeunesse.ch\ninfo@rencontredejeunesse.ch", size: 8, align: :right
      outputter.annotate_pdf(self, x: 280, y: 50, height: 30)
      text_box "#{@order.order_id}", size: 8, at: [280, 45], character_spacing: 1.5
    end

    bounding_box([0, cursor], :width => bounds.width, :height => 170) do
      stroke_bounds if @debug
      text "Ticket de caisse #{@order.order_id}", size: 14, style: :bold
      move_down 8

      bounding_box([0, cursor], :width => 110, :height => 100) do
        stroke_bounds if @debug
        text_box "Date de la commande
          Nunéro de Client
          Votre personne de référence
          Type de livraison
          Option de paiement
          Monnaie
          Addresse de livraison", size: 8
      end

      move_up 100

      bounding_box([120, cursor], :width => 100, :height => 100) do
        stroke_bounds if @debug
        text_box "#{@order.created_at.strftime("%d.%m.%Y")}
          #{@order.human_id}
          #{@order.user.full_name}
          PDF
          #{@order.payment_method}
          CHF
          #{@order.user.email}", size: 8
      end

      move_up 120

      bounding_box([280, cursor], :width => 180, :height => 100) do
        stroke_bounds if @debug
        text_box "#{@order.user.full_name}
          #{@order.user.address}
          #{@order.user.country}-#{@order.user.npa} #{@order.user.city}
          #{@order.user.country_name}", size: 10, leading: 1, character_spacing: 0.75
      end
    end

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

    orderRow( ["Forfait RJ", 
      "-", 
      "#{@order.created_at.strftime("%d.%m.%Y")}",
      "#{@order.product.entries}", 
      "#{'%.2f' % Records::Rj.ENTRY_PRICE(@order.created_at)}",
      "incl. 8.0%", 
      "#{'%.2f' % Records::Rj.ENTRY_PRICE(@order.created_at)}"] )
  
    orderRow( ["Places pour dormir GARS", 
      "-", 
      "#{@order.created_at.strftime("%d.%m.%Y")}",
      "#{@order.product.man_lodging}", 
      "#{'%.2f' % Records::Rj::LODGING_PRICE}",
      "incl. 8.0%", 
      "#{'%.2f' % (Records::Rj::LODGING_PRICE * @order.product.man_lodging)}"] )

    orderRow( ["Places pour dormir FILLE", 
      "-", 
      "#{@order.created_at.strftime("%d.%m.%Y")}",
      "#{@order.product.man_lodging}", 
      "#{'%.2f' % Records::Rj::LODGING_PRICE}",
      "incl. 8.0%", 
      "#{'%.2f' % (Records::Rj::LODGING_PRICE * @order.product.woman_lodging)}"] )

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
        text_box "$$$", at: [0, cursor], size: 8, align: :right
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
      bounding_box([0, cursor], :width => step*4, :height => height) do
        stroke_bounds if @debug
        text_box "#{@order.created_at.strftime("%d.%m.%Y")}", at: [0, cursor], size: 8
      end
      move_up height
      bounding_box([step*4, cursor], :width => step, :height => height) do
        stroke_bounds if @debug
        text_box "#{@order.payment_method}", at: [0, cursor], size: 8, align: :right
      end
      move_up height
      bounding_box([step*5, cursor], :width => step, :height => height) do
        stroke_bounds if @debug
        text_box "$$$", at: [0, cursor], size: 8, align: :right
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
        text_box "0.00", at: [0, cursor], size: 8, align: :right
      end
      stroke_horizontal_rule
    end
    
  end

  def orderRow data
    sum = 0
    height = 10
    horizontal_padding = [0, 180]
    6.times {horizontal_padding << (bounds.width-180)/6}
    horizontal_position = horizontal_padding.map{|x| sum += x}

    stroke_horizontal_rule
    move_down 4

    bounding_box([horizontal_position[0], cursor], :width => horizontal_padding[1], :height => height) do
      stroke_bounds if @debug
      text_box data[0], at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([horizontal_position[1], cursor], :width => horizontal_padding[2], :height => height) do
      stroke_bounds if @debug
      text_box data[1], at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([horizontal_position[2], cursor], :width => horizontal_padding[3], :height => height) do
      stroke_bounds if @debug
      text_box data[2], at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([horizontal_position[3], cursor], :width => horizontal_padding[4], :height => height) do
      stroke_bounds if @debug
      text_box data[3], at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([horizontal_position[4], cursor], :width => horizontal_padding[5], :height => height) do
      stroke_bounds if @debug
      text_box data[4], at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([horizontal_position[5], cursor], :width => horizontal_padding[6], :height => height) do
      stroke_bounds if @debug
      text_box data[5], at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([horizontal_position[6], cursor], :width => horizontal_padding[7], :height => height) do
      stroke_bounds if @debug
      text_box data[6], at: [0, cursor], size: 8, align: :right
    end

    move_down 10
  end

end