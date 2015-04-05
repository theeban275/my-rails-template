# Feature: User delete
#   As a user
#   I want to delete my user profile
#   So I can close my account
feature 'User delete', :devise do

  # Scenario: User can delete own account
  #   Given I am signed in
  #   When I delete my account
  #   Then I should see an account deleted message
  scenario 'user can delete own account', :js do
    user = FactoryGirl.create(:user)
    sign_in(user.email, user.password)
    visit edit_user_registration_path(user)
    click_button 'Cancel my account'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content I18n.t 'devise.registrations.destroyed'
  end

end
