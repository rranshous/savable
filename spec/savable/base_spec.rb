require_relative '../base'

describe Savable do

  let(:base) { Savable::Base.new }

  describe Savable::Base do

    it "has data" do
      expect(base.data).to eq nil
    end

    it "updates it's data" do
      base.data = 1
      expect(base.data).to eq 1
    end

  end
end
