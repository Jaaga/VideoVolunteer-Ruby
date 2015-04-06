# Testing for features.rb

require File.expand_path '../spec_helper.rb', __FILE__

# Test all methods in features.rb
describe "features.rb" do
  before(:all) do
    post '/login', email: 'bob@bob.bob', password: 'bobbob'
    post '/new/Gujarat', params = { cc_name: 'Neeru Rathod', original_uid: '' }
  end

  it "should split and capitalize column names" do
    expect(name_modifier('test_spec')).to eq('Test Spec')
  end

  it "should generate uid for new state" do
    expect(uid_generate([], 'AA', '')).to eq('AA_1001')
  end

  it "should generate uid for existing state" do
    temp = Tracker.where(state: 'Gujarat')
    expect(uid_generate(temp, 'GJ', '')).to eq('GJ_1002')
  end

  after (:all) do
    get '/delete/GJ_1001'
  end
end
