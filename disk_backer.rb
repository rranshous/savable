module Savable

  module DiskBacker

    def file_extension
      'blob'
    end

    def disk_save_root_path
      @disk_save_root_path ||= default_disk_save_root_path
    end

    def disk_save_root_path= new_path
      @disk_save_root_path = new_path
    end

    def disk_save_path
      File.join disk_save_root_path, "#{name}.#{file_extension}"
    end

    def last_save
      @last_save
    end

    def last_load
      @last_load
    end

    private

    def default_disk_save_root_path
      './data/'
    end

    def disk_save
      raise "Name must be set before save" if name.nil?
      disk_write_file disk_save_path, data
      self.last_save = Time.now
    end

    def disk_load
      raise "Name must be set before load" if name.nil?
      data = disk_read_file disk_save_path
      self.last_load = Time.now
      data
    end

    def disk_read_file path
      File.open path, 'r' do |fh|
        fh.read
      end
    end

    def disk_write_file path, data
      File.open disk_save_path, 'w' do |fh|
        fh.write data
      end
    end

    def last_load= when_loaded
      @last_load = when_loaded
    end

    def last_save= last_save
      @last_save = last_save
    end
  end
end