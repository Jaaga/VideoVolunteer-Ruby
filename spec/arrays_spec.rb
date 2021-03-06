# Testing array setter.

require File.expand_path '../spec_helper.rb', __FILE__

describe "Array setting" do
  # Just testing that array_set is correctly setting a hash of arrays.
  it "should return a hash with fifteen keys" do
    all = array_set
    expect(all).to include(:story)
    expect(all).to include(:status)
    expect(all).to include(:footage_edit)
    expect(all).to include(:footage_review)
    expect(all).to include(:review)
    expect(all).to include(:impact_planning)
    expect(all).to include(:impact_achieved)
    expect(all).to include(:impact_video)
    expect(all).to include(:screening)
    expect(all).to include(:payment)
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
