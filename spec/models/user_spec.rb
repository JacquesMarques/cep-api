# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it { should have_many(:access_tokens) }

  it { should validate_presence_of(:email) }

  describe 'validate uniqueness' do
    subject { build(:user, email: 'test@gmail.com') }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  end

  it { should validate_presence_of(:password) }

  it 'generates a confirmation token' do
    user.valid?
    expect(user.confirmation_token).to_not be nil
  end

  it 'downcase email before validating' do
    user.email = 'John@example.com'
    expect(user.valid?).to be true
    expect(user.email).to eq 'john@example.com'
  end
end
