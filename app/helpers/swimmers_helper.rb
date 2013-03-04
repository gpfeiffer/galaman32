module SwimmersHelper
  def distance_course(code)
    "#{1 + code / 100}m #{(100 - code % 100).chr}C"
  end
end
