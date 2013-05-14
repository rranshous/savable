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
end

describe Savable do

  it "does simple blob saves / loads" do
    s = Master.new
    s.name = 'testfile'
    s.data = 'test content'
    s.root_save_path = '/tmp/'
    s.save
    expect(File.exist?('/tmp/testfile.blob')).to eq true
    expect(File.open('/tmp/testfile.blob').read).to eq 'test content'
    s2 = Master.new
    s2.name = 'testfile'
    s2.root_save_path = '/tmp/'
    s2.load
    expect(s2.data).to eq 'test content'
  end

  it "does meta data saves" do
    s = Master.new
    s.root_save_path = '/tmp/'
    s.name = 'testfile2'
    s['success'] = :true
    s.save
    s2 = Master.new
    s2.root_save_path = '/tmp/'
    s2.name = 'testfile2'
    s2.load
    expect(s2['success']).to eq :true
  end

end
