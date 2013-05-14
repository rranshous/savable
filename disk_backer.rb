module Savable

  module DiskBacker

    def file_extension
      'blob'
    end

    def disk_save_root_path
      @disk_save_root_path || default_disk_save_root_path
    end

    def disk_save_root_path= new_path
      @disk_save_root_path = new_path
    end

    def disk_save_path
      raise "Missing file name method" unless self.respond_to? :file_name
      raise "Missing required file name" if file_name.nil?
      File.join disk_save_root_path, "#{disk_save_name}.#{file_extension}"
    end

    def disk_save_name
      file_name
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
      raise "File name must be set before save" if file_name.nil?
      disk_write_file disk_save_path, data
      self.last_save = Time.now
    end

    def disk_load
      raise "File name must be set before load" if file_name.nil?
      self.data = disk_read_file disk_save_path
      self.last_load = Time.now
      self.data
    end

    def last_load= when_loaded
      @last_load = when_loaded
    end

    def last_save= last_save
      @last_save = last_save
    end
  end
end
