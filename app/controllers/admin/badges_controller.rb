require 'csv'

class Admin::BadgesController < Admin::BaseController

  def index
    @sectors = SECTORS
    @zones = ZONES
  end

  def create
    file = params[:file]
    items_not_found = []
    data = []
    if file
      CSV.foreach(file.path, headers: true, col_sep: ";").with_index(1) do |row, i|
        found = SECTORS.select { |e| e[:name] == row["Secteur"] }
        if found.size < 1
          items_not_found.push("#{row['Secteur']} (ligne #{i})")
        else
          data.push({sec_id: found[0][:id], firstname: row['Prénom'], lastname: row['Nom']})
        end
      end
    end
    if !file
      redirect_to admin_badges_path, error: "Erreur dans l'ouverture du fichier."
    elsif items_not_found.size > 0
      redirect_to admin_badges_path, error: "Nous n'avons pas trouvé ce/ces secteurs:\n#{items_not_found}"   
    else
      # At this stage, we assume everything went good.
      pdf = BadgePdf.new(data, SECTORS, ZONES)
      send_data pdf.render, filename: "Badges.pdf", type: "application/pdf", disposition: 'inline'
    end
  end

  def dev
    data = SECTORS.map{ |sec|  {sec_id: sec[:id], firstname: "John", lastname: "Doe"}}
    pdf = BadgePdf.new(data, SECTORS, ZONES)
    send_data pdf.render, filename: "Badges.pdf", type: "application/pdf", disposition: 'inline'
  end

  def volunteer
    respond_to do |format|
      format.pdf do
        pdf = BadgeVolunteerPdf.new()
        send_data pdf.render, filename: "Badges_volunteer.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  def prayer
    respond_to do |format|
      format.pdf do
        pdf = BadgePrayerPdf.new()
        send_data pdf.render, filename: "Badges_Prayer.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  ZONES = [
    {name: "All Access", color: "f70000", abb: "all", human_color: "Rouge"},
    {name: "Village & Fun Park", color: "138c01", abb: "vil", human_color: "Vert"},
    {name: "Grande Scène & Backstage", color: "0c00fc", abb: "sce", human_color: "Bleu"},
    {name: "Espace bénévoles", color: "fc8f00", abb: "ben", human_color: "Orange"},
    {name: "Loge intervenants principaux", color: "da00fc", abb: "log", human_color: "Violet"},
    {name: "Billeterie", color: "8c0801", abb: "bil", human_color: "Bordeau"},
    {name: "Espace médias", color: "fc009f", abb: "med", human_color: "Rose"},
    {name: "Staff Chalet", color: "969696", abb: "cha", human_color: "Gris"},
  ]

  SECTORS = [
    {name: "Team Intercession", zones: [3], id: 0},
    {name: "Adjoint Coord Générale", zones: [0], id: 1},
    {name: "Ami de la RJ", zones: [3], id: 2},
    {name: "Amie de la RJ", zones: [3], id: 3},
    {name: "Billetterie", zones: [5], id: 4},
    {name: "Coord Planning & Horaires", zones: [0], id: 5},
    {name: "COPIL", zones: [0], id: 6},
    {name: "COPIL - Ateliers", zones: [0], id: 7},
    {name: "COPIL - Communication", zones: [0], id: 8},
    {name: "COPIL - Coord Générale", zones: [0], id: 9},
    {name: "COPIL - Directeur", zones: [0], id: 10},
    {name: "COPIL - Plénière", zones: [0], id: 11},
    {name: "COPIL - Technique", zones: [0], id: 12},
    {name: "Cusinier Team Bénévoles", zones: [3,7], id: 13},
    {name: "Intervenant Ateliers", zones: [1,2,3], id: 14},
    {name: "Intervenant Principal", zones: [1,2,3,4], id: 15},
    {name: "Intervenante Ateliers", zones: [1,2,3], id: 16},
    {name: "Intervenante Principale", zones: [1,2,3,4], id: 17},
    {name: "Invité RJ", zones: [3], id: 18},
    {name: "Invitée RJ", zones: [3], id: 19},
    {name: "MC Plénières", zones: [1,2,3], id: 20},
    {name: "MC Scène Des Artistes", zones: [1,3], id: 21},
    {name: "Networking", zones: [3], id: 22},
    {name: "PA Ateliers", zones: [1,2,3], id: 23},
    {name: "PA COPIL", zones: [0], id: 24},
    {name: "PA Intervenants", zones: [1,2,3,4], id: 25},
    {name: "Partenaire RJ", zones: [3], id: 26},
    {name: "Présidence Ateliers", zones: [1,2,3], id: 27},
    {name: "Présidence Plénières", zones: [2,3,4], id: 28},
    {name: "Resp Billetterie", zones: [3,5], id: 29},
    {name: "Resp Chalet Staff", zones: [3,7], id: 30},
    {name: "Resp Cuisine Bénévoles", zones: [3,7], id: 31},
    {name: "Resp Domaine Accueil", zones: [0], id: 32},
    {name: "Resp Domaine Bénévoles", zones: [0], id: 33},
    {name: "Resp Domaine Comm", zones: [0], id: 34},
    {name: "Resp Domaine Intercession", zones: [0], id: 35},
    {name: "Resp Domaine Logistique", zones: [0], id: 36},
    {name: "Resp Domaine Technique", zones: [0], id: 37},
    {name: "Resp Domaine Village", zones: [0], id: 38},
    {name: "Resp Dortoirs Filles", zones: [2,3], id: 39},
    {name: "Resp Equipiers De Prière", zones: [2,3], id: 40},
    {name: "Resp Espace Bénévoles", zones: [3,4], id: 41},
    {name: "Resp Espace Prière", zones: [3], id: 42},
    {name: "Resp Espace Prophétique", zones: [3], id: 43},
    {name: "Resp Graphisme RJ", zones: [1,2,3,6,7], id: 44},
    {name: "Resp Invités RJ", zones: [2,3], id: 45},
    {name: "Resp Logistique", zones: [0], id: 46},
    {name: "Resp MC Plénières", zones: [1,2,3], id: 47},
    {name: "Resp Opening", zones: [2,3], id: 48},
    {name: "Resp PA Ateliers", zones: [1,2,3], id: 49},
    {name: "Resp PA Intervenants", zones: [2,3,4], id: 50},
    {name: "Resp Photographes", zones: [1,2,3,6,7], id: 51},
    {name: "Resp Présidence Ateliers", zones: [1,2,3], id: 52},
    {name: "Resp Présidence Plénières", zones: [1,2,3,4,6], id: 53},
    {name: "Resp Progra. Ateliers", zones: [1,2,3], id: 54},
    {name: "Resp Restaurant Staff", zones: [3], id: 55},
    {name: "Resp Scène des artistes", zones: [1,3], id: 56},
    {name: "Resp Sécurité", zones: [0], id: 57},
    {name: "Resp Shop RJ", zones: [1,3], id: 58},
    {name: "Resp Stage Manager", zones: [1,2,3,4,6], id: 59},
    {name: "Resp Studio Photo Village", zones: [1,3], id: 60},
    {name: "Resp Fun Zone", zones: [1,3], id: 61},
    {name: "Resp Team Médical", zones: [0], id: 62},
    {name: "Resp Tech Scène Artistes", zones: [1,2,3], id: 63},
    {name: "Resp Village De Stand", zones: [1,3], id: 64},
    {name: "Sécurité - Resp Dortoirs", zones: [0], id: 65},
    {name: "Sponsor RJ", zones: [3], id: 66},
    {name: "Stage Manager", zones: [1,2,3,4,6], id: 67},
    {name: "Team Accueil", zones: [3], id: 68},
    {name: "Team Billetterie", zones: [3,5], id: 69},
    {name: "Team Chalet Staff", zones: [3,7], id: 70},
    {name: "Team Dortoirs", zones: [1,2,3], id: 71},
    {name: "Team Espace Bénévoles", zones: [3,4,7], id: 72},
    {name: "Team Espace Guérison", zones: [3], id: 73},
    {name: "Team Espace Prière", zones: [3], id: 74},
    {name: "Team Espace Prophétique", zones: [3], id: 75},
    {name: "Team Fun Zone", zones: [1,3], id: 76},
    {name: "Team Installation Technique", zones: [3], id: 77},
    {name: "Team Logistique", zones: [1,2,3], id: 78},
    {name: "Team Médias - Photos", zones: [1,2,3,6], id: 79},
    {name: "Team Médias - RS", zones: [1,2,3,6], id: 80},
    {name: "Team Médias - Vidéos", zones: [1,2,3,6], id: 81},
    {name: "Team Médical", zones: [0], id: 82},
    {name: "Team Opening", zones: [3], id: 83},
    {name: "Team Parking", zones: [3], id: 84},
    {name: "Team Restaurant Staff", zones: [3], id: 85},
    {name: "Team RJ", zones: [3], id: 86},
    {name: "Team Sécurité", zones: [0], id: 87},
    {name: "Team Shop RJ", zones: [1,3], id: 88},
    {name: "Team Technique", zones: [1,2,3], id: 89},
    {name: "Team Technique - GS", zones: [1,2,3], id: 90},
    {name: "Team Technique - Studio", zones: [1,2,3], id: 91},
    {name: "Team Technique - Vidéo", zones: [1,2,3], id: 92},
    {name: "Team Village", zones: [1,3], id: 93},
    {name: "Traducteur", zones: [1,2,3,4], id: 94},
    {name: "Worship", zones: [1,2,3,4], id: 95},
    {name: "Resp Espace Guérison", zones: [3], id: 96},
    {name: "RJ24 - Joker", zones: [0], id: 97},
    {name: "Resp Relation d'Aide", zones: [3], id: 98},
    {name: "Staff Espace Gruyère", zones: [0], id: 99}
  ]
end
