module Features
  module AdminHelpers
    def with_user(email, &block)
      user = User.find_by(email: email)
      within(find("//*[@user-list-id='#{user.id}']")) do
        block.call
      end
    end

    def select_role(role)
      select(role, from: 'user_role')
    end
  end
end
