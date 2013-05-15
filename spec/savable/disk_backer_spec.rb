require_relative '../base'

describe Savable do

  describe Savable::DiskBacker do

    let(:base) { Savable::Base.new }
    let(:named_backer) {
      Savable::Base.instance_eval do
        extend(Savable::NamedBacker)
        self
      end.new
    }
    let(:disk_backer_cls) {
      Savable::Base.instance_eval do
        include(Savable::NamedBacker)
        include(Savable::DiskBacker)
        self
      end
    }
    let(:disk_backer) {
      disk_backer_cls.new
    }


    it "has a file extension" do
      expect(disk_backer.file_extension).not_to eq nil
    end

    it "has a root save path" do
      expect(disk_backer).to respond_to :disk_save_root_path
    end

    it "has a default save path" do
      expect(disk_backer.disk_save_root_path).to eq './data/'
    end

    it "can set it's default save path" do
      disk_backer.disk_save_root_path # test edge
      disk_backer.disk_save_root_path = './mydata'
      expect(disk_backer.disk_save_root_path).to eq './mydata'
    end

    it "has data save path" do
      expect(disk_backer).to respond_to :disk_save_path
    end

    it "generated save name from file name" do
      def disk_backer.file_name
        'test.txt'
      end
      expect(disk_backer.disk_save_name).to eq 'test.txt'
    end

    it "generates save path from name and base path" do
      def disk_backer.file_name
        'test.txt'
      end
      expect(disk_backer.disk_save_path).to eq './data/test.txt.blob'
    end

    it "knows when it saved last" do
      expect(disk_backer.last_load).to eq nil
    end

    it "knows when it loaded last" do
      expect(disk_backer.last_save).to eq nil
    end

    it "raises error if could not load data" do
      def disk_backer._disk_load
        disk_load
      end
      def disk_backer.file_name
        'nothinghere'
      end
      expect{ disk_backer._disk_load }.to raise_error
    end

    it "raises error if could not save data" do
      def disk_backer.file_name
        'nothinghere'
      end
      expect{ disk_backer.disk_save }.to raise_error
    end

    it "updates last load timestamp when loaded" do
      def disk_backer.file_name
        'test'
      end
      def disk_backer.disk_read_file path
        'data'
      end
      def disk_backer._disk_load
        disk_load
      end
      disk_backer._disk_load
      expect(disk_backer.last_load.class).to eq Time
    end

    it "updates last save timestamp when saved" do
      def disk_backer.file_name
        'test'
      end
      disk_backer.data = 'test_data'
      def disk_backer.disk_write_file path, data
        'data'
      end
      def disk_backer._disk_save
        disk_save
      end
      disk_backer._disk_save
      expect(disk_backer.last_save.class).to eq Time
    end

    it "saves data by name" do
      def disk_backer.file_name
        'test_object.txt'
      end
      disk_backer.data = 'my_data'
      def disk_backer.disk_write_file path, data
        @save_path = path
      end
      def disk_backer.save_path
        @save_path
      end
      def disk_backer._disk_save
        disk_save
      end
      disk_backer._disk_save
      expect(disk_backer.save_path).to eq './data/test_object.txt.blob'
    end

    it "loads data by name" do
      def disk_backer.file_name
        'test_object.txt'
      end
      disk_backer.data = 'my_data'
      def disk_backer.disk_read_file path
        @save_path = path
      end
      def disk_backer.save_path
        @save_path
      end
      def disk_backer._disk_load
        disk_load
      end
      disk_backer._disk_load
      expect(disk_backer.save_path).to eq './data/test_object.txt.blob'
    end

    it "does not leak default save path between instances" do
      d1 = disk_backer_cls.new
      d2 = disk_backer_cls.new
      d1.disk_save_root_path = 'tmp'
      expect(d2.disk_save_root_path).not_to eq 'tmp'
    end

  end
end
