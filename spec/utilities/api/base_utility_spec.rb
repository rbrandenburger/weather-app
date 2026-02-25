RSpec.describe Api::BaseUtility do
  let(:klass) { Api::BaseUtility }

  it "is an abstract base class" do
    expect { klass.send(:client_url) }.to raise_error(Api::UtilityError, "no client url defined")
  end
end
