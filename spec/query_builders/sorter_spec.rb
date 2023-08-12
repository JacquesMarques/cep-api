# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sorter do

  let(:first_user) { create(:user) }
  let(:second_user) { create(:admin) }
  let(:third_user) { create(:other_user) }
  let(:users) { [first_user, second_user, third_user] }

  let(:scope) { User.all }
  let(:params) { HashWithIndifferentAccess.new({ sort: 'id', dir: 'desc' }) }
  let(:sorter) { Sorter.new(scope, params) }
  let(:sorted) { sorter.sort }

  before do
    allow(UserPresenter).to(
      receive(:sort_attributes).and_return(['id', 'title'])
    )
    users
  end

  describe '#sort' do
    context 'without any parameters' do
      let(:params) { {} }
      it 'returns the scope unchanged' do
        expect(sorted).to eq scope
      end
    end

    context 'with valid parameters' do
      it 'sorts the collection by "id desc"' do
        expect(sorted.first.id).to eq third_user.id
        expect(sorted.last.id).to eq first_user.id
      end

      it 'sorts the collection by "title asc"' do
        expect(sorted.first).to eq third_user
        expect(sorted.last).to eq first_user
      end
    end

    context 'with invalid parameters' do
      let(:params) { HashWithIndifferentAccess.new({ sort: 'fid', dir: 'desc' }) }
      it 'raises a QueryBuilderError exception' do
        expect { sorted }.to raise_error(QueryBuilderError)
      end
    end
  end


end