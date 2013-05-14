module Savable
  module VersionKeeper

    def versioned_name
      raise "Must provide file name accessor" unless respond_to?(:file_name) 
      raise "Must provide file name" if file_name.nil?
      raise "Must set version first" if current_version.nil?
      "#{file_name}.T#{current_version}"
    end

    def current_version
      @current_version
    end

    def current_version= our_version
      @current_version = our_version
    end

    def get_version_from_file_name name
      version = name[/T(.*?)\./]
      unless version.nil? || version.empty?
        return version[1..-2]
      end
      version = name[/T.*/]
      unless version.nil? || version.empty?
        return version[1..-1]
      end
      nil
    end

  end
end
