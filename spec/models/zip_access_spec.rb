require 'rails_helper'

RSpec.describe ZipAccess, type: :model do
  let(:zip_access) { build(:zip_access) }

  it 'has a valid factory' do
    expect(build(:zip_access)).to be_valid
  end

  it { should validate_presence_of(:zipcode) }
end
