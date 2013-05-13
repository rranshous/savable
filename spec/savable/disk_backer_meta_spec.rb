require_relative '../../app.rb'

describe Savable do

  let(:base) { Savable::Base.new }
  let(:named_backer) { base.extend(Savable::NamedBacker) }
  let(:disk_backer) { named_backer.extend(Savable::DiskBacker) }
  let(:disk_backer_meta) { disk_backer.extend(Savable::DiskBacker::Meta) }

  describe Savable::DiskBacker::Meta do

    it "has a root save path" do
      expect(disk_backer_meta).to respond_to :disk_meta_save_root_path
    end

    it "has a default save path" do
      expect(disk_backer_meta.disk_meta_save_root_path).to eq './data/'
    end

    it "can set it's default save path" do
      disk_backer_meta.disk_meta_save_root_path = './mydata'
      expect(disk_backer_meta.disk_meta_save_root_path).to eq './mydata'
    end

    it "has data save path" do
      expect(disk_backer_meta).to respond_to :disk_meta_save_path
    end

    it "generates save path from name and base path" do
      disk_backer_meta.name = 'test.txt'
      expect(disk_backer_meta.disk_meta_save_path).to eq './data/test.txt.meta'
    end

    it "knows when it saved last" do
      expect(disk_backer_meta.last_meta_load).to eq nil
    end

    it "knows when it loaded last" do
      expect(disk_backer_meta.last_meta_save).to eq nil
    end

    it "does not raise error if could not load data" do
      disk_backer_meta.name = 'nonexistantfile'
      def disk_backer_meta._disk_meta_load
        disk_meta_load
      end
      expect{ disk_backer_meta._disk_meta_load }.to raise_error
    end

    it "raises error if could not save data" do
      disk_backer_meta.name = '../../../../../../../../nothere'
      expect{ disk_backer_meta.disk_meta_save }.to raise_error
    end

    it "updates last load timestamp when loaded" do
      disk_backer_meta.name = 'test'
      def disk_backer_meta.disk_read_file path
        'data'
      end
      def disk_backer_meta._disk_meta_load
        disk_meta_load
      end
      disk_backer_meta._disk_meta_load
      expect(disk_backer_meta.last_meta_load.class).to eq Time
    end

    it "updates last save timestamp when saved" do
      disk_backer_meta.name = 'test'
      disk_backer_meta.data = 'test_data'
      def disk_backer_meta.disk_write_file path, data
        'data'
      end
      def disk_backer_meta._disk_meta_save
        disk_meta_save
      end
      def disk_backer_meta.meta_data
        {}
      end
      disk_backer_meta._disk_meta_save
      expect(disk_backer_meta.last_meta_save.class).to eq Time
    end

    it "saves data by name" do
      disk_backer_meta.name = 'test_object.txt'
      disk_backer_meta.data = 'my_data'
      save_path = nil
      def disk_backer_meta.disk_write_file path, data
        @save_path = path
      end
      def disk_backer_meta.save_path
        @save_path
      end
      def disk_backer_meta._disk_meta_save
        disk_meta_save
      end
      def disk_backer_meta.meta_data
        {}
      end
      disk_backer_meta._disk_meta_save
      expect(disk_backer_meta.save_path).to eq './data/test_object.txt.meta'
    end

    it "loads data by name" do
      disk_backer_meta.name = 'test_object.txt'
      disk_backer_meta.data = 'my_data'
      save_path = nil
      def disk_backer_meta.disk_read_file path
        @save_path = path
      end
      def disk_backer_meta.save_path
        @save_path
      end
      def disk_backer_meta._disk_meta_load
        disk_meta_load
      end
      def disk_backer_meta.meta_data
      end
      disk_backer_meta._disk_meta_load
      expect(disk_backer_meta.save_path).to eq './data/test_object.txt.meta'
    end


  end

end
