class BadgePdf < Prawn::Document
  require "prawn/measurement_extensions"

  def initialize(data, sectors, zones)
    @sectors = sectors
    @zones = zones
    # When printing in double-sided mode, odd pages have right margin 
    # of 12mm and left margin of 10mm
    #
    # First page:
    #  12mm      10mm
    #  +------------+15mm
    #  +------------+
    #  | |        | |
    #  +------------+15mm
    #
    # Second page:
    #  10mm      12mm
    #  +------------+15mm
    #  +------------+
    #  | |        | |
    #  +------------+15mm
    #  +------------+


    even_margin = [15.mm,10.mm,15.mm,12.mm] # top, right, bottom, left
    odd_margin = [15.mm,12.mm,15.mm,10.mm]
    super(page_size: "A4", :margin => even_margin, page_layout: :landscape)
    @debug = true

    self.font_families.update("omnes" =>  {
      :italic => Rails.root.join("app/assets/fonts/pdf/omnes-medium-italic.ttf"),
      :normal => Rails.root.join("app/assets/fonts/pdf/omnes-regular.ttf"),
      :bold_italic => Rails.root.join("app/assets/fonts/pdf/omnes-bold-italic.ttf"),
      :bold => Rails.root.join("app/assets/fonts/pdf/omnes-semibold.ttf"),
    })
    font "omnes"
    fill_color "ffffff"

    # stroke_axis
    # draw_horizontal_layout(true)
    # draw_horizontal_guides(true)
    # bounding_box([0, 85.mm*2+10.mm], :width => 55.mm, :height => 85.mm) do
    #     stroke_bounds
    # end

    data.sort!{ |a,b| "#{a[:sec_id]}#{a[:firstname]}#{a[:lastname]}" <=> "#{b[:sec_id]}#{b[:firstname]}#{b[:lastname]}" }
    i = 0
    first_time = true
    while i < data.size
      if first_time
        first_time = false
      else
        start_new_page(margin: even_margin)
      end
      draw_horizontal_guides(true)
      draw_page(data[i...i+10], false)
      start_new_page(margin: odd_margin)
      draw_horizontal_guides(false)
      draw_page(data[i...i+10], true)
      i = i+10
    end
  end

  # data has the following struct:
  # data [
  #   el {
  #     firstname: string,
  #     lastname: string,
  #     sec_id: number
  #   },
  #   ...
  # ]
  # with maximum 10 elements
  # with cursor at the bottom left
  def draw_page(data, row_reverse)
    row_reverse ? draw_back_page(data) : draw_front_page(data)
  end

  def draw_front_page(data)
    canvas do
      text_box "#{page_number}", :at => [bounds.left+3.mm, bounds.top-3.mm], size: 8
    end

    data.each.with_index do |el, i|
      col = i%5
      row = i/5
      bounding_box([col*55.mm, 85.mm*2+10.mm - row*(85.mm+10.mm)], :width => 55.mm, :height => 85.mm) do

        image "#{Rails.root}/app/assets/images/pdf/badges/2024/background2.jpg", width: 55.mm, height: 95.mm, at: [0.mm, 90.mm]
        image "#{Rails.root}/app/assets/images/pdf/badges/2024/logo.png", height: 25, at: [38.mm, 83.mm]
        image "#{Rails.root}/app/assets/images/pdf/badges/2024/slogan.png", width: 22.mm, at: [17.mm, 80.mm]

        fill_color "ffffff"

        bounding_box(
          [0.mm, 44.mm], 
          :width => 55.mm,
          valign: :center
        ) do
          text "#{el[:firstname]} #{el[:lastname]}", 
            align: :center,
            size: 11,
            overflow: :shrink_to_fit

          bounding_box(
            [2.5.mm, 0],
            width: 50.mm,
            height: 10.mm
          ) do
            text @sectors[el[:sec_id]][:name], 
              size: 16, 
              style: :bold,
              align: :center,
              overflow: :shrink_to_fit
          end
        end

        num_zone = @sectors[el[:sec_id]][:zones].size
        from_bottom = 10.mm
        margin = -4.mm
        growth_factor = 1 + (7-num_zone)**1.3*0.1
        shape_w = 5.mm * growth_factor
        shape_h = 17.mm
        shapes_width = num_zone * shape_w*2 + (num_zone-1) * margin
        position_from_left = (55.mm - shapes_width) / 2
        angle = -Math.atan(shape_h / shape_w) * 180 / Math::PI

        @sectors[el[:sec_id]][:zones].each.with_index do |zone_id, i|
          local_position_from_left = position_from_left + i*(shape_w*2 + margin)
          fill_color @zones[@sectors[el[:sec_id]][:zones][i]][:color]
          stroke_color "ffffff"
          self.line_width = 0.2.mm
          fill_and_stroke_polygon [local_position_from_left, from_bottom], 
                       [local_position_from_left+shape_w, from_bottom], 
                       [local_position_from_left+shape_w*2, from_bottom + shape_h], 
                       [local_position_from_left+shape_w, from_bottom + shape_h], 
                       [local_position_from_left, from_bottom]
          fill_color "000000"
          text_box @zones[@sectors[el[:sec_id]][:zones][i]][:abb].upcase, 
                    at: [local_position_from_left+shape_w/2, from_bottom-1.mm],
                    rotate: angle, size: 8, style: :bold, rotate_around: :upper_left
        end
      end
    end
  end

  def draw_back_page(data)
    canvas do
      a = "- copie inversée horizontalement, reliure côté court"
      text_box "#{page_number} #{a}" , :at => [bounds.left+3.mm, bounds.top-3.mm], size: 8
    end

    border = BorderCallback.new(radius: 0.5.mm, document: self)
    arrow = ArrowCallback.new(self)

    data.each.with_index do |el, i|
      col = i%5
      row = i/5
      col = 4 - col # adjust for odd page
      bounding_box([col*55.mm, 85.mm*2+10.mm - row*(85.mm+10.mm)], :width => 55.mm, :height => 85.mm) do

        image "#{Rails.root}/app/assets/images/pdf/badges/2024/background2.jpg", width: 55.mm, height: 95.mm, at: [0.mm, 90.mm]
        # image "#{Rails.root}/app/assets/images/pdf/badges/2024/logo.png", height: 25, at: [38.mm, 83.mm]
        
        bounding_box(
          [3.mm, 82.mm],
          width: 50.mm,
          valign: :top,
        ) do
          font_size 8
          fill_color "ffffff"
          text "Zones d'accès:", style: :bold
          move_down 2.mm
          @zones.each do |zone|
            bounding_box(
              [3.mm, 0.mm],
              # valign: :center,
              # align: :center,
              # height: 4.mm,
              width: 50.mm
            ) do
              formatted_text [
                {text: "#{zone[:human_color]}", callback: border},
                {text: '         '},
                {text: "#{zone[:name]} (#{zone[:abb]})", callback: arrow},
              ]
            end
            move_down 1.mm
          end
          move_down 2.mm
          text "Link tree Team24:", style: :bold
          move_down 1.mm
          bounding_box(
            [0.mm, 0.mm],
            width: 30.mm
          ) do
            text "stage timer à fermer après chaque consultation"
          end
          image "#{Rails.root}/app/assets/images/pdf/badges/2024/linktree.png", height: 42, at: [30.mm, 15.mm]
        end

        num_zone = @sectors[el[:sec_id]][:zones].size
        from_bottom = 10.mm
        margin = -4.mm
        growth_factor = 1 + (7-num_zone)**1.3*0.1
        shape_w = 5.mm * growth_factor
        shape_h = 17.mm
        shapes_width = num_zone * shape_w*2 + (num_zone-1) * margin
        position_from_left = (55.mm - shapes_width) / 2
        angle = -Math.atan(shape_h / shape_w) * 180 / Math::PI

        @sectors[el[:sec_id]][:zones].each.with_index do |zone_id, i|
          local_position_from_left = position_from_left + i*(shape_w*2 + margin)
          fill_color @zones[@sectors[el[:sec_id]][:zones][i]][:color]
          stroke_color "ffffff"
          self.line_width = 0.2.mm
          fill_and_stroke_polygon [local_position_from_left, from_bottom], 
                       [local_position_from_left+shape_w, from_bottom], 
                       [local_position_from_left+shape_w*2, from_bottom + shape_h], 
                       [local_position_from_left+shape_w, from_bottom + shape_h], 
                       [local_position_from_left, from_bottom]
          fill_color "000000"
          text_box @zones[@sectors[el[:sec_id]][:zones][i]][:abb].upcase, 
                    at: [local_position_from_left+shape_w/2, from_bottom-1.mm],
                    rotate: angle, size: 8, style: :bold, rotate_around: :upper_left
        end
      end
    end
  end

  # This method uses absolute positions to draw a layout with
  # a landscape orientation.
  def draw_horizontal_layout(even)
    left_margin = even ? 12.mm : 10.mm
    canvas do
      dash([1])

      # horizontal lines
      stroke_line [bounds.left, bounds.top-15.mm], [bounds.right, bounds.top-15.mm]
      stroke_line [bounds.left, bounds.top-15.mm-85.mm], [bounds.right, bounds.top-15.mm-85.mm]
      stroke_line [bounds.left, bounds.top-15.mm-85.mm-10.mm], [bounds.right, bounds.top-15.mm-85.mm-10.mm]
      stroke_line [bounds.left, bounds.top-15.mm-85.mm-10.mm-85.mm], [bounds.right, bounds.top-15.mm-85.mm-10.mm-85.mm]
    
      # vertical lines
      6.times do |i|
        x = bounds.left+left_margin+55.mm*i
        stroke_line [x, bounds.top], [x, bounds.bottom]
      end
      undash
    end
  end

  def draw_horizontal_guides(even)
    left_margin = even ? 12.mm : 10.mm
    stroke_color "000000"
    canvas do
      dash([1])
      # vertical lines
      6.times do |i|
        x = left_margin + i*55.mm
        stroke_line [x, bounds.top], [x, bounds.top-3.mm]
      end
      6.times do |i|
        x = left_margin + i*55.mm
        base_y = bounds.top - 15.mm - 85.mm - 6.mm
        stroke_line [x, base_y], [x, base_y+2.mm]
      end
      6.times do |i|
        x = left_margin + i*55.mm
        stroke_line [x, bounds.bottom], [x, bounds.bottom+3.mm]
      end
      # horizonal lines
      [15.mm, 15.mm+85.mm, 15.mm+85.mm+10.mm, 15.mm+85.mm*2+10.mm].each do |from_y|
        stroke_line [bounds.left, bounds.top-from_y], [bounds.left+3.mm, bounds.top-from_y]
        stroke_line [bounds.right, bounds.top-from_y], [bounds.right-3.mm, bounds.top-from_y]
      end
      undash
    end
  end

  def draw_special_line(x, y, width, size)
    canvas do
      stroke_color "eeeeee"
      self.line_width = 0.4
      while(x+size <= width)
        stroke_line [x,y], [x+size, y+size]
        x = x + 1.mm
      end
    end
  end

end

class BorderCallback
  def initialize(options)
    @radius, @document = options.values_at(:radius, :document)
  end
  def render_in_front(fragment)
    @document.fill_circle([fragment.top_left[0]/2-2.mm, fragment.bottom_left[1]+(fragment.height/2)+0.3.mm] , @radius)
  end
end

class ArrowCallback
  def initialize(document)
    @document = document
  end
  def render_in_front(fragment)
    @document.join_style = :round
    @document.stroke do
      start_x = fragment.bottom_left[0]-3.mm
      middle_y = fragment.bottom_left[1]+fragment.height/2+0.1.mm
      arrow_height = 0.6.mm
      @document.move_to(start_x,middle_y)
      @document.line_to(start_x + 1.8.mm, middle_y)

      @document.move_to(start_x + 1.mm, middle_y+arrow_height)
      @document.line_to(start_x + 2.mm, middle_y)
      @document.line_to(start_x + 1.mm, middle_y-arrow_height)
    end
  end
end