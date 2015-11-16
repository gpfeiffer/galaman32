module SwimmersHelper
  def boy_or_girl(gender)
    {
      'F' => "girl",
      'M' => "boy",
    }[gender]
  end
end
