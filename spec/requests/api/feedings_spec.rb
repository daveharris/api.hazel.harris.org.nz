require 'rails_helper.rb'

describe 'GET /api/bottles' do
  let(:import_request) { JSON.parse(File.read('spec/support/import/cloudmailin-feeding-request.json')) }

  before(:each) do
    post '/api/import', params: import_request
  end

  it 'responds with bottle statistics' do
    get '/api/bottles'

    response_body = JSON.parse(response.body)
    expect(response_body['count']).to eq 4
    expect(response_body['avg_amount']).to eq 78

    expect(response_body.dig('count_per_month',      '2017-06-01')).to eq 4
    expect(response_body.dig('sum_amount_per_month', '2017-06-01')).to eq 310
  end
end
