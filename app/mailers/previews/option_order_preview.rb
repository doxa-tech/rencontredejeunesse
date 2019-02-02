class OptionOrderPreview < ActionMailer::Preview
  def confirmation
    option_order = OptionOrder.last
    OptionOrderMailer.confirmation(option_order)
  end
end
