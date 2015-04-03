# Feature: Sign in
#   As a user
#   I want to sign in
#   So I can visit protected areas of the site
feature 'Sign in', :devise do

  let(:email) { 'john.smith@example.com' }
  let(:password) { 'Pas$w0rd' }

  Given(:user) { create(:user) }

  describe 'user can sign in with valid credentials' do
    When { sign_in(user.email, user.password) }
    Then { expect(page).to have_content I18n.t 'devise.sessions.signed_in' }
  end

  describe 'user cannot sign in with wrong email' do
    When { sign_in('invalid@email.com', user.password) }
    Then { expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'email' }
  end

  describe 'user cannot sign in with wrong password' do
    When { sign_in(user.email, 'invalidpass') }
    Then { expect(page).to have_content I18n.t 'devise.failure.invalid', authentication_keys: 'email' }
  end

  describe 'user cannot sign in if not registered' do
    Given(:user) { nil }
    When { sign_in(email, password) }
    Then { expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'email' }
  end

end
