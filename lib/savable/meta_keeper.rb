module Savable

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
end
