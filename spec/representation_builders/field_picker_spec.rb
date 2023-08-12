require 'rails_helper'

RSpec.describe 'FieldPicker' do
  let(:first_user) { create(:user) }

  # We remove 'subname' here
  let(:params) { { fields: 'id,given_name' } }
  let(:presenter) { UserPresenter.new(first_user, params) }
  let(:field_picker) { FieldPicker.new(presenter) }

  before do
    allow(UserPresenter).to(
      receive(:build_attributes).and_return(%w[id email given_name])
    )
  end

  describe '#pick' do

    # And here, in the test name
    context 'with the "fields" parameter containing "id,given_name"' do

      it 'updates the presenter "data" with the book "id" and "given_name"' do
        expect(field_picker.pick.data).to eq({
                                               'id' => first_user.id,
                                               'given_name' => 'John'
                                             })
      end

      context 'with overriding method defined in presenter' do
        before { presenter.class.send(:define_method, :given_name) { 'Overridden!' } }

        it 'updates the presenter "data" with the name "Overridden!"' do
          expect(field_picker.pick.data).to eq({
                                                 'id' => first_user.id,
                                                 'given_name' => 'Overridden!'
                                               })
        end

        after { presenter.class.send(:remove_method, :given_name) }
      end
    end

    context 'with no "fields" parameter' do
      let(:params) { {} }

      it 'updates "data" with the fields ("id","given_name","email")' do
        expect(field_picker.pick.data).to eq({
                                               'id' => first_user.id,
                                               'given_name' => 'John',
                                               'email' => 'john@example.com'
                                             })
      end
    end

    context 'with invalid attributes "fid"' do
      let(:params) { { fields: 'fid,name' } }

      it 'raises a "RepresentationBuilderError"' do
        expect { field_picker.pick }.to(
          raise_error(RepresentationBuilderError))
      end
    end

    context 'with empty attributes' do
      let(:params) { { fields: '' } }

      it 'updates "data" with the fields ("id","given_name","email")' do
        expect(field_picker.pick.data).to eq({
                                               'id' => first_user.id,
                                               'given_name' => 'John',
                                               'email' => 'john@example.com'
                                             })
      end
    end
  end
end
