require 'csv'

class Admin::BadgesController < Admin::BaseController

  def index
  end

  def create
    file = params[:file]
    if file
      CSV.foreach(file.path, headers: true) do |row|
      end
      pdf = BadgePdf.new()
      send_data pdf.render, filename: "Badges.pdf", type: "application/pdf", disposition: 'inline'
    else
      redirect_to admin_badges_path, error: "Erreur"
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

end
