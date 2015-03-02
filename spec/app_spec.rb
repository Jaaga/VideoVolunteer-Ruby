require File.expand_path '../spec_helper.rb', __FILE__

describe "app.rb" do
  it "should get /" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should get /new" do
    get '/new'
    expect(last_response).to be_ok
  end

  it "should get /view" do
    get '/view'
    expect(last_response).to be_ok
  end

  it "should get /recent" do
    get '/recent'
    expect(last_response).to be_ok
  end

  it "should get /search" do
    get '/search'
    expect(last_response).to be_ok
  end

  it "should get /note" do
    get '/note'
    expect(last_response).to be_ok
  end
end

describe "the life of a tracker" do
  it "should be created with a state" do
    post '/new/state', params = { state: 'Goa' }
    expect(last_response.body).to include('Goa')
  end

  it "should be saved" do
    post '/new', params = { cc_name: 'Devidas Gaonkar' }
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).to include('Devidas Gaonkar')
    expect(last_response.body).to include('Story successfully saved as GO_1001.')
  end

  it "should be flagged" do
    get '/flag/GO_1001'
    post '/flag/GO_1001', params = { note: 'State Coordinator' }
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).to include('priority')
    expect(last_response.body).to include('Flag successfully added to GO_1001.')
  end

  it "should be unflagged" do
    get '/unflag/GO_1001'
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).not_to include('priority')
    expect(last_response.body).to include('GO_1001 successfully unflagged.')
  end

  it "should have a note added" do
    post '/note', params = {uid: 'GO_1001', note: 'test'}
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).to include('Note successfully added to GO_1001.')
  end

  it "should be deleted" do
    get '/delete/GO_1001'
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).not_to include('Devidas Gaonkar')
    expect(last_response.body).to include('GO_1001 successfully deleted.')
  end
end
