class OptionOrderTable < BaseTable

  def attributes
    [:id, { user: :name } , { user: :email }, { user: :phone }, { order: :status }, { completed_form: :to_s }]
  end

  def model
    OptionOrder
  end

  def belongs_to_associations
    [:user, :order]
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
