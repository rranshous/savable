module Savable
  module VersionKeeper

    def versioned_name
      raise "Must provide file name accessor" unless respond_to?(:file_name) 
      raise "Must provide file name" if file_name.nil?
      raise "Must set version first" if current_version.nil?
      "#{file_name}.T#{current_version}T"
    end

    def current_version
      @current_version
    end

    def current_version= our_version
      raise "Can not set version to nil" if our_version.nil?
      raise "Versions must be strings" unless our_version.kind_of? String
      @current_version = our_version.to_s
    end

    def get_version_from_file_name name
      version = name[/T(.*?)T/]
      unless version.nil? || version.empty?
        return version[1..-2]
      end
      nil
    end

  end
end
