class TicketPdf < Prawn::Document

  def initialize(ticket_order)
    super(page_size: "A4", :margin => [35,30,40,30])
    @ticket_order = ticket_order
    @debug = false

    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/prawn_outputter'
    require 'barby/barcode/qr_code'

    first = true
    @ticket_order.tickets.each do |ticket|
      if not first
        start_new_page
      else
        first = false
      end

      barcode = Barby::Code128C.new(ticket.main_code)
      outputter = Barby::PrawnOutputter.new(barcode)
      qr_code = Barby::QrCode.new(ticket.main_code)
      outputter_qr = Barby::PrawnOutputter.new(qr_code)

      self.font_families.update("omnes" =>  {
        :italic => Rails.root.join("app/assets/fonts/pdf/omnes-medium-italic.ttf"),
        :normal => Rails.root.join("app/assets/fonts/pdf/omnes-regular.ttf"),
        :bold_italic => Rails.root.join("app/assets/fonts/pdf/omnes-bold-italic.ttf"),
        :bold => Rails.root.join("app/assets/fonts/pdf/omnes-semibold.ttf"),
      })
      height = 300
      info_w = bounds.width / 1.4
      banner_h = 40
      font "omnes"

      # Main first rectangle
      bounding_box([0, cursor], width: bounds.width, height: height) do
        stroke_bounds if @debug

        # Main infos area
        bounding_box([0, cursor], width: info_w, height: height) do
          stroke_bounds if @debug
          # Logo/banner part
          bounding_box([0, cursor], width: info_w, height: banner_h) do
            stroke_bounds if @debug
            fill_color "f19d3c"
            fill_rectangle [0, cursor], info_w, banner_h
            fill_color "000000"
            text_box "Ticket Pass", at: [20, cursor-15], size: 20, style: :bold_italic
            fill_color "ffffff"
            text_box ticket.upinfo, at: [info_w-100, 10], size: 6, style: :italic
            fill_color "000000"
          end
          # Infos part
          pad = 13
          bounding_box([pad, cursor], width: info_w-pad, height: height-banner_h) do
            stroke_bounds if @debug
            move_down 10
            text_box "Event/Gig:", at: [0, cursor], size: 4
            move_down 7
            draw_special_line(-1, cursor, info_w-pad, 1.6)
            move_down 8
            text_box ticket.title, at: [0, cursor], size: 16, style: :bold
            move_down 20
            text_box ticket.subtitle1, at: [0, cursor], size: 13
            move_down 28
            text_box ticket.subtitle2, at: [0, cursor], size: 11
            move_down 14
            text_box ticket.subtitle3, at: [0, cursor], size: 11
            move_down 20
            
            row_pad = 15
            width1, width2, width3 = 130, 90
            width3 = info_w - pad - width1 - row_pad - width2 - row_pad
            height1, height2 = 30, 64
            # Date, location, price, time, organizer
            bounding_box([0, cursor], width: info_w-pad, height: height1+height2) do
              stroke_bounds if @debug
              # Row 1 col 1
              bounding_box([0, cursor], width: width1, height: height1) do
                stroke_bounds if @debug
                text_box "Dates:", at: [0, cursor], size: 4
                move_down 7
                draw_special_line(-1, cursor, width1, 1.6)
                move_down 5
                text_box ticket.dates, at: [0, cursor], style: :bold, size: 11
              end
              # Row 2 col 1
              bounding_box([0, cursor], width: width1, height: height2) do
                stroke_bounds if @debug
                text_box "Lieu:", at: [0, cursor], size: 4
                move_down 7
                draw_special_line(-1, cursor, width1, 1.6)
                move_down 5
                text_box ticket.loc1, at: [0, cursor], style: :bold, size: 9
                move_down 11
                text_box ticket.loc2, at: [0, cursor], size: 9
                move_down 9
                text_box ticket.loc3, at: [0, cursor], size: 9
                move_down 10
                text_box ticket.loc4, at: [0, cursor], size: 9
              end
              move_up height1+height2
              # Row 1 col 2
              bounding_box([width1 + row_pad, cursor], width: width2, height: height1) do
                stroke_bounds if @debug
                text_box "Début/Fin:", at: [0, cursor], size: 4
                move_down 7
                draw_special_line(-1, cursor, width2, 1.6)
                move_down 5
                text_box ticket.times, at: [0, cursor], style: :bold, size: 11
              end
              # Row 2 col 2
              bounding_box([width1 + row_pad, cursor], width: width2, height: height2) do
                stroke_bounds if @debug
                text_box "Prix:", at: [0, cursor], size: 4
                move_down 7
                draw_special_line(-1, cursor, width2, 1.6)
                move_down 5
                text_box ticket.price, at: [0, cursor], style: :bold, size: 11
              end
              move_up height1+height2
              # Row 1 col 2
              bounding_box([width1 + row_pad + width2 + row_pad, cursor], width: width3, height: height1+height2) do
                stroke_bounds if @debug
                image "#{Rails.root}/app/assets/images/#{ticket.logo}", width: 25, at: [width3-40,cursor+30]
                text_box "Organisateurs:", at: [0, cursor], size: 4
                move_down 7
                draw_special_line(-1, cursor, width3, 1.6)
                move_down 5
                text_box ticket.orga1, at: [0, cursor], style: :bold, size: 7
                move_down 10
                text_box ticket.orga2, at: [0, cursor], size: 7
                move_down 9
                text_box ticket.orga3, at: [0, cursor], size: 7
                move_down 9
                text_box ticket.orga4, at: [0, cursor], size: 7
              end
              # row 3
              bounding_box([0, cursor], width: info_w-pad, height: 40) do
                stroke_bounds if @debug
                fill_color "FF9912"
                text_box "Émis pour", at: [0, cursor], size: 11
                fill_color "000000"
                move_down 17
                text_box ticket.issued_for, at: [0, cursor], size: 16, style: :bold
                move_down 18
                draw_special_line(-1, cursor, info_w-pad, 1.6)
              end
            end
          end
        end
        move_up height
        barcode_pad = 5
        # Barecodes area
        bounding_box([info_w+barcode_pad, cursor], width: bounds.width-info_w-2*barcode_pad, height: height) do
          stroke_bounds if @debug
          qr_width = bounds.width * 0.4
          qr_x = bounds.width / 2 - 0.5*qr_width 
          move_down qr_width + 15
          scale = qr_width / outputter_qr.width
          outputter_qr.annotate_pdf(self, x: qr_x , y: cursor, xdim: scale)
          move_down 34
          scale = bounds.width / outputter.width
          outputter.annotate_pdf(self, x: 0 , y: cursor, height: 20, xdim: scale)
          move_down 5
          text_box ticket.sub1_code, size: 9.6, style: :bold, at: [0, cursor], align: :center, width: bounds.width
          barecode_height = 80
          move_down barecode_height + 13
          outputter.annotate_pdf(self, x: 0 , y: cursor, height: barecode_height, xdim: scale)
          move_down 5
          text_box "#{ticket.main_code_str}", size: 9.6, at: [0, cursor], character_spacing: 1.2, align: :center, width: bounds.width, style: :bold
          barecode_height = 39
          move_down barecode_height + 13
          outputter.annotate_pdf(self, x: 0 , y: cursor, height: barecode_height, xdim: scale)
          move_down 2
          fill_rectangle [0, cursor], bounds.width, 12
          fill_color "ffffff"
          move_down 3
          text_box ticket.sub2_code, at: [0, cursor], size: 7.7, style: :bold, align: :center, width: bounds.width
          fill_color "000000"
        end

        stroke do
          self.line_width = 2
          self.cap_style = :round
          stroke_color "f19d3c"
          horizontal_line 0, bounds.width, at: height
          stroke_gradient [0, height], [0, 0], "f19d3c", "ffffff"
          vertical_line 0, height, at: 0
          vertical_line 0, height, at: bounds.width
        end
        self.line_width = 1
        stroke_color "000000"
      end

      height = 200
      # Second part with instructions
      bounding_box([0, cursor], width: bounds.width, height: height) do
        stroke_bounds if @debug
        draw_special_waves(0, cursor, bounds.width, 3, 0.7)
        move_down 10
        sub_height = 120
        pad = 10
        bounding_box([0, cursor], width: bounds.width/2- pad/2, height: sub_height) do
          stroke_bounds if @debug
          fill_color "f19d3c"
          text_box "Utilisation", at: [0, cursor], style: :bold_italic, size: 16
          fill_color "000000"
          move_down 20
          text_box "Merci pour l'achat de ce pass!\nVous pouvez imprimer ce billet au format DIN A4. Imprimer en couleur ou noir/blanc n'a pas d'importance tant que la lecture est possible. Le code-bar à droite doit particulièrement être lisible, ainsi veuillez ne pas le plier. Traitez ce pass comme s'il s'agissait d'argent. Si vous le perdez, quelqu'un pourrait l'utiliser à vos dépends.", 
          at: [0, cursor], size: 8, width: bounds.width, leading: 2
          move_down 70
          text_box "N'achetez pas ce billet à un inconnu", at: [0, cursor], size: 8, style: :bold
          move_down 10
          text_box "Billet non-remboursable et non-échangeable.\nLes conditions générales s'appliquent.", at: [0, cursor], size: 8
        end
        move_up sub_height
        bounding_box([bounds.width/2+pad/2, cursor], width: bounds.width/2-pad/2, height: sub_height) do
          stroke_bounds if @debug
          fill_color "f19d3c"
          text_box "Instruction for use", at: [0, cursor], style: :bold_italic, size: 16
        end
        move_down 20
        draw_special_waves(0, cursor, bounds.width, 3, 0.7)
        move_down 5
        fill_color "000000"
        text_box ticket.contact, at: [0, cursor], size: 8
        move_down 14
        draw_special_waves(0, cursor, bounds.width, 3, 0.7)
      end
      # bounding_box([0, cursor], :width => bounds.width, :height => 80) do
      #   stroke_bounds if @debug
      #   image "#{Rails.root}/app/assets/images/orders/pdf/logo.jpg", width: 40, at: [0,cursor+6]
      #   text_box "Association Rencontre de Jeunesse\n 1607 Palézieux\n Suisse", at: [80, cursor], size: 8
      #   text_box "www.rencontredejeunesse.ch\ninfo@rencontredejeunesse.ch", size: 8, align: :right
      # end

      # bounding_box([0, cursor], :width => bounds.width, :height => 200) do
      #   stroke_bounds if @debug
      #   text @order.title, size: 12#, style: :bold
      #   move_down 15

      #   bounding_box([0, cursor], :width => 110, :height => 80) do
      #     stroke_bounds if @debug
      #     text_box "Date de la commande
      #       Nunéro de Client
      #       Votre personne de référence
      #       Type de livraison
      #       Option de paiement
      #       Monnaie
      #       Adresse de livraison", size: 8
      #   end

      #   move_up 80

      #   bounding_box([120, cursor], :width => 120, :height => 80) do
      #     stroke_bounds if @debug
      #     text_box "#{@order.order_date}
      #       #{@order.client_id}
      #       #{@order.reference_person}
      #       #{@order.shipping_type}
      #       #{@order.payment_type}
      #       #{@order.currency}
      #       #{@order.shipping_adress}", size: 8
      #   end

      #   move_up 100

      #   bounding_box([291, cursor], :width => 180, :height => 100) do
      #     stroke_bounds if @debug
      #     text_box @order.recipient_adress, size: 10, leading: 1, character_spacing: 0.4
      #   end

      #   delta = 3
      #   min_x = 0
      #   min_y = 30
      #   max_x = 240
      #   max_y = 95
      #   drawCorner(min_x, min_y, delta, delta)
      #   drawCorner(min_x, max_y, delta, -delta)
      #   drawCorner(max_x, min_y, -delta, delta)
      #   drawCorner(max_x, max_y, -delta, -delta)

      #   outputter.annotate_pdf(self, x: 240/2 - outputter.width/2, y: 50, height: 30)
      #   text_box "#{@order.display_order_id}", size: 9, at: [240/2 - outputter.width/2, 45], character_spacing: 1.5
      # end

      # move_down 10

      # sum = 0
      # height = 10
      # horizontal_padding = [0, 180]
      # 6.times {horizontal_padding << (bounds.width-180)/6}
      # horizontal_position = horizontal_padding.map{|x| sum += x}

      # bounding_box([horizontal_position[0], cursor], :width => horizontal_padding[1], :height => height) do
      #   stroke_bounds if @debug
      #   text_box "Description", at: [0, cursor], size: 7
      # end
      # move_up height
      # bounding_box([horizontal_position[1], cursor], :width => horizontal_padding[2], :height => height) do
      #   stroke_bounds if @debug
      #   text_box "Numéro d'article", at: [0, cursor], size: 7
      # end
      # move_up height
      # bounding_box([horizontal_position[2], cursor], :width => horizontal_padding[3], :height => height) do
      #   stroke_bounds if @debug
      #   text_box "Livraison", at: [0, cursor], size: 7
      # end
      # move_up height
      # bounding_box([horizontal_position[3], cursor], :width => horizontal_padding[4], :height => height) do
      #   stroke_bounds if @debug
      #   text_box "Quantité", at: [0, cursor], size: 7, align: :right
      # end
      # move_up height
      # bounding_box([horizontal_position[4], cursor], :width => horizontal_padding[5], :height => height) do
      #   stroke_bounds if @debug
      #   text_box "Prix", at: [0, cursor], size: 7, align: :right
      # end
      # move_up height
      # bounding_box([horizontal_position[5], cursor], :width => horizontal_padding[6], :height => height) do
      #   stroke_bounds if @debug
      #   # TVA removed
      #   text_box "", at: [0, cursor], size: 7, align: :right
      # end
      # move_up height
      # bounding_box([horizontal_position[6], cursor], :width => horizontal_padding[7], :height => height) do
      #   stroke_bounds if @debug
      #   text_box "Montant", at: [0, cursor], size: 7, align: :right
      # end

      # move_down 4

      # @order.items.each do |item|
      #   orderRow( item )
      # end

      # move_down 20

      # bounding_box([180, cursor], :width => bounds.width-180, :height => 30) do
      #   stroke_bounds if @debug
      #   step = (bounds.width)/6
      #   bounding_box([0, cursor], :width => step*4, :height => height) do
      #     stroke_bounds if @debug
      #     text_box "Montant total", at: [0, cursor], size: 8
      #   end
      #   move_up height
      #   bounding_box([step*4, cursor], :width => step, :height => height) do
      #     stroke_bounds if @debug
      #     text_box "CHF incl.", at: [0, cursor], size: 8, align: :right
      #   end
      #   move_up height
      #   bounding_box([step*5, cursor], :width => step, :height => height) do
      #     stroke_bounds if @debug
      #     text_box @order.total_items, at: [0, cursor], size: 8, align: :right
      #   end
      #   stroke_horizontal_rule
      # end

      # bounding_box([180, cursor], :width => bounds.width-180, :height => 30) do
      #   stroke_bounds if @debug
      #   step = (bounds.width)/6
      #   bounding_box([0, cursor], :width => step*4, :height => height) do
      #     stroke_bounds if @debug
      #     text_box "Paiement", at: [0, cursor], size: 8
      #   end
      #   move_down 4

      #   @order.payments.each do |payment|
      #     #paymentRow(payment)
      #   end

      #   move_down 10
      #   bounding_box([0, cursor], :width => step*4, :height => height) do
      #     stroke_bounds if @debug
      #     text_box "Montant dû", at: [0, cursor], size: 8
      #   end
      #   move_up height
      #   bounding_box([step*4, cursor], :width => step, :height => height) do
      #     stroke_bounds if @debug
      #     text_box "CHF incl.", at: [0, cursor], size: 8, align: :right
      #   end
      #   move_up height
      #   bounding_box([step*5, cursor], :width => step, :height => height) do
      #     stroke_bounds if @debug
      #     text_box @order.total, at: [0, cursor], size: 8, align: :right
      #   end
      #   stroke_horizontal_rule
      # end

      # move_down 50

      # text "Ce document sert de justificatif d'achat. Veillez à l'avoir sur vous dans le cas où vous deviez retirer un ou plusieurs produits. Les conditions générales s'appliquent. ", size: 8

      # bounding_box([0, 0], :width => 100, :height => 10) do
      #   stroke_bounds if @debug
      #   text_box "Généré le #{Time.now}", at: [0, cursor], size: 6
      # end
    end

  end

  def draw_special_line(x, y, width, size)
    stroke_color "f19d3c"
    self.line_width = 0.4
    while(x+size <= width)
      stroke_line [x,y], [x+size, y+size]
      x = x + 1.1
    end
  end

  def draw_special_waves(x, y, width, step, sharp)
    stroke do
      stroke_color "f19d3c"
      self.line_width = 0.4
      count = 0
      move_to x,y
      while(x+step <= width)
        if count % 2 == 0
          ybound = y-sharp
        else
          ybound = y+sharp
        end
        x = x+step
        curve_to [x, y], bounds: [[x-step+sharp,ybound], [x-sharp,ybound]]
        count = count+1
      end
    end
  end

  # def drawCorner(x, y, delta1, delta2)
  #   self.join_style = :round
  #   stroke do
  #     move_to(x+delta1, y)
  #     line_to(x, y)
  #     line_to(x, y+delta2)
  #   end
  # end

  # def paymentRow payment
  #   step = (bounds.width)/6
  #   height = 10
  #   bounding_box([0, cursor], :width => step*2, :height => height) do
  #     stroke_bounds if @debug
  #     text_box payment.time, at: [0, cursor], size: 8
  #   end
  #   move_up height
  #   bounding_box([step*2, cursor], :width => step*3, :height => height) do
  #     stroke_bounds if @debug
  #     text_box payment.payment_type, at: [0, cursor], size: 8, align: :right
  #   end
  #   move_up height
  #   bounding_box([step*5, cursor], :width => step, :height => height) do
  #     stroke_bounds if @debug
  #     text_box payment.display_amount, at: [0, cursor], size: 8, align: :right
  #   end
  # end

  # def orderRow item
  #   sum = 0
  #   height = 10
  #   horizontal_padding = [0, 180]
  #   6.times {horizontal_padding << (bounds.width-180)/6}
  #   horizontal_position = horizontal_padding.map{|x| sum += x}

  #   stroke_horizontal_rule
  #   move_down 4

  #   bounding_box([horizontal_position[0], cursor], :width => horizontal_padding[1], :height => height) do
  #     stroke_bounds if @debug
  #     text_box item.name, at: [0, cursor], size: 8
  #   end
  #   move_up height
  #   bounding_box([horizontal_position[1], cursor], :width => horizontal_padding[2], :height => height) do
  #     stroke_bounds if @debug
  #     text_box item.number, at: [0, cursor], size: 8
  #   end
  #   move_up height
  #   bounding_box([horizontal_position[2], cursor], :width => horizontal_padding[3], :height => height) do
  #     stroke_bounds if @debug
  #     text_box item.shipping_date, at: [0, cursor], size: 8
  #   end
  #   move_up height
  #   bounding_box([horizontal_position[3], cursor], :width => horizontal_padding[4], :height => height) do
  #     stroke_bounds if @debug
  #     text_box item.quantity, at: [0, cursor], size: 8, align: :right
  #   end
  #   move_up height
  #   bounding_box([horizontal_position[4], cursor], :width => horizontal_padding[5], :height => height) do
  #     stroke_bounds if @debug
  #     text_box item.price.to_s, at: [0, cursor], size: 8, align: :right
  #   end
  #   move_up height
  #   bounding_box([horizontal_position[5], cursor], :width => horizontal_padding[6], :height => height) do
  #     stroke_bounds if @debug
  #     # item.tva
  #     text_box "", at: [0, cursor], size: 8, align: :right
  #   end
  #   move_up height
  #   bounding_box([horizontal_position[6], cursor], :width => horizontal_padding[7], :height => height) do
  #     stroke_bounds if @debug
  #     text_box item.display_price, at: [0, cursor], size: 8, align: :right
  #   end

  #   move_down 10
  # end

end
