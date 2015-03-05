# Testing main app file app.rb

require File.expand_path '../spec_helper.rb', __FILE__

# Test getting pages
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

# Test all functionalities of trackers.
describe "the life of a tracker" do
  before(:all) do
    post '/new/:state', params = { cc_name: 'Neeru Rathod' }
    post '/new/:state', params = { cc_name: 'Indu Devi' }
    post '/flag/BH_1001', params = { note: 'Production' }
  end

  it "should be created with a state" do
    post '/new/state', params = { state: 'Goa' }
    expect(last_response.body).to include('Goa')
  end

  it "should be saved" do
    post '/new/:state', params = { cc_name: 'Devidas Gaonkar' }
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).to include('Devidas Gaonkar')
    expect(last_response.body).to include('Story successfully saved as GO_1001.')
  end

  it "should be viewable" do
    get '/show/GO_1001'
    expect(last_response.status).to eq 200
  end

  it "should be editable" do
    get '/edit/GO_1001'
    expect(last_response.status).to eq 200
    post '/edit/GO_1001'
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).to include('Tracker GO_1001 successfully edited.')
  end

  it "should be flagged" do
    get '/flag/GO_1001'
    post '/flag/GO_1001', params = { note: 'State Coordinator' }
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).to include('State Coordinator')
    expect(last_response.body).to include('Flag successfully added to GO_1001.')
  end

  it "should be unflagged" do
    get '/unflag/GO_1001'
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).not_to include('State Coordinator')
    expect(last_response.body).to include('GO_1001 successfully unflagged.')
  end

  it "should have a note added" do
    post '/note', params = { uid: 'GO_1001', note: 'test' }
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

# Test error messages given by sinatra-flash.
describe "error messages" do
  it "should appear if no state is chosen" do
    post '/new/state', params = { state: '' }
    expect(last_response.status).to eq 302
    get '/new'
    expect(last_response.body).to include('A state must be selected.')
  end

  it "should appear if no cc is selected" do
    post '/new/:state', params = { cc_name: '' }
    expect(last_response.status).to eq 307
    get '/new'
    expect(last_response.body).to include('A CC must be selected.')
  end

  it "should appear if not enough operations are chosen for search queries" do
    post '/search/custom', params = { chain_1: 'AND', column1: 'flag' }
    expect(last_response.status).to eq 302
    get '/search'
    expect(last_response.body).to include('Need enough AND\'s or OR\'s for multiple criteria.')
  end

  it "should appear if the uid doesn't exist" do
    get '/show/nil'
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).to include('Could not find story to show.')
  end

  it "should appear if the uid doesn't exist" do
    get '/delete/nil'
    expect(last_response.status).to eq 302
    get '/recent'
    expect(last_response.body).to include('Could not find story to delete.')
  end

  it "should appear if the flag note is blank" do
    post '/flag/GJ_1001', params = { note: '' }
    expect(last_response.status).to eq 302
    get '/flag/GJ_1001'
    expect(last_response.body).to include('Need information for flag.')
  end

  it "should appear if no UID is entered for a note" do
    post '/note', params = { uid: '', note: 'example' }
    expect(last_response.status).to eq 302
    get '/note'
    expect(last_response.body).to include('UID needed.')
  end

  it "should appear if no note is entered" do
    post '/note', params = { uid: 'nil', note: '' }
    expect(last_response.status).to eq 302
    get '/note'
    expect(last_response.body).to include('A note is needed.')
  end

  it "should appear if an invalid UID is entered for a note" do
    post '/note', params = { uid: 'nil', note: 'example' }
    expect(last_response.status).to eq 302
    get '/note'
    expect(last_response.body).to include('Invalid UID.')
  end
end

# Test the custom searches
describe "searching" do
  it "should work when there are enough operators per queries" do
    post '/search/custom', params = { chain_1: 'AND', column1: 'flag',
                                      operator_1: 'IS', column2: 'cc_name',
                                      operator_2: 'IS' }
    expect(last_response.status).to eq 302
    get 'results'
    expect(last_response.body).not_to include('priority')
  end

  it "should work with one query and no AND/OR operator" do
    post '/search/custom', params = { column1: 'flag', operator_1: 'IS' }
    expect(last_response.status).to eq 302
    get 'results'
    expect(last_response.body).not_to include('priority')
  end

  it "should not work when there are too many AND/OR operators" do
    post '/search/custom', params = { chain_1: 'AND', column1: 'flag',
                                      operator_1: 'IS', column2: 'cc_name',
                                      operator_2: 'IS', chain_2: 'OR' }
    expect(last_response.status).to eq 302
    get '/search'
    expect(last_response.body).to include('Need enough AND\'s or OR\'s for multiple criteria.')
  end

  it "should not work if there are not enough AND/OR operators" do
    post '/search/custom', params = { column1: 'flag', operator_1: 'IS',
                                      column2: 'cc_name', operator_2: 'IS' }
    expect(last_response.status).to eq 302
    get '/search'
    expect(last_response.body).to include('Need enough AND\'s or OR\'s for multiple criteria.')
  end

  after (:all) do
    get '/delete/BH_1001'
    get '/delete/GJ_1001'
  end
end
