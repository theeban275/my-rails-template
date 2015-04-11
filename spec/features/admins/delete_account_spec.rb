# Feature: Delete Account
#   As a admin
#   I want to delete a users account
#   So I can remove unwanted users
feature 'Delete Account' do
  include Features::AdminHelpers

  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:other_user) { FactoryGirl.create(:user, email: 'someone@example.com') }

  before do
    sign_in(admin.email, admin.password)
    other_user
    visit users_path
  end

  # Scenario: Admin can delete other users
  #   Given I am an admin
  #   And I have a user 'someone@example.com'
  #   And I am on the users page
  #   When I click delete for user 'someone'
  #   Then I see 'user deleted' message
  scenario 'admin can delete other users' do
    with_user(other_user.email) do
      click_on 'Delete user'
    end
    expect(page).to have_content('User deleted')
  end

  # Scenario: Admin cannot delete own account
  #   Given I am an admin
  #   And I am on the users page
  #   When I click delete for self
  #   Then I see 'cannot delete' message
  context 'other user is admin' do
    let(:other_user) { admin }
    scenario 'admin cannot delete own account' do
      with_user(other_user.email) do
        expect(page).not_to have_button('Delete user')
      end
    end
  end
end
