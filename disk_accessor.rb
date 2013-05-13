module DiskAccessor

  def disk_read_file path
    File.open path, 'r' do |fh|
      fh.read
    end
  end

  def disk_write_file path, data
    File.open path, 'w' do |fh|
      fh.write data
    end
  end

end
