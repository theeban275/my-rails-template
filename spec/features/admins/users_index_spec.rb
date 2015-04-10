# Feature: List users
#   As a admin
#   I want to see a list of users
#   So I can see who has registered
feature 'User index page', :devise do
  let(:user) { FactoryGirl.create(:user, :admin) }

  before do
    sign_in(user.email, user.password)
  end

  # Scenario: User listed on index page
  #   Given I am signed in
  #   When I visit the user index page
  #   Then I should see a list of users
  scenario 'user sees own email address' do
    visit users_path
    expect(page).to have_content user.email
  end

end
