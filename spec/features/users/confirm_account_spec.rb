# Feature: Confirm Account
#   As a user
#   I must confirm my account
#   Before I can sign in into the site
feature 'Confirm Account', :devise do

  let(:name) { 'John Smith' }
  let(:email) { 'john.smith@example.com' }
  let(:password) { 'Pas$w0rd' }
  let(:password_confirmation) { 'Pas$w0rd' }
  let(:user) { User.find_by_email(email) }

  before do
    sign_up_with(name: name, email: email,
                 password: password, password_confirmation: password_confirmation)
  end

  def confirm_account
    open_last_email
    click_first_link_in_email
  end

  # Scenario: Send confirm account email after signing up
  #   Given User does not exist
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
  #   Given User is sent confirm email acount
  #   When I click on link in email
  #   Then I have confirmed my account
  scenario 'user can confirm account by clicking on link in email' do
    confirm_account
    expect(user).to be_confirmed
  end

  # Scenario: User can sign in if confirmed
  #   Given User is sent confirm account email
  #   And User can confirmed my account
  #   When I sign in
  #   Then I see sign in successful message
  scenario 'user can sign in if confirmed' do
    confirm_account
    sign_in(email, password)
    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
  end

  # Scenario: User cannot sign in if not confirmed
  #   Given User is sent confirm account email
  #   And User has not confirmed account
  #   When I sign in
  #   Then I see must confirm acccount message
  scenario 'user cannot sign in if not confirmed' do
    sign_in(email, password)
    expect(page).to have_content I18n.t 'devise.failure.unconfirmed'
  end

end

