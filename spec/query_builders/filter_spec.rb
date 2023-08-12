# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filter do

  let(:first_user) { create(:user) }
  let(:second_user) { create(:admin) }
  let(:third_user) { create(:other_user) }
  let(:users) { [first_user, second_user, third_user] }

  let(:scope) { User.all }
  let(:params) { {} }
  let(:filter) { Filter.new(scope, params) }
  let(:filtered) { filter.filter }

  before do
    allow(UserPresenter).to(
      receive(:filter_attributes).and_return(%w[id email given_name])
    )
    users
  end

  describe '#filter' do
    context 'without any parameters' do
      it 'returns the scope unchanged' do
        expect(filtered).to eq scope
      end
    end
  end

  context 'with valid parameters' do
    context 'with "given_name_eq=John"' do
      let(:params) { { 'q' => { 'given_name_eq' => 'John' } } }

      it 'gets only "John" back' do
        expect(filtered.first.id).to eq first_user.id
        expect(filtered.size).to eq 1
      end
    end

    context 'with "name_cont=Under"' do
      let(:params) { { 'q' => { 'given_name_cont' => 'John' } } }

      it 'gets only "John" back' do
        expect(filtered.first.id).to eq first_user.id
        expect(filtered.size).to eq 1
      end
    end

    context 'with "given_name_notcont=Super"' do
      let(:params) { { 'q' => { 'given_name_notcont' => 'Super' } } }

      it 'not gets "Super" back' do
        expect(filtered.first.id).to eq first_user.id
        expect(filtered.size).to eq 2
      end
    end

    context 'with "given_name_start=John"' do
      let(:params) { { 'q' => { 'given_name_start' => 'John' } } }

      it 'gets only start with "John" back' do
        expect(filtered.size).to eq 1
      end
    end

    context 'with "given_name_end=Other"' do
      let(:params) { { 'q' => { 'given_name_end' => 'Other' } } }

      it 'gets only "User" back' do
        expect(filtered.first).to eq third_user
      end
    end
  end

  context 'with invalid parameters' do
    context 'with invalid column name "fid"' do
      let(:params) { { 'q' => { 'fid_gt' => '2' } } }

      it 'raises a "QueryBuilderError" exception' do
        expect { filtered }.to raise_error(QueryBuilderError)
      end
    end

    context 'with invalid predicate "gtz"' do
      let(:params) { { 'q' => { 'id_gtz' => '2' } } }

      it 'raises a "QueryBuilderError" exception' do
        expect { filtered }.to raise_error(QueryBuilderError)
      end
    end
  end
end