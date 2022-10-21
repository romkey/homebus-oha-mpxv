require 'spec_helper'

require 'homebus-oha-hmpxv/version'
require 'homebus-oha-hmpxv/options'
require 'homebus-oha-hmpxv/app'

require 'homebus/config'

class TestHomebusOhaHmpxv < HomebusOhaHmpxv::App
  # override config so that the superclasses don't try to load it during testing
  def initialize(options)
    @config = Hash.new
    @config = Homebus::Config.new

    @config.login_config = {
                            "default_login": 0,
                            "next_index": 1,
                            "homebus_instances": [
                                      {
                                        "provision_server": "https://homebus.org",
                                       "email_address": "example@example.com",
                                       "token": "XXXXXXXXXXXXXXXX",
                                       "index": 0
                                      }
                                    ]
    }

    @store = Hash.new
    super
  end
end

describe HomebusOhaHmpxv do
  context "Version number" do
    it "Has a version number" do
      expect(HomebusOhaHmpxv::VERSION).not_to be_nil
      expect(HomebusOhaHmpxv::VERSION.class).to be String
    end
  end 
end

describe HomebusOhaHmpxv::Options do
  context "Methods" do
    options = HomebusOhaHmpxv::Options.new

    it "Has a version number" do
      expect(options.version).not_to be_nil
      expect(options.version.class).to be String
    end

    it "Uses the VERSION constant" do
      expect(options.version).to eq(HomebusOhaHmpxv::VERSION)
    end

    it "Has a name" do
      expect(options.name).not_to be_nil
      expect(options.name.class).to be String
    end

    it "Has a banner" do
      expect(options.banner).not_to be_nil
      expect(options.banner.class).to be String
    end
  end
end

describe TestHomebusOhaHmpxv do
  context "Methods" do
    options = HomebusOhaHmpxv::Options.new
    app = HomebusOhaHmpxv::App.new(options)

    it "Has a name" do
      expect(app.name).not_to be_nil
      expect(app.name.class).to be String
    end

    it "Consumes" do
      expect(app.consumes).not_to be_nil
      expect(app.consumes.class).to be Array
    end

    it "Publishes" do
      expect(app.publishes).not_to be_nil
      expect(app.publishes.class).to be Array
    end

    it "Has devices" do
      expect(app.devices).not_to be_nil
      expect(app.devices.class).to be Array
    end
  end
end
