module Features
  module ConfirmAccountHelpers
    def click_confirm_account_link
      open_last_email
      click_first_link_in_email
    end
  end
end

