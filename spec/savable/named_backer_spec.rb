require_relative '../../app.rb'

describe Savable do

  let(:base) { Savable::Base.new }
  let(:named_backer) { base.extend(Savable::NamedBacker) }

  describe Savable::NamedBacker do
  
    it "has name" do
      expect(named_backer.name).to eq nil
    end

    it "sets it's name" do
      named_backer.name = 'test'
      expect(named_backer.name).to eq 'test'
    end

  end
end
