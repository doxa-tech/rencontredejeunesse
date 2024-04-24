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
      p data
      pdf = BadgePdf.new(data, SECTORS, ZONES)
      send_data pdf.render, filename: "Badges.pdf", type: "application/pdf", disposition: 'inline'
    end
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
    {name: "Village & Fun Park", color: "00FF00", abb: "vlg"},
    {name: "Plénière & Backstage", color: "0000FF", abb: "plb"},
    {name: "Régies", color: "7F00FF", abb: "reg"},
    {name: "Espace Lounge", color: "FF0000", abb: "lng"},
    {name: "Caisse", color: "5B3C11", abb: "css"},
    {name: "Espace médias", color: "C0C0C0", abb: "med"},
    {name: "Dortoirs", color: "FFA500", abb: "doo"}
  ]

  SECTORS = [
    {name: "Audio Recording", zones: [1,2,3,5], id: 0}, 
    {name: "Badges & Bons", zones: [3,4], id: 1}, 
    {name: "Billetterie", zones: [0,1,3,4], id: 2},
    {name: "Clean Service", zones: [6], id: 3},
    {name: "Community Manager", zones: [0,1,2,3,5], id: 4},
    {name: "Directeur artistique", zones: [0,1,2,3,5], id: 5},
    {name: "Dortoirs", zones: [3,6], id: 6},
    {name: "Louange", zones: [1,3], id: 7},
    {name: "Espace lounge", zones: [3], id: 8},
    {name: "Espace Prière", zones: [3], id: 9},
    {name: "Espace resaurant", zones: [3], id: 10},
    {name: "Finances", zones: [0,3,4], id: 11},
    {name: "Gestion des bénévoles", zones: [0,1,2,3,5], id: 12},
    {name: "Gestion des hôtes (chalet)", zones: [3], id: 13},
    {name: "Gestion des locaux", zones: [0,1,2,3,4,5,6], id: 14},
    {name: "Goodies", zones: [0,3], id: 15},
    {name: "Graphisme", zones: [3,5], id: 16},
    {name: "Guest", zones: [3], id: 17},
    {name: "Light", zones: [0,1,2,3], id: 18},
    {name: "Light petite scène", zones: [0,3], id: 19},
    {name: "Lumière & Ambiance Halle50", zones: [0,3], id: 20},
    {name: "Mail info@RJ", zones: [3,4], id: 21},
    {name: "MC", zones: [1,2,3], id: 22},
    {name: "Montage & Démont.", zones: [0,1,2,3,4,5,6], id: 23},
    {name: "Opening", zones: [1,2,3,5], id: 24},
    {name: "Orateur/ Ateliers", zones: [1,3], id: 25},
    {name: "PA", zones: [0,1,2,3], id: 26},
    {name: "Partenaires", zones: [3], id: 27},
    {name: "Petite scène & Anim.", zones: [0,3], id: 28},
    {name: "Photo communication", zones: [0,1,2,3,5], id: 29},
    {name: "Planification", zones: [0,1,2,3,4,5], id: 30},
    {name: "Présidences", zones: [1,2,3], id: 31},
    {name: "Presse & Rel. publiques", zones: [0,1,3,5], id: 32},
    {name: "Resp. Sponsoring", zones: [0,1,3,5], id: 33},
    {name: "Service d'ordre", zones: [0,1,2,3,4,5,6], id: 34},
    {name: "Service médical", zones: [0,1,2,3,4,5,6], id: 35},
    {name: "Shooting photo", zones: [0,3], id: 36},
    {name: "Site web & App RJ", zones: [3,5], id: 37},
    {name: "Sono petite scène", zones: [0,3], id: 38},
    {name: "Sonorisation", zones: [1,2,3], id: 39},
    {name: "Sponsors", zones: [3], id: 40},
    {name: "Stage manager", zones: [1,2,3], id: 41},
    {name: "Team Domaines", zones: [0,1,2,3,4,5,6], id: 42},
    {name: "Team Vision", zones: [0,1,2,3,4,5,6], id: 43},
    {name: "Traduction", zones: [1,3], id: 44},
    {name: "Vidéo", zones: [1,2,3], id: 45},
    {name: "Vidéo res. sociaux", zones: [0,1,2,3,5], id: 46},
    {name: "Village de stands", zones: [0,3], id: 47},
  ]

end
