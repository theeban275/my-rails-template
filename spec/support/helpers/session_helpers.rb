module Features
  module SessionHelpers
    def sign_up_with(args)
      visit new_user_registration_path
      within '.authform' do
        fill_in 'Name', with: args[:name]
        fill_in 'Email', with: args[:email]
        fill_in 'Password', with: args[:password]
        fill_in 'Password confirmation', with: args[:password_confirmation]
        click_button 'Sign up'
      end
    end

    def sign_in(email, password)
      visit new_user_session_path
      within '.authform' do
        fill_in 'Email', with: email
        fill_in 'Password', with: password
        click_button 'Sign in'
      end
    end
  end
end
