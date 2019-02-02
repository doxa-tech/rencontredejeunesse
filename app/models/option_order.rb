class OptionOrder < ApplicationRecord

  belongs_to :user
  belongs_to :order_bundle
  belongs_to :order, autosave: true
  belongs_to :completed_form, class_name: "Form::CompletedForm", dependent: :destroy

  def build_order(user, item)
    self.order = Orders::Event.new(user: user)
    self.order.limited = true
    self.order.registrants.build_from_user(user)
    self.order.registrants.first.item = item
  end

end
