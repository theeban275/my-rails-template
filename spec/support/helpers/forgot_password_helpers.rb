module Features
  module ForgotPasswordHelpers
    def click_reset_password_link
      open_last_email
      click_first_link_in_email
    end

    def change_password(password, password_confirmation)
      fill_in 'New password', with: password
      fill_in 'Confirm new password', with: password_confirmation
      click_button 'Change my Password'
    end
  end
end
