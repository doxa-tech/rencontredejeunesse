Then("I should see the volunteer confirmation page") do
    expect(find "h1").to have_content("Confirmation")
end
