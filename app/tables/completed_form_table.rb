class CompletedFormTable < BaseTable

  def attributes
    [:id, { form: :name }, :to_s]
  end

  def model
    Form::CompletedForm
  end

  def belongs_to_associations
    [:form]
  end

  module Search

    def self.associations
      [:form]
    end

    def self.fields
      { form: [:name] }
    end

  end

end
