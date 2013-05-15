require_relative '../base'

describe Savable::DiskBacker::Serializor do

  let(:serializor) { Class.new().new.extend(Savable::DiskBacker::Serializor) }

  it "provides serialize native" do
    expect(serializor).to respond_to :serialize_native
  end

  it "provides deserialize native" do
    expect(serializor).to respond_to :deserialize_native
  end

  it "can deserialize natives it serializes" do
    serialized_data = serializor.serialize_native({1=>:abc})
    deserialized_native = serializor.deserialize_native serialized_data
    expect(deserialized_native).to eq({1=>:abc})
  end

end
