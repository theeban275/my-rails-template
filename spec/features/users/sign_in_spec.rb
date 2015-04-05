# Feature: Sign in
#   As a user
#   I want to sign in
#   So I can visit protected areas of the site
feature 'Sign in', :devise do

  let(:email) { 'john.smith@example.com' }
  let(:password) { 'Pas$w0rd' }

  let(:sign_in_email) { 'john.smith@example.com' }
  let(:sign_in_password) { 'Pas$w0rd' }

  def register_user
    FactoryGirl.create(:user, email: email, password: password)
  end

  # Scenario: User can sign in
  #   Given I exist as a user
  #   And I am not signed in
  #   When I sign in with my credentials
  #   Then I see a success message
  scenario 'user can sign in' do
    register_user
    sign_in(sign_in_email, sign_in_password)
    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
  end

  # Scenario: User cannot sign in if not registered
  #   Given I do not exist as a user
  #   When I sign in with valid credentials
  #   Then I see an invalid credentials message
  context 'user is not registered' do
    scenario 'user cannot sign in if not registered' do
      sign_in(sign_in_email, sign_in_password)
      expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'email'
    end
  end

  # Scenario: User cannot sign in with wrong email
  #   Given I exist as a user
  #   And I am not signed in
  #   When I sign in with a wrong email
  #   Then I see an invalid email message
  context 'sign in email is wrong' do
    let(:sign_in_email) { 'invalid@example.com' }
    scenario 'user cannot sign in with wrong email' do
      register_user
      sign_in(sign_in_email, sign_in_password)
      expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'email'
    end
  end

  # Scenario: User cannot sign in with wrong password
  #   Given I exist as a user
  #   And I am not signed in
  #   When I sign in with a wrong password
  #   Then I see an invalid password message
  context 'sign in password is wrong' do
    let(:sign_in_password) { 'invalidpass' }
    scenario 'user cannot sign in with wrong password' do
      register_user
      sign_in(sign_in_email, sign_in_password)
      expect(page).to have_content I18n.t 'devise.failure.invalid', authentication_keys: 'email'
    end
  end

end
