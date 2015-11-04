RSpec.describe "ClamAV support using clamd" do

  let(:infected_file) { File.expand_path(File.join("..", "..", "fixtures", "eicar.txt"), __FILE__) }
  let(:clean_file) { File.expand_path(File.join("..", "..", "fixtures", "clean.txt"), __FILE__) }

  before do
    @adapter = Ddr::Antivirus.scanner_adapter
    Ddr::Antivirus.scanner_adapter = :clamd
  end

  after do
    Ddr::Antivirus.scanner_adapter = @adapter
  end

  describe "on the infected file" do
    it "raises a VirusFoundError" do
      expect { Ddr::Antivirus.scan(infected_file) }.to raise_error(Ddr::Antivirus::VirusFoundError)
    end
  end

  describe "on the clean file" do
    it "doesn't raise an error" do
      expect { Ddr::Antivirus.scan(clean_file) }.not_to raise_error(Ddr::Antivirus::Error)
    end
  end

end
