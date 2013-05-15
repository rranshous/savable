module Savable
  module NamedBacker
    def file_name
      @name
    end

    def file_name= my_name
      @name = my_name
    end
  end
end
