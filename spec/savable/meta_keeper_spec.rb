require_relative '../base'

describe Savable do

  let(:base) { Savable::Base.new }
  let(:meta_keeper) { base.extend(Savable::MetaKeeper) }

  describe Savable::MetaKeeper do

    it "allows access to meta data" do
      expect(meta_keeper['test']).to eq nil
    end

    it "allows changing the meta data" do
      expect{ meta_keeper['test'] = 'success' }.to_not raise_error
    end

    it "keeps changes to meta data" do
      meta_keeper['test'] = 'success'
      expect(meta_keeper['test']).to eq 'success'
    end

    it "allows access to lookup of meta data" do
      meta_keeper['test'] = 'success'
      expect(meta_keeper.meta_data).to eq({'test'=>'success'})
    end

  end
end
