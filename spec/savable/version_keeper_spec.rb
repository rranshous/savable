require_relative '../base'

describe Savable::VersionKeeper do
  
  let(:version_keeper) { Class.new.new.extend(Savable::VersionKeeper) }

  describe "#versioned_name" do

    it "has accessor" do
      expect(version_keeper).to respond_to :versioned_name
    end

    it "does not have setter" do
      expect(version_keeper).not_to respond_to :versioned_name=
    end

    it "raises error if you don't provide a name" do
      expect{ version_keeper.versioned_name }.to raise_error
    end

    it "raises error if you don't provide current version" do
      expect{ version_keeper.versioned_name }.to raise_error
    end

    it "succeeds if it has a version and a name" do
      def version_keeper.file_name
        'testname'
      end
      def version_keeper.current_version
        'testversion'
      end
      expect{ version_keeper.versioned_name }.not_to raise_error
    end

    it "bases the versioned name off the name" do
      def version_keeper.file_name
        'testname'
      end
      def version_keeper.current_version
        'testversion'
      end
      expect(version_keeper.versioned_name['testname']).not_to eq nil
    end

    it "includes current_version in versioned name" do
      def version_keeper.file_name
        'testname'
      end
      def version_keeper.current_version
        'test_version'
      end
      versioned_name = version_keeper.versioned_name
      expect(versioned_name['test_version']).not_to eq nil
    end
  end

  describe "#current_version" do

    it "provides getter for current version" do
      expect(version_keeper).to respond_to :current_version
    end

    it "provides setter for current version" do
      expect(version_keeper).to respond_to :current_version=
    end

    it "keeps track of it's current version" do
      version_keeper.current_version = "testversion"
      expect(version_keeper.current_version).to eq "testversion"
    end

    it "only takes strings as versions" do
      expect { version_keeper.current_version = :test_version }.to raise_error
    end
  end

  describe "#get_version_from_file_name" do

    it "gets version from versioned name" do
      version_keeper.current_version = 'version1'
      def version_keeper.file_name
        'myfile!'
      end
      version_name = version_keeper.versioned_name
      version = version_keeper.get_version_from_file_name version_name
      expect(version).to eq 'version1'
    end

    it "gets version from versioned path" do
      version_keeper.current_version = 'version1'
      def version_keeper.file_name
        'myfile!'
      end
      version_name = version_keeper.versioned_name
      version_path = File.join '/tmp/', "#{version_name}.ext"
      version = version_keeper.get_version_from_file_name version_path
      expect(version).to eq 'version1'
    end
  end

end
