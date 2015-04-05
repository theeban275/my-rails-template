# Feature: Forgotten Password
#   As a user
#   I want to reset my password
#   So I can login to the site
feature 'Forgotten Password' do

  let(:email) { 'john.smith@example.com' }
  let(:forgot_email) { 'john.smith@example.com' }
  let(:new_password) { 'Pas$w0rd' }

  before do
    FactoryGirl.create(:user, email: email)
  end

  def reset_password
    visit new_user_session_path
    click_link 'Forgot password?'
    fill_in 'Email', with: forgot_email
    click_button 'Reset Password'
  end

  def click_reset_password_link
    open_last_email
    click_first_link_in_email
  end

  def change_password(password, password_confirmation)
    fill_in 'New password', with: password
    fill_in 'Confirm new password', with: password_confirmation
    click_button 'Change my Password'
  end

  # Scenario: User is sent password reset email
  #   Given I am registered
  #   And I click on forgot password link
  #   And I fill in my email
  #   When I click reset password
  #   Then I am sent an email to change my password
  scenario 'user is sent password reset email' do
    reset_password
    expect(page).to have_content(/#{I18n.t('devise.passwords.send_instructions')}/)
    delivered_email = open_last_email
    expect(delivered_email).not_to eq(nil)
    expect(delivered_email).to deliver_to(email)
    expect(delivered_email).to have_subject('Reset password instructions')
    expect(delivered_email).to have_body_text('Change my password')
  end

  # Scenario: User is not sent password reset email if email has errors
  #   Given I am registered
  #   And I click on forgot password link
  #   And I fill in blank for email
  #   When I click reset password
  #   Then I see 'reset error' message
  context 'email is blank' do
    let(:forgot_email) { '' }
    scenario 'User cannot reset password if email has errors' do
      reset_password
      expect(page).to have_content("Email can't be blank")
    end
  end

  # Scenario: User is not sent password reset email if user is not registgered
  #   Given I am not registered
  #   And I click on forgot password link
  #   And I fill in my email
  #   When I click reset password
  #   Then I see 'reset error' message
  context 'user is not registered' do
    let(:forgot_email) { 'notregistered@example.com' }
    scenario 'user cannot reset password is user is not registered' do
      reset_password
      expect(page).to have_content('Email not found')
    end
  end

  # Scenario: User can change password by clicking on link in reset password link
  #   Given I have received a change password email
  #   When I click on change password link
  #   And I enter in my new password
  #   And I click on change my password
  #   Then I see 'password changed' message
  scenario 'user can change password by clicking on link in reset password email' do
    reset_password
    click_reset_password_link
    change_password(new_password, new_password)
    expect(page).to have_content(/#{I18n.t('devise.passwords.updated')}/)
  end

  # Scenario: User cannot change password if password has errors
  #   Given I have received a change password email
  #   When I click on change password link
  #   And I enter in my new password but blank for confirmation password
  #   And I click on change my password
  #   Then I see 'password error' message
  scenario 'user cannot change password if passwords have errors' do
    reset_password
    click_reset_password_link
    change_password(new_password, '')
    expect(page).to have_content(/Password confirmation doesn't match Password/)
  end

end
