describe User do
  subject(:user) { User.new(name: name, email: email, password: password, password_confirmation: password_confirmation) }

  let(:name) { 'John Smith' }
  let(:email) { 'john.smith@example.com' }
  let(:password) { 'Pas$w0rd' }
  let(:password_confirmation) { 'Pas$w0rd' }

  let(:max_name_length) { User.name_length.last }
  let(:max_email_length) { User.email_length.last }
  let(:min_password_length) { User.password_length.first }
  let(:max_password_length) { User.password_length.last }

  def extend_string(string, length)
    s = string || 'a'
    s + s.last * (length - s.length)
  end

  describe 'validations' do
    before { user.valid? }

    it { expect(user).to be_valid }

    describe '#name' do
      context 'when blank' do
        let(:name) { '' }
        it { expect(user.errors[:name]).to eq(["can't be blank"]) }
      end

      context 'when equal to max name length' do
        let(:name) { extend_string('John Smith', max_name_length) }
        it { expect(user).to be_valid }
      end

      context 'when greater than max name length' do
        let(:name) { extend_string('John Smith', max_name_length + 1) }
        it { expect(user.errors[:name]).to eq(["is too long (maximum is #{max_name_length} characters)"]) }
      end
    end

    describe '#email' do
      context 'when blank' do
        let(:email) { '' }
        it { expect(user.errors[:email]).to eq(["can't be blank"]) }
      end

      context 'when equal to max email length' do
        let(:email) { extend_string('john.smith@example.com', max_email_length)}
        it { expect(user).to be_valid }
      end

      context 'when greater than max email length' do
        let(:email) { extend_string('john.smith@example.com', max_email_length + 1) }
        it { expect(user.errors[:email]).to eq(["is too long (maximum is #{max_email_length} characters)"]) }
      end

      context 'when not valid' do
        let(:email) { 'not an email' }
        it { expect(user.errors[:email]).to eq(["is invalid"]) }
      end

      context 'when email already exists' do
        subject(:user) do
          FactoryGirl.create(:user, email: email)
          FactoryGirl.build(:user, email: email)
        end
        it { expect(user.errors[:email]).to eq(["has already been taken"]) }
      end
    end

    describe '#password' do
      context 'when blank' do
        let(:password) { '' }
        let(:password_confirmation) { password }
        it { expect(user.errors[:password]).to eq(["can't be blank"]) }
      end

      context 'when less than password min length' do
        let(:password) { extend_string('a', min_password_length - 1)}
        let(:password_confirmation) { password }
        it { expect(user.errors[:password]).to eq(["is too short (minimum is #{min_password_length} characters)"]) }
      end

      context 'when equal to password min length' do
        let(:password) { extend_string('a', min_password_length) }
        let(:password_confirmation) { password }
        it { expect(user).to be_valid }
      end

      context 'when equal to password max length' do
        let(:password) { extend_string('a', max_password_length) }
        let(:password_confirmation) { password }
        it { expect(user).to be_valid }
      end

      context 'when greater than password max length' do
        let(:password) { extend_string('a', max_password_length + 1) }
        let(:password_confirmation) { password }
        it { expect(user.errors[:password]).to eq(["is too long (maximum is #{max_password_length} characters)"]) }
      end
    end

    describe '#password_confirmation' do
      context 'when confirmation not equal' do
        let(:password) { 'Pas$w0rd' }
        let(:password_confirmation) { '' }
        it { expect(user.errors[:password_confirmation]).to include("doesn't match Password") }
      end
    end
  end

  describe '#role' do
    it { expect(user.role).to eq('user') }
  end
end
