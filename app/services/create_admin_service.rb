class CreateAdminService
  def call
    secrets = Rails.application.secrets
    user = User.find_or_create_by!(name: secrets.admin_name, email: secrets.admin_email) do |user|
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        user.confirm!
        user.admin!
      end
  end
end
