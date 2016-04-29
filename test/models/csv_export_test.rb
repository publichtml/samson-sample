require_relative '../test_helper'

SingleCov.covered!

describe CsvExport do
  let(:user) { users(:deployer) }
  before { @csv_export = CsvExport.create(user: user) }

  describe "scopes" do
    before do
      @old_export = CsvExport.create({user: user, filters: {}})
    end

    it "returns old created" do
      @old_export.update_attributes({created_at: DateTime.now - 1.year, updated_at: DateTime.now})
      assert_equal(1, CsvExport.old.size)
    end

    it "returns old downloaded" do
      @old_export.update_attributes({updated_at: DateTime.now - 13.hours, created_at: DateTime.now - 14.hours,
        status: 'downloaded'})
      assert_equal(1, CsvExport.old.size)
    end

    it "returns no old" do
      @old_export.destroy
      assert_equal(0, CsvExport.old.size)
    end
  end

  describe "status methods" do
    it "sets pending and responds correctly" do
      @csv_export.status! :pending
      @csv_export.status.must_equal "pending"
      assert @csv_export.status? "pending"
      refute @csv_export.status? "ready"
    end

    it "sets started and responds correctly" do
      @csv_export.status! :started
      @csv_export.status.must_equal "started"
      assert @csv_export.status? "started"
      refute @csv_export.status? "ready"
    end

    it "sets finished and responds correctly" do
      @csv_export.status! :finished
      @csv_export.status.must_equal "finished"
      assert @csv_export.status? "finished"
      assert @csv_export.status? "ready"
    end

    it "sets downloaded and responds correctly" do
      @csv_export.status! :downloaded
      @csv_export.status.must_equal "downloaded"
      assert @csv_export.status? "downloaded"
      assert @csv_export.status? "ready"
    end

    it "sets failed and responds correctly" do
      @csv_export.status! :failed
      @csv_export.status.must_equal "failed"
      assert @csv_export.status? "failed"
      refute @csv_export.status? "ready"
    end

    it "sets deleted and responds correctly" do
      @csv_export.status! :deleted
      @csv_export.status.must_equal "deleted"
      assert @csv_export.status? "deleted"
      refute @csv_export.status? "ready"
    end

    it "raises ActiveRecord::RecordInvalid" do
      assert_raise(ActiveRecord::RecordInvalid) do
        @csv_export.status! "hello_world"
      end
    end

    it "status? responds to symbolics" do
      @csv_export.status! :finished
      assert @csv_export.status? :ready
      assert @csv_export.status? :finished
    end

    it "status! responds to string" do
      @csv_export.status! "finished"
      @csv_export.status.must_equal "finished"
    end
  end

  it "sets filename if not assigned" do
    assert_not_empty @csv_export.download_name
  end

  describe "#email" do
    it "for valid user" do
      @csv_export.email.must_equal user.email
    end

    it "null for invalid user" do
      @csv_export.update_attribute(:user_id, -99999)
      assert @csv_export.email.nil?
    end
  end

  describe "#filters" do
    it "returns a ruby object" do
      assert @csv_export.filters.class.must_equal Hash.new.class
    end

    it "converts date list to range" do
      @csv_export.update_attribute(:filters, {'deploys.created_at': (Date.new(1900,1,1)..Date.today)})
      @csv_export.filters['deploys.created_at'].class.must_equal (1..2).class
      @csv_export.filters['deploys.created_at'].must_equal (Date.new(1900,1,1)..Date.today)
    end
  end

  describe "delete_file" do
    before do
      @filename = @csv_export.path_file
      FileUtils.mkdir_p(File.dirname(@filename))
      File.new(@filename, 'w')
      assert File.exists?(@filename), "File not created in before"
    end

    after do
      File.delete(@filename) if File.exist?(@filename)
    end

    it "deletes file when delete_file called" do
      @csv_export.delete_file
      refute File.exists?(@filename), "File not removed by delete_file"
    end

    it "deletes file when destroy called" do
      @csv_export.destroy
      refute File.exists?(@filename), "File not removed by destroy"
    end
  end

  describe "defaults" do
    it "sets defaults" do
      csv_export = CsvExport.create(user: user)
      csv_export.status.must_equal "pending"
      csv_export.filters.must_equal Hash.new
    end
  end
end
