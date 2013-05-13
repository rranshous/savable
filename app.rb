module Savable

  class Base
    def data
      @data
    end
    def data= the_datas
      @data = the_datas
    end
  end

  module NamedBacker
    def name
      @name
    end

    def name= my_name
      @name = my_name
    end
  end

  module DiskBacker

    def disk_save_root_path
      @disk_save_root_path ||= default_disk_save_root_path
    end

    def disk_save_root_path= new_path
      @disk_save_root_path = new_path
    end

    def disk_save_path
      File.join disk_save_root_path, name
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

  module DiskBacker::Meta

    def file_extension
      'meta'
    end

    def disk_meta_save_root_path
      @disk_meta_save_root_path ||= default_disk_meta_save_root_path
    end

    def disk_meta_save_root_path= new_path
      @disk_meta_save_root_path = new_path
    end

    def disk_meta_save_path
      File.join disk_meta_save_root_path, "#{name}.#{file_extension}"
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
      raise "Name must be set before save" if name.nil?
      disk_write_file disk_meta_save_path, meta_data
      self.last_meta_save = Time.now
    end

    def disk_meta_load
      raise "Name must be set before load" if name.nil?
      meta_data = disk_read_file disk_meta_save_path
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

  module DiskBacker::Serializor
    def serialize native
    end
    def deserialize data
    end
  end

  module MetaKeeper

    def [] k
      meta_data[k]
    end

    def []= k, v
      meta_data[k] = v
    end

    def meta_data
      @meta_data ||= {}
    end

    def meta_data= new_meta_data
      meta_data.merge! new_meta_data
    end

  end

  module VersionKeeper
  end
end
