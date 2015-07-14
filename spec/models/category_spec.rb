require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(title: 'Test')
    category.save
    expect(Category.first).to eq(category) 
  end

  it "has many videos" do
    comedy = Category.create(title: 'Comedy')
    south_park = Video.create(title: 'South Park', description: 'funny tv show', category: comedy)
    futurama = Video.create(title: 'Futurama', description: 'funny space tv show', category: comedy)
    expect(comedy.videos).to eq([futurama, south_park])
  end
end