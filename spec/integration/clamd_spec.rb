RSpec.describe "ClamAV support using clamd" do

  let(:clean_file) { File.expand_path(File.join("..", "..", "fixtures", "clean.txt"), __FILE__) }

  before do
    @adapter = Ddr::Antivirus.scanner_adapter
    Ddr::Antivirus.scanner_adapter = :clamd
  end

  after do
    Ddr::Antivirus.scanner_adapter = @adapter
  end

  describe "on the clean file" do
    it "doesn't raise an error" do
      expect { Ddr::Antivirus.scan(clean_file) }.not_to raise_error
    end
  end

end
