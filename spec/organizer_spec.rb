require 'spec_helper'

RSpec.describe Organizer do
  let(:organizer) { Organizer.new }
  let(:account) { { access_token: 'S3CR3T!' } }
  describe '#organize' do
    before do
      Dependencies.stub('putio', putio)
    end
    after do
      Dependencies.unstub('putio')
    end

    let(:putio) do
      double(:putio).tap do |d|
        expect(d).to receive(:list_files).and_return([])
        expect(d).to receive(:create_folder).and_return({})
        expect(d).to receive(:list_completed_transfers).and_return([])
      end
    end

    it 'works' do
      organizer.organize(account)
    end
  end
end
