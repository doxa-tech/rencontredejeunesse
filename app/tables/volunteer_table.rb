class VolunteerTable < BaseTable

  def attributes
    [:id, { user: :name } , :sector, :comment, :confirmed, :created_at, :updated_at]
  end

  def model
    Volunteer
  end

  def belongs_to_associations
    [:user]
  end

  module Search

    def self.associations
      [:user]
    end

    def self.fields
      { users: [:firstname, :lastname, :email] }
    end

  end

end
