# Feature: List users
#   As a admin
#   I want to see a list of users
#   So I can see who has registered
feature 'User index page', :devise do
  let(:user) { FactoryGirl.create(:user, :admin) }
  let(:extra_user_count) { 3 }

  before do
    sign_in(user.email, user.password)
  end

  # Scenario: User listed on index page
  #   Given I am signed in
  #   When I visit the user index page
  #   Then I should see a list of users
  scenario 'user sees own email address' do
    extra_user_count.times.each { |i| FactoryGirl.create(:user, email: "someone#{i}@example.com") }
    visit users_path
    User.pluck(:email).each do |email|
      expect(page).to have_content email
    end
  end

  context 'user not and administrator' do
    let(:user) { FactoryGirl.create(:user) }
    scenario 'user cannot see index if not administrator' do
      visit users_path
      expect(page).to have_content('Access denied')
    end
  end

end
