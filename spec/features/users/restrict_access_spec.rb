# Feature: Restrict Access
#   As a user
#   I must log in
#   So I can visit a secured page
feature 'Retrict Access' do

  let(:user) { FactoryGirl.create(:user) }

  # Scenario: User can visit secured page
  #   Given I am logged in
  #   When I visit my profile page
  #   Then I am on my profile page
  context 'user logged in' do
    scenario 'user can visit secured page' do
      sign_in(user.email, user.password)
      expect(page).to have_content(/#{I18n.t('devise.sessions.signed_in')}/)
      visit user_path(user)
      expect(current_path).to eq(user_path(user))
    end
  end

  context 'user not logged in' do
    # Scenario: User can visit secured page
    #   Given I am not logged in
    #   When I visit my profile page
    #   Then I see 'unauthenticated' message
    scenario 'user is redirected to sign in page' do
      visit user_path(user)
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content(/#{I18n.t('devise.failure.unauthenticated')}/)
    end

    # Scenario: User can visit secured page
    #   Given I am not logged in
    #   When I visit my profile page
    #   Then I see 'unauthenticated' message
    #   When I log in
    #   Then I am on my profile page
    scenario 'user is redirected back to secured page after loggin in after being denied access' do
      visit user_path(user)
      sign_in(user.email, user.password)
      expect(page).to have_content(/#{I18n.t('devise.sessions.signed_in')}/)
      expect(current_path).to eq(user_path(user))
    end
  end

end
