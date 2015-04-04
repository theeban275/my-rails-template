# Feature: Confirm Account
#   As an administrator
#   I want visitors to confirm their account
#   So only confirmed users can visit the site
feature 'Confirm', :devise do

  # Scenario: Send confirm email account email after visitor signs up
  #   Given Visitor signs up
  #   Then Visitor is send confirm account email
  scenario 'visitor is sent confirm account email message after signing up' do
    sign_up_with('test@example.com', 'please123', 'please123')
    email = ActionMailer::Base.deliveries.first
    expect_confirm_account_email(email)
  end

  # Scenario: User can sign in if confirmed
  #   Given I have signed up
  #   And I have confirmed
  #   When I sign in with valid credentials
  #   Then I see a success message
  scenario 'user cannot sign in if not confirmed' do
    user = FactoryGirl.create(:user, confirmed_at: Time.now)
    sign_in(user.email, user.password)
    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
  end

  # Scenario: User cannot sign in if not confirmed
  #   Given I have signed up
  #   And I have not confirmed
  #   When I sign in with valid credentials
  #   Then I see must confirm acccount message
  scenario 'user cannot sign in if not confirmed' do
    user = FactoryGirl.create(:user, confirmed_at: nil)
    sign_in(user.email, user.password)
    expect(page).to have_content I18n.t 'devise.failure.unconfirmed'
  end

  # Helper methods

  def expect_confirm_account_email(email)
    expect(email).not_to eq(nil)
    expect(email).to deliver_to('test@example.com')
    expect(email).to have_subject(I18n.t 'devise.mailer.confirmation_instructions.subject')
    expect(email).to have_body_text(/Confirm my account/)
  end

end

