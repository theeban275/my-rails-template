# Feature: Sign up
#   As a visitor
#   I want to sign up
#   So I can visit protected areas of the site
feature 'Sign Up', :devise do

  let(:name) { 'John Smith' }
  let(:email) { 'john.smith@example.com' }
  let(:password) { 'Pas$w0rd' }
  let(:password_confirmation) { 'Pas$w0rd' }

  before do
    sign_up_with(name: name, email: email,
                 password: password, password_confirmation: password_confirmation)
  end

  # Scenario: Visitor can sign up
  #   Given I am not signed in
  #   When I sign up with my details
  #   Then I see a successful sign up message
  scenario 'visitor can sign up' do
    expect(page).to have_content(/#{I18n.t('devise.registrations.signed_up_but_unconfirmed')}/)
  end

  # Scenario: Visitor cannot sign up when name has errors
  #   Given I am not signed in
  #   When I sign up without a name
  #   Then I see an 'name is blank' message
  context 'with blank name' do
    let(:name) { '' }
    scenario 'visitor cannot sign up when name has errors' do
      expect(page).to have_content "Name can't be blank"
    end
  end

  # Scenario: Visitor cannot sign up when email address has errors
  #   Given I am not signed in
  #   When I sign up with an invalid email address
  #   Then I see an 'invalid email' message
  context 'with invalid email address' do
    let(:email) { 'bogus' }
    scenario 'visitor cannot sign up when email address has errors' do
      expect(page).to have_content 'Email is invalid'
    end
  end

  # Scenario: Visitor cannot sign up when password has errors
  #   Given I am not signed in
  #   When I sign up without a password
  #   Then I see a 'missing password' message
  context 'with blank password' do
    let(:password) { '' }
    scenario 'visitor cannot sign up when password has errors' do
      expect(page).to have_content "Password can't be blank"
    end
  end

  # Scenario: Visitor cannot sign up when password confirmation has errors
  #   Given I am not signed in
  #   When I sign up without a password confirmation
  #   Then I see a 'missing password confirmation' message
  context 'with blank password confirmation' do
    let(:password_confirmation) { '' }
    scenario 'visitor cannot sign up when password confirmation has errors' do
      expect(page).to have_content "Password confirmation doesn't match"
    end
  end

end
