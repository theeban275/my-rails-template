# Feature: Confirm Account
#   As a user
#   I must confirm my account
#   Before I can sign in into the site
feature 'Confirm Account', :devise do
  include Features::ConfirmAccountHelpers

  let(:name) { 'John Smith' }
  let(:email) { 'john.smith@example.com' }
  let(:password) { 'Pas$w0rd' }
  let(:password_confirmation) { 'Pas$w0rd' }
  let(:user) { User.find_by_email(email) }

  before do
    sign_up_with(name: name, email: email,
                 password: password, password_confirmation: password_confirmation)
  end

  # Scenario: Send confirm account email after signing up
  #   Given I as a user do not exist
  #   When I sign up
  #   Then I receive confirm account email
  scenario 'send confirm account email after signing up' do
    delivered_email = open_last_email
    expect(delivered_email).not_to eq(nil)
    expect(delivered_email).to deliver_to(email)
    expect(delivered_email).to have_subject(I18n.t 'devise.mailer.confirmation_instructions.subject')
    expect(delivered_email).to have_body_text(/Confirm my account/)
  end

  # Scenario: User can confirm account by clicking on link in email
  #   Given I have received a confirm account email
  #   When I click on link in email
  #   Then I have confirmed my account
  scenario 'user can confirm account by clicking on link in email' do
    click_confirm_account_link
    expect(user).to be_confirmed
  end

  # Scenario: User can sign in if confirmed
  #   Given I have confirmed my account
  #   When I sign in
  #   Then I see sign in successful message
  scenario 'user can sign in if confirmed' do
    click_confirm_account_link
    sign_in(email, password)
    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
  end

  # Scenario: User cannot sign in if not confirmed
  #   Given I have not confirm my account
  #   When I sign in
  #   Then I see must confirm acccount message
  scenario 'user cannot sign in if not confirmed' do
    sign_in(email, password)
    expect(page).to have_content I18n.t 'devise.failure.unconfirmed'
  end

end

