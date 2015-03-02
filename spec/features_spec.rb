require File.expand_path '../spec_helper.rb', __FILE__

describe "features.rb" do

  it "should split and capitalize column names" do
    expect(name_modifier('test_spec')).to eq('Test Spec')
  end

  it "should generate uid for new state" do
    expect(uid_generate([], 'JK')).to eq('JK_1001')
  end

  it "should generate uid for existing state" do
    temp = Tracker.all
    expect(uid_generate(temp, 'GJ')).to include('GJ_1003')
  end
end
