class BadgePdf < Prawn::Document
  require "prawn/measurement_extensions"

  def initialize(data, sectors, zones)
    @sectors = sectors
    @zones = zones

    @badge_width = 98.mm
    @badge_height = 138.mm

    @num_cols = 2
    @num_rows = 2

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


    even_margin = [11.mm, 7.mm, 10.mm, 7.mm] # top, right, bottom, left
    odd_margin = [11.mm, 7.mm, 10.mm, 7.mm]
    super(page_size: "A4", :margin => even_margin, page_layout: :portrait)
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
      draw_page(data[i...i+4], false)
      start_new_page(margin: odd_margin)
      draw_horizontal_guides(false)
      draw_page(data[i...i+4], true)
      i = i+4
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
      col = i%2
      row = i/2

      x = col*@badge_width
      y = (@num_rows-row)*@badge_height

      bg_x = col == 0 ? x - 5.mm : x
      bg_y = row == 0 ? y + 5.mm : y

      # positionned from top left
      image "#{Rails.root}/app/assets/images/pdf/badges/2024/background3.jpg", width: 103.mm, height: 143.mm, at: [bg_x, bg_y]

      # bounding box is positioned top left
      bounding_box([x, y], :width => @badge_width, :height => @badge_height) do

        image "#{Rails.root}/app/assets/images/pdf/badges/2024/logo.png", height: 40, at: [70.mm, 130.mm]
        image "#{Rails.root}/app/assets/images/pdf/badges/2024/slogan.png", width: 34.mm, at: [(98.mm-34.mm)/2, 115.mm]

        fill_color "ffffff"

        bounding_box(
          [0.mm, 57.mm], 
          :width => @badge_width,
          valign: :center
        ) do
          text "#{el[:firstname]} #{el[:lastname]}", 
            align: :center,
            size: 12,
            overflow: :shrink_to_fit

          move_down 2.mm
          bounding_box(
            [2.5.mm, 0],
            width: @badge_width-5.mm,
            height: 15.mm
          ) do
            text @sectors[el[:sec_id]][:name], 
              size: 18, 
              style: :bold,
              align: :center,
              overflow: :shrink_to_fit
          end
        end

        num_zone = @sectors[el[:sec_id]][:zones].size
        from_bottom = 15.mm
        margin = -4.mm
        growth_factor = 1 + (7-num_zone)**1.3*0.1
        shape_w = 7.2.mm * growth_factor
        shape_h = 23.mm
        shapes_width = num_zone * shape_w*2 + (num_zone-1) * margin
        position_from_left = (@badge_width - shapes_width) / 2
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

          if @zones[@sectors[el[:sec_id]][:zones][i]][:abb].upcase == "ALL"
            # draw_star(@badge_width/2 + 7.mm, 18.mm)
            draw_grade(@badge_width/2+0.mm, 27.mm)
          end
        end
      end
    end
  end

  def draw_grade(x_origin, y_origin)
    stroke do
      self.line_width = 0.8.mm
      self.cap_style = :round
      stroke_color "ffffff"
      move_to(x_origin - 4.8.mm, y_origin)
      line_to(x_origin + 5.2.mm, y_origin)
    end
  end

  def draw_star(x_origin, y_origin)
    r = 3.mm

    coords = []
    (0..5).each do |n|
      x = r*Math.cos(to_rad(90+n*72)) + x_origin
      y = r*Math.sin(to_rad(90+n*72)) + y_origin
      coords.push([x,y])
    end
    penta = [coords[0], coords[2], coords[4], coords[1], coords[3]]

    join_style = :round
    cap_style = :round
    fill_color "ffffff"
    fill_rounded_polygon(1.mm, *penta.map { |x, y| [x, y] })

    # join_style = :round

    # stroke do
    #   move_to(coords[0][0], coords[0][1])
    #   line_to(coords[2][0], coords[2][1])
    #   line_to(coords[4][0], coords[4][1])
    #   line_to(coords[1][0], coords[1][1])
    #   line_to(coords[3][0], coords[3][1])
    #   line_to(coords[0][0], coords[0][1])
    # end
  end

  def to_rad angle
    angle / 180.0 * Math::PI
  end

  def draw_back_page(data)
    canvas do
      fill_color "333333"
      a = "- copie inversée horizontalement, reliure côté court"
      text_box "#{page_number} #{a}" , :at => [bounds.left+3.mm, bounds.top-3.mm], size: 8
    end

    border = BorderCallback.new(radius: 0.5.mm, document: self)
    arrow = ArrowCallback.new(self)

    data.each.with_index do |el, i|
      col = i%2
      row = i/2

      x = (@num_cols-1-col)*@badge_width
      y = (@num_rows-row)*@badge_height

      bg_x = @num_cols-1-col == 0 ? x - 5.mm : x
      bg_y = row == 0 ? y + 5.mm : y

      # positionned from top left
      image "#{Rails.root}/app/assets/images/pdf/badges/2024/background3.jpg", width: 103.mm, height: 143.mm, at: [bg_x, bg_y]

      # bounding box is positioned top left
      bounding_box([x, y], :width => @badge_width, :height => @badge_height) do

        image "#{Rails.root}/app/assets/images/pdf/badges/2024/logo.png", height: 40, at: [70.mm, 130.mm]
        stroke_color "ffffff"
        
        bounding_box(
          [6.mm, 122.mm],
          width: 50.mm,
          valign: :top,
        ) do
          font_size 11
          fill_color "ffffff"
          text "Zones d'accès:", style: :bold
          move_down 2.mm
          @zones.each do |zone|
            bounding_box(
              [3.mm, 0.mm],
              # valign: :center,
              # align: :center,
              # height: 4.mm,
              width: 90.mm
            ) do
              formatted_text [
                {text: "#{zone[:human_color]}", callback: border},
                {text: '         '},
                {text: "#{zone[:name]} (#{zone[:abb]})", callback: arrow},
              ]
            end
            move_down 1.mm
          end
          move_down 6.mm
          text "Link tree Team24:", style: :bold
          move_down 1.mm
          bounding_box(
            [0.mm, 0.mm],
            width: 40.mm
          ) do
            text "stage timer à fermer après chaque consultation"
          end
          image "#{Rails.root}/app/assets/images/pdf/badges/2024/linktree.png", height: 60, at: [50.mm, 19.mm]
        end

        num_zone = @sectors[el[:sec_id]][:zones].size
        from_bottom = 15.mm
        margin = -4.mm
        growth_factor = 1 + (7-num_zone)**1.3*0.1
        shape_w = 7.2.mm * growth_factor
        shape_h = 23.mm
        shapes_width = num_zone * shape_w*2 + (num_zone-1) * margin
        position_from_left = (@badge_width - shapes_width) / 2
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

          if @zones[@sectors[el[:sec_id]][:zones][i]][:abb].upcase == "ALL"
            # draw_star(@badge_width/2 + 7.mm, 18.mm)
            draw_grade(@badge_width/2+0.mm, 27.mm)
          end
        end
      end
    end
  end

  def draw_horizontal_guides(even)

    stroke_color "000000"
    self.line_width = 0.1
    
    canvas do
      dash([1])
      # vertical lines
      3.times do |i|
        x = 7.mm + i*@badge_width
        stroke_line [x, bounds.top], [x, bounds.top-3.mm]
      end
      3.times do |i|
        x = 7.mm + i*@badge_width
        stroke_line [x, bounds.bottom], [x, bounds.bottom+3.mm]
      end
      # horizonal lines
      3.times do |i|
        y = bounds.top - 10.mm - i*@badge_height
        stroke_line [bounds.left, y], [bounds.left+3.mm, y]
        stroke_line [bounds.right, y], [bounds.right-3.mm, y]
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
    @document.line_width = 1
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