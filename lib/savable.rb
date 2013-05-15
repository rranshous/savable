require_relative 'savable/base.rb'
require_relative 'savable/named_backer.rb'
require_relative 'savable/disk_backer.rb'
require_relative 'savable/disk_backer_serializor.rb'
require_relative 'savable/meta_keeper.rb'
require_relative 'savable/disk_backer_meta.rb'
require_relative 'savable/disk_accessor.rb'
require_relative 'savable/version_keeper.rb'

class Savable::Savable < Savable::Base
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

class Savable::SavableVersioned < Savable::Savable

  include Savable::VersionKeeper

  def disk_save_name
    versioned_name
  end

  def disk_meta_save_name
    versioned_name
  end

  def save
    self.current_version = Time.now.to_f.to_s
    super # save down data
    create_symbolic_link_to_blob
    create_symbolic_link_to_meta
  end

  def create_symbolic_link_to_blob
    # HACK
    link_path = self.disk_save_path.gsub /.T.*?T/, '' # remove version
    File.unlink link_path if File.exist? link_path
    FileUtils.symlink disk_save_path, link_path
  end

  def create_symbolic_link_to_meta
    link_path = self.disk_meta_save_path.gsub /T.*?T/, '' # remove version
    File.unlink link_path if File.exist? link_path
    FileUtils.symlink disk_meta_save_path, link_path
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
