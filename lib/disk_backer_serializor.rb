module Savable
  module DiskBacker::Serializor

    def serialize_native native
      serialize_marshal native
    end
    
    def deserialize_native data
      deserialize_marshal data
    end

    def serialize_marshal data
      Marshal.dump data
    end

    def deserialize_marshal data
      Marshal.load data
    end

  end
end
