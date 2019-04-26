class Admin::BadgesController < Admin::BaseController

  def index
  end

  def create
    respond_to do |format|
      format.pdf do
        pdf = BadgePdf.new()
        send_data pdf.render, filename: "Badges.pdf", type: "application/pdf", disposition: 'inline'
      end
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
