module Savable

  module DiskBacker::Meta

    def meta_file_extension
      'meta'
    end

    def disk_meta_save_root_path
      @disk_meta_save_root_path || default_disk_meta_save_root_path
    end

    def disk_meta_save_root_path= new_path
      @disk_meta_save_root_path = new_path
    end

    def disk_meta_save_path
      raise "Must have file name" if file_name.nil?
      File.join disk_meta_save_root_path, 
                "#{disk_meta_save_name}.#{meta_file_extension}"
    end

    def disk_meta_save_name
      file_name
    end

    def last_meta_save
      @last_meta_save
    end

    def last_meta_load
      @last_meta_load
    end

    private

    def default_disk_meta_save_root_path
      './data/'
    end

    def disk_meta_save
      raise "File name must be set before save" if file_name.nil?
      raise "Missing serializer" unless respond_to? :serialize_native
      raise "Missing disk writer" unless respond_to? :disk_write_file
      disk_write_file disk_meta_save_path, serialize_native(meta_data)
      self.last_meta_save = Time.now
    end

    def disk_meta_load
      raise "File name must be set before load" if file_name.nil?
      raise "Missing deserializer" unless respond_to? :deserialize_native
      raise "Missing disk reader" unless respond_to? :disk_read_file
      self.meta_data = deserialize_native(disk_read_file disk_meta_save_path)
      self.last_meta_load = Time.now
      data
    end

    def last_meta_load= when_loaded
      @last_meta_load = when_loaded
    end

    def last_meta_save= last_save
      @last_meta_save = last_save
    end

  end
end
