require_relative '../app.rb'

class Master < Savable::Base
  include Savable::NamedBacker
  include Savable::DiskBacker
  include Savable::DiskBacker::Serializor
  include Savable::MetaKeeper
  include Savable::DiskBacker::Meta
  include DiskAccessor

  def save
    disk_save
    disk_meta_save
  end

  def load
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

end

class MasterVersioned < Master

  include Savable::VersionKeeper

  def disk_save_name
    versioned_name
  end

  def disk_meta_save_name
    versioned_name
  end


  def save
    self.current_version = Time.now.to_f
    super
  end

  def load
    if current_version.nil?
      # we need to figure out what the last version was
      latest = find_latest_version
      raise "No previous version found" if latest.nil?
      self.current_version = latest
    end
    super
  end

  private

  def find_latest_version
    Dir.glob("#{disk_meta_save_root_path}/*.#{meta_file_extension}")
    .map { |path| get_version_from_file_name File.basename path }
    .compact
    .sort_by { |v| v.to_f }
    .last
  end

end

describe Savable do

  before(:each) do
    `rm -rf /tmp/_test`
    `mkdir /tmp/_test`
  end

  it "does simple blob saves / loads" do
    s = Master.new
    s.file_name = 'testfile'
    s.data = 'test content'
    s.root_save_path = '/tmp/_test/'
    s.save
    expect(File.exist?('/tmp/_test/testfile.blob')).to eq true
    expect(File.open('/tmp/_test/testfile.blob').read).to eq 'test content'
    s2 = Master.new
    s2.file_name = 'testfile'
    s2.root_save_path = '/tmp/_test/'
    s2.load
    expect(s2.data).to eq 'test content'
  end

  it "does meta data saves / loads" do
    s = Master.new
    s.root_save_path = '/tmp/_test/'
    s.file_name = 'testfile2'
    s['success'] = :true
    s.save
    s2 = Master.new
    s2.root_save_path = '/tmp/_test/'
    s2.file_name = 'testfile2'
    s2.load
    expect(s2['success']).to eq :true
  end

  it "updates versions" do
    s = MasterVersioned.new
    s.root_save_path = '/tmp/_test/'
    s.file_name = 'testfile3'
    s.data = 'testdata'
    s.save
    first_version = s.current_version
    s.root_save_path = '/tmp/_test/'
    s.data = 'testdata2'
    s.save
    expect(s.current_version).not_to eq first_version
  end

  it "loads previous versions data" do
    s = MasterVersioned.new
    s.root_save_path = '/tmp/_test/'
    s.file_name = 'testfile3'
    s.data = 'testdata'
    s.save
    s2 = MasterVersioned.new
    s2.root_save_path = '/tmp/_test/'
    s2.file_name = 'testfile3'
    s2.load
    expect(s2.data).to eq 'testdata'
  end

  it "updates it's current version after load" do
    s = MasterVersioned.new
    s.root_save_path = '/tmp/_test/'
    s.file_name = 'testfile3'
    s.data = 'testdata'
    s.save
    s2 = MasterVersioned.new
    s2.root_save_path = '/tmp/_test/'
    s2.file_name = 'testfile3'
    s2.load
    expect(s2.current_version).to eq s.current_version
  end

end
