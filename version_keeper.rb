module Savable
  module VersionKeeper

    def versioned_name
      raise "Must provide name" if !respond_to?(:name) || name.nil?
      raise "Must set version first" if current_version.nil?
      "#{name}.T#{current_version}"
    end

    def current_version
      @current_version
    end

    def current_version= our_version
      @current_version = our_version
    end

  end
end
