require_relative '../app.rb'

class Master < Savable::Base
  include Savable::NamedBacker
  include Savable::DiskBacker
  include Savable::DiskBacker::Serializor
  include Savable::MetaKeeper
  include Savable::DiskBacker::Meta
  include DiskAccessor
  include Savable::VersionKeeper

  def save
    self.current_version = Time.now.to_f
    disk_save
    disk_meta_save
  end

  def load
    if current_version.nil?
      # we need to figure out what the last version was
      latest = find_latest_version
      raise "No previous version found" if latest.nil?
      self.current_version = lastest
    end
    disk_load
    disk_meta_load
  end

  def root_save_path= new_root
    self.disk_save_root_path = new_root
    self.disk_meta_save_root_path = new_root
  end

  def name
    file_name
  end

  def disk_save_name
    versioned_name
  end

  def disk_meta_save_name
    versioned_name
  end

  private

  def find_latest_version
    Dir.glob("#{disk_meta_save_root_path}/*.#{meta_file_extension}")
    .map { |path| get_version_from_file_name File.basename path }
    .sort
    .last
  end


end

describe Savable do

  it "does simple blob saves / loads" do
    s = Master.new
    s.file_name = 'testfile'
    s.data = 'test content'
    s.root_save_path = '/tmp/'
    s.save
    expect(File.exist?('/tmp/testfile.blob')).to eq true
    expect(File.open('/tmp/testfile.blob').read).to eq 'test content'
    s2 = Master.new
    s2.file_name = 'testfile'
    s2.root_save_path = '/tmp/'
    s2.load
    expect(s2.data).to eq 'test content'
  end

  it "does meta data saves / loads" do
    s = Master.new
    s.root_save_path = '/tmp/'
    s.file_name = 'testfile2'
    s['success'] = :true
    s.save
    s2 = Master.new
    s2.root_save_path = '/tmp/'
    s2.file_name = 'testfile2'
    s2.load
    expect(s2['success']).to eq :true
  end

  it "updates versions" do
    s = Master.new
    s.root_save_path = '/tmp/'
    s.file_name = 'testfile3'
    s.data = 'testdata'
    s.save
    first_version = s.current_version
    s.root_save_path = '/tmp/'
    s.data = 'testdata2'
    s.save
    expect(s.current_version).not_to eq first_version
  end

end
