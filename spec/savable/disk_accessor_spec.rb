require_relative '../../app.rb'

describe DiskAccessor do

  let(:disk_accessor) { Class.new.new.extend(DiskAccessor) }

  before(:each) do
    File.unlink('/tmp/test.file') rescue nil
    File.open('/tmp/test2.file', 'w') do |fh| 
      fh.write('testing')
    end
  end

  it "writes to disk by path" do
    disk_accessor.disk_write_file('/tmp/test.file', 'test_value')
    expect(File.exist?('/tmp/test.file')).to(eq(true))
  end

  it "write given data to disk" do
    disk_accessor.disk_write_file('/tmp/test.file', 'test_value')
    expect(File.read('/tmp/test.file')).to(eq('test_value'))
  end

  it "reads from disk by path" do
    expect(disk_accessor.disk_read_file('/tmp/test2.file')).to(eq('testing'))
  end

end
