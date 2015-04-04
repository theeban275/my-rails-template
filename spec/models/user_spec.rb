describe User do
  subject(:user) { User.new(name: name, email: email, password: password, password_confirmation: password_confirmation) }

  let(:name) { 'John Smith' }
  let(:email) { 'john.smith@example.com' }
  let(:password) { 'Pas$w0rd' }
  let(:password_confirmation) { 'Pas$w0rd' }

  describe 'validations' do
    before { user.valid? }

    it { expect(user).to be_valid }

    describe '#name' do
      context 'when blank' do
        let(:name) { '' }
        it { expect(user.errors[:name]).to include("can't be blank") }
      end

      context 'when equal to max name length' do
        let(:name) { 'a' * User.max_name_length }
        it { expect(user).to be_valid }
      end

      context 'when greater than max name length' do
        let(:name) { 'a' * (User.max_name_length + 1) }
        it { expect(user.errors[:name]).to eq(["is too long (maximum is #{User.max_name_length} characters)"]) }
      end
    end

    describe '#email' do
      context 'when blank' do
        let(:email) { '' }
        it { expect(user.errors[:email]).to include("can't be blank") }
      end

      context 'when equal to max email length' do
        let(:email) { 'a@a.com' + 'a' * (User.max_email_length - 7) }
        it { expect(user).to be_valid }
      end

      context 'when greater than max email length' do
        let(:email) { 'a@a.com' + 'a' * (User.max_email_length - 7 + 1) }
        it { expect(user.errors[:email]).to eq(["is too long (maximum is #{User.max_email_length} characters)"]) }
      end

      context 'when not valid' do
        let(:email) { 'not an email' }
        it { expect(user.errors[:email]).to include("is invalid") }
      end
    end

    describe '#password' do
      context 'when blank' do
        let(:password) { '' }
        let(:password_confirmation) { password }
        it { expect(user.errors[:password]).to include("can't be blank") }
      end

      context 'when less than password min length' do
        let(:password) { 'a' * (User.min_password_length - 1) }
        let(:password_confirmation) { password }
        it { expect(user.errors[:password]).to eq(["is too short (minimum is #{User.min_password_length} characters)"]) }
      end

      context 'when equal to password min length' do
        let(:password) { 'a' * User.min_password_length }
        let(:password_confirmation) { password }
        it { expect(user).to be_valid }
      end

      context 'when equal to password max length' do
        let(:password) { 'a' * User.max_password_length }
        let(:password_confirmation) { password }
        it { expect(user).to be_valid }
      end

      context 'when greater than password max length' do
        let(:password) { 'a' * (User.max_password_length + 1) }
        let(:password_confirmation) { password }
        it { expect(user.errors[:password]).to eq(["is too long (maximum is #{User.max_password_length} characters)"]) }
      end

      # FIXME bug with validation for confirmation not working
      #context 'when confirmation not equal' do
        #let(:password) { 'Pas$w0rd' }
        #let(:password_confirmation) { '' }
        #it { expect(user.errors[:password]).to include("") }
      #end
    end
  end

  describe '#role' do
    it { expect(user.role).to eq('user') }
  end
end
