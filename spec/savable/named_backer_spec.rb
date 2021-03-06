require_relative '../base'

describe Savable do

  let(:base) { Savable::Base.new }
  let(:named_backer) { base.extend(Savable::NamedBacker) }

  describe Savable::NamedBacker do
  
    it "has file name" do
      expect(named_backer.file_name).to eq nil
    end

    it "sets it's file name" do
      named_backer.file_name = 'test'
      expect(named_backer.file_name).to eq 'test'
    end

  end
end
