class Contact
   include ActiveModel::Model

   CONTACT_EMAILS = {
      "order" => "info@rencontredejeunesse.ch",
      "group_order" => "contact@doxatech.ch",
      "bug" => "contact@doxatech.ch",
      "general" => "info@rencontredejeunesse.ch"
   }

   attr_accessor :firstname, :lastname, :subject, :email, :message, :category

   validates :firstname, :lastname, :subject, :email, presence: true
   validates :email, format: { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
   validates :category, inclusion: { in: CONTACT_EMAILS.keys }

   def contact_email
      if Rails.env.production? 
         CONTACT_EMAILS[category]
      else
         "test@jstech.ch"
      end
   end

end
