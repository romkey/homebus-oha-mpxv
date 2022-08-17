require 'homebus'
require 'homebus/state'

require 'open-uri'
require 'nokogiri'

class HomebusOHAhMPXV::App < Homebus::App
  DDC = 'org.homebus.experimental.hmpxv-cases'
  URL = 'https://www.oregon.gov/oha/ph/monkeypox/Pages/index.aspx'
  COUNTIES = %w/Baker Benton Clackamas Clatsop Columbia Coos Crook Curry Deschutes Douglas Gilliam Grant Harney Hood\ River Jackson Jefferson Josephine Klamath Lake Lane Lincoln Linn Malheur Marion Morrow Multnomah Polk Sherman Tillamook Umatilla Union Wallowa Wasco Washington Wheeler Yamhill/

  def initialize(options)
    @options = options
    super
  end

  def setup!
    @devices = []

    COUNTIES.each do |county|
      @devices.push(Homebus::Device.new(name: county,
                                        manufacturer: "Homebus",
                                        model: "OHA hMPXV stats",
                                        serial_number: county))
    end
  end

  def _find(tadas, county)
    tadas.each_with_index do |val, index|
      puts "trying to match #{county} with #{val.text}"
      if val.text.chomp(' ') == county
        return tadas[index+1].text.to_i
      end
    end

    return 0
  end

  def _scrape
    html = URI.open(URL)

    doc = Nokogiri::HTML(html)
    tadas = doc.css('td')
    results = Hash.new

    COUNTIES.each do |county|
      results[county] = _find(tadas, county)
    end

    return results
  end

  def work!
    results = _scrape

    @devices.each do |device|
      payload = {
        cases: results[device.serial_number] || 0
      }

      if @options[:verbose]
        puts device.serial_number, payload
      end

      device.publish! DDC, payload
    end

    sleep update_interval
  end

  def update_interval
    60 * 60 * 3
  end

  def name
    'Oregon hMPXV Cases'
  end

  def publishes
    [ DDC ]
  end

  def devices
    @devices
  end
end
