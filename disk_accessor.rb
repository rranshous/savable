require 'timeout'

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

  def disk_based_lock file_key, session_key='0', timeout=2, &block
    lock_file_path = File.join '/tmp/', session_key, file_key
    unless File.exist? lock_file_path
      FileUtils.mkdir_p File.dirname lock_file_path
      FileUtils.touch lock_file_path
    end
    File.open(lock_file_path, 'w') do |fh|
      begin
        Timeout::timeout(timeout) do
          fh.flock File::LOCK_EX
          block.call
        end
      ensure
        fh.flock File::LOCK_UN
      end
    end
  end

end
