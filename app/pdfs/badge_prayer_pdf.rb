class BadgePrayerPdf < Prawn::Document
  require "prawn/measurement_extensions"

  def initialize()
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

    # stroke_axis
    # draw_horizontal_layout(true)
    # bounding_box([0, 85.mm*2+10.mm], :width => 55.mm, :height => 85.mm) do
    #     stroke_bounds
    # end
    
    draw_page(false)
    draw_horizontal_guides(true)
    start_new_page(margin: odd_margin)
    draw_horizontal_guides(false)
    draw_page(true)

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
  def draw_page(row_reverse)
    canvas do
      a = row_reverse ? "- copie inversée horizontalement, reliure côté court" : ""
      text_box "#{page_number} #{a}" , :at => [bounds.left+3.mm, bounds.top-3.mm], size: 8
    end

    canvas do
      fill_color "ffff77"
      fill_polygon [bounds.left, bounds.top - 7.mm],
                   [bounds.right, bounds.top - 7.mm],
                   [bounds.right, bounds.bottom + 7.mm],
                   [bounds.left, bounds.bottom + 7.mm]
      fill_color "000000"
    end

    10.times do |i|
      col = i%5
      row = i/5
      bounding_box([col*55.mm, 85.mm*2+10.mm - row*(85.mm+10.mm)], :width => 55.mm, :height => 85.mm) do

        image "#{Rails.root}/app/assets/images/pdf/badges/2019/logo.png", height: 45, at: [35.mm, 80.mm]
        image "#{Rails.root}/app/assets/images/pdf/badges/2019/logo_changemoi_noir.png", width: 60, at: [4.mm, 70.mm]

        text_box "2019", :at => [5.mm, 76.mm],
                                     :width => 55.mm,
                                     :align => :left,
                                     size: 18, style: :bold

        text_box "Équipiers\nde prière", :at => [2.5.mm, 44.mm],
                                     :width => 50.mm,
                                     :align => :center  ,
                                     size: 20, style: :bold
      end
    end

    draw_special_line(0, 44.mm, 300.mm, 1.mm)
    draw_special_line(0, 74.mm, 300.mm, 1.mm)

    draw_special_line(0, 44.mm + 95.mm, 300.mm, 1.mm)
    draw_special_line(0, 74.mm + 95.mm, 300.mm, 1.mm)
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
      stroke_color "ffffff"
      self.line_width = 0.4
      while(x+size <= width)
        stroke_line [x,y], [x+size, y+size]
        x = x + 1.mm
      end
    end
  end

end
