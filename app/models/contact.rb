class Contact
   include ActiveModel::Model

   attr_accessor :firstname, :lastname, :subject, :email, :message

   validates :firstname, :lastname, :subject, :email, presence: true
   validates :email, format: { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }

end
