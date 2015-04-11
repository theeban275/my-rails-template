# Feature: Change role
#   As an admin
#   I want to change a users role
#   So I can add new adminitrators or users
feature 'Change Role' do
  include Features::AdminHelpers

  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:email) { 'somone@example.com' }

  # Scenario: Admin can change users role
  #   Given I am an admin
  #   And I have user 'someone@example.com'
  #   And I on the users page
  #   And I change user 'someone' to admin
  #   Then I see 'role changed' message
  scenario 'admin can change users role' do
    sign_in(admin.email, admin.password)
    FactoryGirl.create(:user, email: email)
    visit users_path
    with_user(email) do
      select_role('Admin')
      click_on 'Change Role'
    end
    expect(page).to have_content('User updated')
  end

end
