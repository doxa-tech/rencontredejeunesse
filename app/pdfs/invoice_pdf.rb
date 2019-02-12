class InvoicePdf < Prawn::Document

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

    bounding_box([0, cursor], :width => bounds.width, :height => 120) do
      stroke_bounds if @debug
      text @order.title, size: 12#, style: :bold
      move_down 15

      bounding_box([0, cursor], :width => 110, :height => 90) do
        stroke_bounds if @debug
        text_box "Date de la commande
          Numéro de commande
          Nunéro de Client
          Votre personne de référence
          Type de livraison
          Option de paiement
          Monnaie
          Statut
          Adresse de livraison", size: 8
      end

      move_up 90

      bounding_box([120, cursor], :width => 120, :height => 90) do
        stroke_bounds if @debug
        text_box "#{@order.order_date}
          #{@order.order_id}
          #{@order.client_id}
          #{@order.reference_person}
          #{@order.shipping_type}
          #{@order.payment_type}
          #{@order.currency}
          #{@order.status}
          #{@order.shipping_adress}", size: 8
      end

      move_up 100

      bounding_box([291, cursor], :width => 180, :height => 100) do
        stroke_bounds if @debug
        text_box @order.recipient_adress, size: 10, leading: 1, character_spacing: 0.4
      end
    end

    move_down 30

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
      # TVA removed
      text_box "", at: [0, cursor], size: 7, align: :right
    end
    move_up height
    bounding_box([horizontal_position[6], cursor], :width => horizontal_padding[7], :height => height) do
      stroke_bounds if @debug
      text_box "Montant", at: [0, cursor], size: 7, align: :right
    end

    move_down 4

    @order.items[0..190].each do |item|
      if cursor < 110
        start_new_page
      end
      orderRow( item )
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
        text_box @order.total_items, at: [0, cursor], size: 8, align: :right
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

    text "Les conditions générales s'appliquent. ", size: 8

    move_down 30

    if cursor < 60
      start_new_page
    end

    text_box "Informations de paiement (en cas de versement nécessaire):

    Association Rencontre de Jeunesse
    1607 Palézieux - Suisse

    IBAN : CH91 0900 0000 1717 2886 0
    BIB POFICHBEXXX
    
    Mention: 'Commande #{@order.order_id}'", at: [0,cursor], size: 8

    bounding_box([0, 0], :width => 100, :height => 10) do
      stroke_bounds if @debug
      text_box "Généré le #{Time.now}", at: [0, cursor], size: 6
    end

    self.page_count.times do |i|
        self.bounding_box([self.bounds.left, self.bounds.bottom], :width => self.bounds.width, :height => 30) {
        # for each page, count the page number and write it
        self.go_to_page i+1
             self.text "#{i+1}/#{self.page_count}", :align => :right, size: 6 # write the page number and the total page count
        }
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
      text_box payment.time, at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([step*2, cursor], :width => step*3, :height => height) do
      stroke_bounds if @debug
      text_box payment.payment_type, at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([step*5, cursor], :width => step, :height => height) do
      stroke_bounds if @debug
      text_box payment.amount, at: [0, cursor], size: 8, align: :right
    end
  end

  def orderRow item
    sum = 0
    height = 20
    horizontal_padding = [0, 180]
    6.times {horizontal_padding << (bounds.width-180)/6}
    horizontal_position = horizontal_padding.map{|x| sum += x}

    stroke_horizontal_rule
    move_down 4

    bounding_box([horizontal_position[0], cursor], :width => horizontal_padding[1], :height => height) do
      stroke_bounds if @debug
      text_box item.name + "\n" + item.sub_info, at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([horizontal_position[1], cursor], :width => horizontal_padding[2], :height => height) do
      stroke_bounds if @debug
      text_box item.number, at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([horizontal_position[2], cursor], :width => horizontal_padding[3], :height => height) do
      stroke_bounds if @debug
      text_box item.shipping_date, at: [0, cursor], size: 8
    end
    move_up height
    bounding_box([horizontal_position[3], cursor], :width => horizontal_padding[4], :height => height) do
      stroke_bounds if @debug
      text_box item.quantity, at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([horizontal_position[4], cursor], :width => horizontal_padding[5], :height => height) do
      stroke_bounds if @debug
      text_box item.price, at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([horizontal_position[5], cursor], :width => horizontal_padding[6], :height => height) do
      stroke_bounds if @debug
      # item.tva
      text_box "", at: [0, cursor], size: 8, align: :right
    end
    move_up height
    bounding_box([horizontal_position[6], cursor], :width => horizontal_padding[7], :height => height) do
      stroke_bounds if @debug
      text_box item.tot_price, at: [0, cursor], size: 8, align: :right
    end

    move_down 2
  end

end
