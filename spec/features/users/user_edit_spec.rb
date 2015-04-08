# Feature: User edit
#   As a user
#   I want to edit my user profile
#   So I can change my details
feature 'User edit', :devise do
  include Features::ConfirmAccountHelpers

  describe 'Edit details' do

    let(:user) { FactoryGirl.create(:user, name: name, email: email, password: password) }
    let(:name) { 'John Smith' }
    let(:email) { 'john.smith@example.com' }
    let(:password) { 'Pas$w0rd' }
    let(:current_password) { 'Pas$w0rd' }

    let(:new_name) { 'John Smith' }
    let(:new_email) { 'john.smith@example.com' }
    let(:new_password) { '' }
    let(:new_password_confirmation) { '' }

    before do
      sign_in(user.email, user.password)
      visit edit_user_registration_path(user)
      fill_in 'Name', with: new_name
      fill_in 'Email', with: new_email
      fill_in 'Password', with: new_password
      fill_in 'Password confirmation', with: new_password_confirmation
      fill_in 'Current password', :with => current_password
      click_button 'Update'
    end

    def expect_resign_in(email, password)
      click_link 'Sign out'
      sign_in(email, password)
      expect(page).to have_content I18n.t 'devise.sessions.signed_in'
    end

    # Scenario: User changes name
    #   Given I am on the edit profile page
    #   When I enter in new name
    #   Then I see an account updated message
    context 'new name is entered' do
      let(:new_name) { 'Jason Smith' }
      scenario 'user changes name' do
        expect(page).to have_content(/#{I18n.t( 'devise.registrations.updated')}/)
      end
    end

    # Scenario: User cannot change name if name has errors
    #   Given I am on the edit profile page
    #   When I enter in blank name
    #   Then I see "name can't be blank" message
    context 'new name is entered but has errors' do
      let(:new_name) { '' }
      scenario 'user cannot change name' do
        expect(page).to have_content(/#{I18n.t('errors.messages.not_saved.one', resource: 'user')}/)
        expect(page).to have_content(/Name can't be blank/)
      end
    end

    # Scenario: User changes email address
    #   Given I am on the edit profile page
    #   When I enter in new email address
    #   Then I see an account updated message
    #   And I am sent confirm account to new email address
    #   When I confirm my account
    #   Then I can login with new email
    context 'new email is entered' do
      let(:new_email) { 'jason.smith@example.com' }
      scenario 'user changes email address' do
        expect(page).to have_content(/#{I18n.t( 'devise.registrations.update_needs_confirmation')}/)
        expect(open_last_email).to deliver_to(new_email)
        click_confirm_account_link
        expect_resign_in(new_email, password)
      end
    end

    # Scenario: User cannot change email address if email address has errors
    #   Given I am on the edit profile page
    #   When I enter in blank email address
    #   Then I see "email can't be blank" message
    context 'new email is entered but has errors' do
      let(:new_email) { '' }
      scenario 'user cannot change email address' do
        expect(page).to have_content(/#{I18n.t('errors.messages.not_saved.one', resource: 'user')}/)
        expect(page).to have_content(/Email can't be blank/)
      end
    end

    # Scenario: User changes password
    #   Given I am on the edit profile page
    #   When I enter in new password
    #   Then I see an account updated message
    #   Then I can login with new password
    context 'new password is entered' do
      let(:new_password) { 'please123' }
      let(:new_password_confirmation) { 'please123' }
      scenario 'user changes password' do
        expect(page).to have_content(/#{I18n.t( 'devise.registrations.updated')}/)
        expect_resign_in(email, new_password)
      end
    end

    # Scenario: User cannot change password if password has errors
    #   Given I am on the edit profile page
    #   And I enter in different password confirmation
    #   Then I see "password confirmation doesn't match" message
    context 'password not valid' do
      let(:new_password) { 'please123' }
      let(:new_password_confirmation) { 'Pas$word' }
      scenario 'user cannot change password' do
        expect(page).to have_content(/#{I18n.t('errors.messages.not_saved.one', resource: 'user')}/)
        expect(page).to have_content(/Password confirmation doesn't match Password/)
      end
    end

    # Scenario: User cannot make changes if current password is blank
    #   Given I am on the edit profile page
    #   And I update details
    #   And I enter in wrong current password
    #   Then I see "current password is blank" message
    context 'current password is incorrect' do
      let(:new_name) { 'Jason Smith' }
      let(:new_email) { 'jason.smith@example.com' }
      let(:new_password) { 'please123' }
      let(:new_password_confirmation) { 'please123' }
      let(:current_password) { '' }
      scenario 'user cannot make any changes' do
        expect(page).to have_content(/Current password can't be blank/)
      end
    end

  end

  # Scenario: User cannot edit another user's profile
  #   Given I am signed in
  #   When I try to edit another user's profile
  #   Then I see my own 'edit profile' page
  scenario "user cannot cannot edit another user's profile", :me do
    me = FactoryGirl.create(:user)
    other = FactoryGirl.create(:user, email: 'other@example.com')
    sign_in(me.email, me.password)
    visit edit_user_registration_path(other)
    expect(page).to have_content 'Edit User'
    expect(page).to have_field('Email', with: me.email)
  end

end
