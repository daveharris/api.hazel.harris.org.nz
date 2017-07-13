require 'rails_helper.rb'

describe 'POST /api/import' do
  let(:cloudmailin_params) { JSON.parse(File.read('spec/support/import/cloudmailin-request.json')) }

  it 'responds with import statistics' do
    expect { post '/api/import', params: cloudmailin_params }.to change { Feeding.count }

    response_body = JSON.parse(response.body)
    expect(response_body.dig('feedings', 'num_inserts')).to eq 1

    # Store UTF-8 data
    expect(Feeding.where(description: 'トスト')).to exist
  end
end
