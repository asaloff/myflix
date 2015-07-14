require 'spec_helper'

describe Video do
  it "should save itself" do
    video = Video.new(title: "new_vid", description: "This is a great video!")
    video.save
    expect(Video.first).to eq(video)
  end

  it "belongs to a category" do
    drama = Category.create(title: "Drama")
    monk = Video.create(title: "Monk", description: "This video belongs to drama", category: drama)
    expect(monk.category).to eq(drama)
  end

  it "does not save without a title" do
    monk = Video.create(description: "a show without a title")
    expect(Video.count).to eq(0)
  end

  it "does not save without a description" do
    monk = Video.create(title: "monk")
    expect(Video.count).to eq(0)
  end
end