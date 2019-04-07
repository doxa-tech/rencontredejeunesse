class BadgePdf < Prawn::Document
  require "prawn/measurement_extensions"

  def initialize()
    super(page_size: "A4", :margin => [15.mm,12.mm,15.mm,10.mm], page_layout: :landscape)
    @debug = true

    self.font_families.update("omnes" =>  {
      :italic => Rails.root.join("app/assets/fonts/pdf/omnes-medium-italic.ttf"),
      :normal => Rails.root.join("app/assets/fonts/pdf/omnes-regular.ttf"),
      :bold_italic => Rails.root.join("app/assets/fonts/pdf/omnes-bold-italic.ttf"),
      :bold => Rails.root.join("app/assets/fonts/pdf/omnes-semibold.ttf"),
    })
    font "omnes"

    @sectors = [
      {name: "Audio Recording", zones: [0,2,3]}, 
      {name: "Badges & Bons", zones: [1,5]}, 
      {name: "Staff Espace Gruyère", zones: [0,1,5,6]},
      {name: "Lumière & Ambiance Halle50", zones: [0,1,2,3,4,5,6]}
    ]
    @zones = [
      {name: "Village & Fun Park", color: "00FF00"},
      {name: "Plénière & Backstage", color: "0000FF"},
      {name: "Régies", color: "7F00FF"},
      {name: "Espace Lounge", color: "FF0000"},
      {name: "Caisse", color: "5B3C11"},
      {name: "Espace médias",color: "C0C0C0"},
      {name: "Dortoirs", color: "FFA500"}
    ]

    # stroke_axis
    # draw_horizontal_layout()
    # bounding_box([0, 85.mm*2+10.mm], :width => 55.mm, :height => 85.mm) do
    #     stroke_bounds
    # end
    data = [
      {
        firstname: "Noémien",
        lastname: "Kocher",
        sec_id: 1
      },
      {
        firstname: "David",
        lastname: "Dupont",
        sec_id: 0
      },
      {
        firstname: "François",
        lastname: "Delabatte",
        sec_id: 2
      },
      {
        firstname: "Baptiste",
        lastname: "Baumann",
        sec_id: 3
      },
      {
        firstname: "Sévin",
        lastname: "Kocher",
        sec_id: 1
      },
      {
        firstname: "Chainy",
        lastname: "Sudan",
        sec_id: 2
      },
      {
        firstname: "Sandrine",
        lastname: "Meyer",
        sec_id: 3
      },
      {
        firstname: "Dupont",
        lastname: "Chat",
        sec_id: 0
      },
      {
        firstname: "Bonnet",
        lastname: "Chaise",
        sec_id: 2
      },
      {
        firstname: "Tabouret",
        lastname: "Voiture",
        sec_id: 3
      },
      {
        firstname: "Table",
        lastname: "Tiroire",
        sec_id: 1
      },
      {
        firstname: "Soleil",
        lastname: "Chevet",
        sec_id: 0
      }
    ]
    i = 0
    while i < data.size
      draw_page(data[i...i+10], false)
      start_new_page
      draw_page(data[i...i+10], true)
      i = i+10
      start_new_page
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
    canvas do
      a = row_reverse ? "- copie inversée horizontalement, reliure côté court" : ""
      text_box "#{page_number} #{a}" , :at => [bounds.left+3.mm, bounds.top-3.mm], size: 8
    end

    data.each.with_index do |el, i|
      col = i%5
      row = i/5
      col = 4 - col if row_reverse
      bounding_box([col*55.mm, 85.mm*2+10.mm - row*(85.mm+10.mm)], :width => 55.mm, :height => 85.mm) do

        image "#{Rails.root}/app/assets/images/pdf/badges/logo.png", height: 50, at: [40.mm, 80.mm]
        image "#{Rails.root}/app/assets/images/pdf/badges/logo_changemoi_noir.png", width: 60, at: [4.mm, 70.mm]

        text_box "2019", :at => [5.mm, 76.mm],
                                     :width => 55.mm,
                                     :align => :left,
                                     size: 18, style: :bold

        text_box el[:firstname], :at => [0, 55.mm],
                                     :width => 55.mm,
                                     :align => :center,
                                     size: 11

        text_box el[:lastname], :at => [0, 50.mm],
                                     :width => 55.mm,
                                     :align => :center,
                                     size: 11

        text_box @sectors[el[:sec_id]][:name], :at => [2.5.mm, 44.mm],
                                     :width => 50.mm,
                                     :align => :center  ,
                                     size: 16, style: :bold
        
        # Uses rounds. This is a variant that we found less
        # good.
        #
        # radius = 6.mm
        # margin = 0.5.mm
        # if num_zone < 4
        #   circles_width = num_zone*radius*2 + (num_zone - 1)*margin
        #   circles_from_left = (55.mm-circles_width)/2 + radius
        #   @sectors[el[:sec_id]][:zones].each.with_index do |zone_id, i|
        #     fill_color @zones[zone_id][:color]
        #     fill_circle [circles_from_left + i*(radius*2+margin), 24.mm], radius
        #   end
        # else
        #   num_first_row = (num_zone-1)/2 + 1
        #   num_second_row = num_zone - num_first_row
          
        #   circles_width = num_first_row*radius*2 + (num_first_row - 1)*margin
        #   circles_from_left = (55.mm-circles_width)/2 + radius

        #   num_first_row.times do |i|
        #     fill_color @zones[@sectors[el[:sec_id]][:zones][i]][:color]
        #     fill_circle [circles_from_left + i*(radius*2+margin), 24.mm], radius
        #   end

        #   circles_width = num_second_row*radius*2 + (num_second_row - 1)*margin
        #   circles_from_left = (55.mm-circles_width)/2 + radius
        #   num_second_row.times do |i|
        #     fill_color @zones[@sectors[el[:sec_id]][:zones][i+num_first_row]][:color]
        #     fill_circle [circles_from_left + i*(radius*2+margin), 11.7.mm], radius
        #   end
        # end

        num_zone = @sectors[el[:sec_id]][:zones].size
        from_bottom = 5.mm
        margin = -4.mm
        growth_factor = 1 + (7-num_zone)**1.3*0.1
        shape_w = 5.mm * growth_factor
        shapes_width = num_zone * shape_w*2 + (num_zone-1) * margin
        position_from_left = (55.mm - shapes_width) / 2

        @sectors[el[:sec_id]][:zones].each.with_index do |zone_id, i|
          local_position_from_left = position_from_left + i*(shape_w*2 + margin)
          fill_color @zones[@sectors[el[:sec_id]][:zones][i]][:color]
          fill_polygon [local_position_from_left, from_bottom], 
                       [local_position_from_left+shape_w, from_bottom], 
                       [local_position_from_left+shape_w*2, from_bottom + 20.mm], 
                       [local_position_from_left+shape_w, from_bottom + 20.mm], 
                       [local_position_from_left, from_bottom]
        end
        fill_color "000000"
      end
    end

    draw_special_line(0, 44.mm, 300.mm, 1.mm)
    draw_special_line(0, 74.mm, 300.mm, 1.mm)

    draw_special_line(0, 44.mm + 95.mm, 300.mm, 1.mm)
    draw_special_line(0, 74.mm + 95.mm, 300.mm, 1.mm)
  end

  # This method uses absolute positions to draw a layout with
  # a landscape orientation.
  def draw_horizontal_layout
    canvas do
      dash([1])

      # horizontal lines
      stroke_line [bounds.left, bounds.top-15.mm], [bounds.right, bounds.top-15.mm]
      stroke_line [bounds.left, bounds.top-15.mm-85.mm], [bounds.right, bounds.top-15.mm-85.mm]
      stroke_line [bounds.left, bounds.top-15.mm-85.mm-10.mm], [bounds.right, bounds.top-15.mm-85.mm-10.mm]
      stroke_line [bounds.left, bounds.top-15.mm-85.mm-10.mm-85.mm], [bounds.right, bounds.top-15.mm-85.mm-10.mm-85.mm]
    
      # vertical lines
      6.times do |i|
        x = bounds.left+10.mm+55.mm*i
        stroke_line [x, bounds.top], [x, bounds.bottom]
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

  # get an array of maximum 10 items and reverses it
  # by chuncks of 5.
  def row_inverse(data)
    a = data[0...5]
    b = data[5...10]
    if(a.nil?)
      a = []
    end
    if(b.nil?)
      b = []
    end
    a.reverse() + b.reverse()
  end

end
