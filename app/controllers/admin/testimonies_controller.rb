class Admin::TestimoniesController < Admin::BaseController
  load_and_authorize

  def index
    @table = Table.new(self, Testimony, @testimonies, truncate: false)
  end

  def edit
  end

  def update
		if @testimony.update_attributes(testimony_params)
			redirect_to admin_testimonies_path, success: "Témoignage mis à jour"
		else
			render 'edit'
		end
  end 

  def destroy
    @testimony.destroy
		redirect_to admin_testimonies_path, success: "Témoignage supprimé"
  end

  private

  def testimony_params
    params.require(:testimony).permit(:message)
  end

end
