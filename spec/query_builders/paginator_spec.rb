# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Paginator do

  let(:first_user) { create(:user) }
  let(:second_user) { create(:admin) }
  let(:third_user) { create(:other_user) }
  let(:users) { [first_user, second_user, third_user] }

  let(:scope) { User.all }
  let(:params) { { 'page' => '1', 'per' => '2' } }
  let(:paginator) { Paginator.new(scope, params, 'url') }
  let(:paginated) { paginator.paginate }

  before do
    users
  end

  describe '#paginate' do
    it 'paginates the collection with 2 users' do
      expect(paginated.size).to eq 2
    end

    it 'contains first_product as the first paginated item' do
      expect(paginated.first).to eq first_user
    end

    it 'contains product_two as the last paginated item' do
      expect(paginated.last).to eq second_user
    end
  end

  describe '#links' do
    let(:links) { paginator.links.split(', ') }

    context 'when first page' do
      let(:params) { { 'page' => '1', 'per' => '2' } }

      it 'builds the "next" relation link' do
        expect(links.first).to eq '<url?page=2&per=2>; rel="next"'
      end

      it 'builds the "last" relation link' do
        expect(links.last).to eq '<url?page=2&per=2>; rel="last"'
      end
    end

    context 'when last page' do
      let(:params) { { 'page' => '2', 'per' => '2' } }

      it 'builds the "first" relation link' do
        expect(links.first).to eq '<url?page=1&per=2>; rel="first"'
      end

      it 'builds the "previous" relation link' do
        expect(links.last).to eq '<url?page=1&per=2>; rel="prev"'
      end
    end
  end
end
