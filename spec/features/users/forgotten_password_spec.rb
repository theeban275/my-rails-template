# Feature: Forgotten Password
#   As a user
#   I want to reset my password
#   So I can login to the site with a new password after losing my old password
feature 'Forgotten Password' do
  include Features::ForgotPasswordHelpers

  let(:email) { 'john.smith@example.com' }
  let(:forgot_email) { 'john.smith@example.com' }
  let(:new_password) { 'Pas$w0rd' }

  before do
    FactoryGirl.create(:user, email: email)
    visit new_user_session_path
    click_link 'Forgot password?'
    fill_in 'Email', with: forgot_email
    click_button 'Reset Password'
  end

  # Scenario: User is sent password reset email
  #   Given I am registered
  #   And I am on sign in page
  #   And I click on forgot password
  #   And I fill in my email
  #   When I click reset password
  #   Then I am sent an email to change my password
  scenario 'user is sent password reset email' do
    expect(page).to have_content(/#{I18n.t('devise.passwords.send_instructions')}/)
    delivered_email = open_last_email
    expect(delivered_email).not_to eq(nil)
    expect(delivered_email).to deliver_to(email)
    expect(delivered_email).to have_subject('Reset password instructions')
    expect(delivered_email).to have_body_text('Change my password')
  end

  # Scenario: User is not sent password reset email if email is not specified
  #   Given I am registered
  #   And I am on sign in page
  #   And I click on forgot password
  #   And I fill in blank for email
  #   When I click reset password
  #   Then I see "email can't be blank" message
  context 'email is blank' do
    let(:forgot_email) { '' }
    scenario 'User cannot reset password if email is not specified' do
      expect(page).to have_content("Email can't be blank")
    end
  end

  # Scenario: User is not sent password reset email if user is not registgered
  #   Given I am not registered
  #   And I am on sign in page
  #   And I click on forgot password
  #   And I fill in my email
  #   When I click reset password
  #   Then I see 'email not found' message
  context 'user is not registered' do
    let(:forgot_email) { 'notregistered@example.com' }
    scenario 'user cannot reset password is user is not registered' do
      expect(page).to have_content('Email not found')
    end
  end

  # Scenario: User can change password by clicking on link in reset password link
  #   Given I have received a reset password email
  #   When I click on reset password link
  #   And I change my password
  #   Then I see 'password changed' message
  scenario 'user can change password by clicking on link in reset password email' do
    click_reset_password_link
    change_password(new_password, new_password)
    expect(page).to have_content(/#{I18n.t('devise.passwords.updated')}/)
  end

  # Scenario: User cannot change password if password has errors
  #   Given I have received a reset password email
  #   When I click on reset password link
  #   And I change my password with invalid confirmation
  #   Then I see "password confirmation doesn't match" message
  scenario 'user cannot change password if passwords have errors' do
    click_reset_password_link
    change_password(new_password, '')
    expect(page).to have_content(/Password confirmation doesn't match Password/)
  end

end
