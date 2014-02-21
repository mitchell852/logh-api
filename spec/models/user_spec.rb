require 'spec_helper'

describe User do

  it { should respond_to(:first_name) }
  its(:first_name) { should be_blank }

  it { should respond_to(:last_name) }
  its(:last_name) { should be_blank }

  it { should respond_to(:email) }
  its(:email) { should be_blank }

  it { should respond_to(:password) }
  its(:password) { should be_blank }

  it { should respond_to(:leagues) }
  its(:leagues) { should be_empty }

  it { should respond_to(:teams) }
  its(:teams) { should be_empty }

  context 'when first name is not present' do
    it 'should be invalid' do
      user = FactoryGirl.build(:user, first_name: '')
      expect(user).not_to be_valid
    end
  end

  context 'when first name is longer than 20 characters' do
    it 'should be invalid' do
      user = FactoryGirl.build(:user, first_name: 'a' * 21)
      expect(user).not_to be_valid
    end
  end

  context 'when last name is not present' do
    it 'should be invalid' do
      user = FactoryGirl.build(:user, last_name: '')
      expect(user).not_to be_valid
    end
  end

  context 'when last name is longer than 20 characters' do
    it 'should be invalid' do
      user = FactoryGirl.build(:user, last_name: 'z' * 21)
      expect(user).not_to be_valid
    end
  end

  context 'when email address is not unique' do
    it 'should be invalid' do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.build(:user, email: user1.email.upcase)
      expect(user2).not_to be_valid
    end
  end

  context 'when email format is invalid' do
    it 'should be invalid' do
      addresses = %w{user@foo,com user@foo...com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com}
      addresses.each do |invalid_address|
        user = FactoryGirl.build(:user, email: invalid_address)
        expect(user).not_to be_valid
      end
    end
  end

  context 'when email format is valid' do
    it 'should be valid' do
      addresses = %w{user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn}
      addresses.each do |valid_address|
        user = FactoryGirl.create(:user, email: valid_address)
        expect(user).to be_valid
      end
    end
  end

  context 'when email has upper case characters' do
    let(:mixed_case_email) { 'Foo@Bar.com' }

    it 'should be saved as lowercase' do
      user = FactoryGirl.create(:user, email: mixed_case_email )
      expect(user.reload.email).to eq(mixed_case_email.downcase)
    end
  end

  context 'when password is less than 6 characters' do
    it 'should be invalid' do
      user = FactoryGirl.build(:user, password: 'fooba')
      expect(user).not_to be_valid
    end
  end

end
