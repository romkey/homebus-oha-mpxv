require 'homebus/options'

class HomebusOHAhMPXV::Options < Homebus::Options
  def app_options(op)
  end

  def banner
    'Homebus OHA Monkeypox stats'
  end

  def version
    HomebusOHAhMPXV::VERSION
  end

  def name
    'homebus-oha-monkeypox'
  end
end
