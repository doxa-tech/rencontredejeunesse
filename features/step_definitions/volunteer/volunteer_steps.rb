Given("I am a volunteer") do
  @user = create(:volunteer)
end

Given("a volunteering is available") do
  @volunteering = create(:volunteering, key: "rj2019")
end
