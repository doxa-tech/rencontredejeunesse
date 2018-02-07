Then("I should see the volunteer confirmation page") do
    expect(find "h2").to have_content("Confirmation")
end
