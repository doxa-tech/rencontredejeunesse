class UserTable < BaseTable

  def attributes
    [:id, :gender, :firstname, :lastname, :email, :phone, :address, :npa, :city, :country, :confirmed, :created_at, :updated_at]
  end

  def model
    User
  end

end
