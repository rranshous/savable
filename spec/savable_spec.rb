require_relative 'base'

describe Savable::Savable do

  before(:each) do
    `rm -rf /tmp/_test`
    `mkdir /tmp/_test`
  end

  it "does simple blob saves / loads" do
    s = Savable::Savable.new
    s.file_name = 'testfile'
    s.data = 'test content'
    s.root_save_path = '/tmp/_test/'
    s.save
    expect(File.exist?('/tmp/_test/testfile.blob')).to eq true
    expect(File.open('/tmp/_test/testfile.blob').read).to eq 'test content'
    s2 = Savable::Savable.new
    s2.file_name = 'testfile'
    s2.root_save_path = '/tmp/_test/'
    s2.load
    expect(s2.data).to eq 'test content'
  end

  it "does meta data saves / loads" do
    s = Savable::Savable.new
    s.root_save_path = '/tmp/_test/'
    s.file_name = 'testfile2'
    s['success'] = :true
    s.save
    s2 = Savable::Savable.new
    s2.root_save_path = '/tmp/_test/'
    s2.file_name = 'testfile2'
    s2.load
    expect(s2['success']).to eq :true
  end

  it "updates versions" do
    s = Savable::SavableVersioned.new
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
    s = Savable::SavableVersioned.new
    s.root_save_path = '/tmp/_test/'
    s.file_name = 'testfile3'
    s.data = 'testdata'
    s.save
    s2 = Savable::SavableVersioned.new
    s2.root_save_path = '/tmp/_test/'
    s2.file_name = 'testfile3'
    s2.load
    expect(s2.data).to eq 'testdata'
  end

  it "updates it's current version after load" do
    s = Savable::SavableVersioned.new
    s.root_save_path = '/tmp/_test/'
    s.file_name = 'testfile3'
    s.data = 'testdata'
    s.save
    s2 = Savable::SavableVersioned.new
    s2.root_save_path = '/tmp/_test/'
    s2.file_name = 'testfile3'
    s2.load
    expect(s2.current_version).to eq s.current_version
  end

  it "keeps a symbolic link to the newest version" do
    s = Savable::SavableVersioned.new
    s.root_save_path = '/tmp/_test/'
    s.file_name = 'testfile3'
    s.data = 'testdata'
    s.save
    symbolic_path = '/tmp/_test/testfile3.blob'
    expect(File.exist? symbolic_path).to eq true
    expect(File.open(symbolic_path).read).to eq 'testdata'
    s2 = Savable::SavableVersioned.new
    s2.root_save_path = '/tmp/_test/'
    s2.file_name = 'testfile3'
    s2.data = 'testdata2'
    s2.save
    expect(File.exist? symbolic_path).to eq true
    expect(File.open(symbolic_path).read).to eq 'testdata2'
  end

end
