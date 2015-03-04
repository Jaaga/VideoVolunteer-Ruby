require File.expand_path '../spec_helper.rb', __FILE__

describe "Array setting" do
  it "should return a hash with ten keys" do
    all = array_set
    expect(all).to include(:story)
    expect(all).to include(:status)
    expect(all).to include(:footage)
    expect(all).to include(:impact)
    expect(all).to include(:screening)
    expect(all).to include(:ratings)
    expect(all).to include(:extra)
    expect(all).to include(:yesno)
    expect(all).to include(:numbers)
    expect(all).to include(:special)
  end

  it "should return a hash with non-empty arrays" do
    all = array_set
    all.each do |x|
      expect(x).not_to be_empty()
    end
  end
end
