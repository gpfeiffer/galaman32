class Club < ActiveRecord::Base
  default_scope order: :full_name

  has_many :swimmers, dependent: :destroy
  has_many :invitations, dependent: :destroy
    has_many :competitions, through: :invitations
    has_many :dockets, through: :invitations
      has_many :entries, through: :dockets
        has_many :results, through: :entries

  validates :full_name, :code, presence: true
  validates :code, uniqueness: true

  def symbol
    lsc.present? ? "#{code}-#{lsc}" : code
  end

  def name
    "#{full_name} (#{symbol})"
  end

  def to_s
    full_name
  end

  # output spreadsheet of PBs
  def to_csv
    results_by_swimmer = Hash[swimmers.map { |s| [s, s.results] } ]
    year_results = results_by_swimmer.values.sum
    disciplines = year_results.map(&:discipline).uniq.sort_by(&:course).sort_by(&:distance).sort_by(&:stroke)
    headers = [ "Swimmer", "Swim Ireland ID" ] + disciplines.map(&:nickname_course)
    CSV.generate(headers: true) do |csv|
      csv << headers
      results_by_swimmer.each do |swimmer, swimmer_results|
        row = [swimmer.first_last, swimmer.number]
        disciplines.each do |discipline|
          discipline_results = swimmer_results.select { |x| x.discipline == discipline and x.time.present? }
          row << (discipline_results.any? ? ResultsController.helpers.best_result(discipline_results).to_s : "")
        end
        csv << row
      end
    end
  end
  
  # output spreadsheet of this year's best performances
  def to_csv_old
    date = Date.parse("August") - 1.year
    year_results = results.select { |result| result.date > date }
    disciplines = year_results.map(&:discipline).uniq.sort_by(&:course).sort_by(&:distance).sort_by(&:stroke)
    headers = [ "Swimmer" ] + disciplines.map(&:nickname_course)
    results_by_swimmer = year_results.group_by(&:swimmer)
    CSV.generate(headers: true) do |csv|
      csv << headers
      results_by_swimmer.each do |swimmer, swimmer_results|
        row = [swimmer.first_last]
        disciplines.each do |discipline|
          discipline_results = swimmer_results.select { |x| x.discipline == discipline and x.time.present? }
          row << (discipline_results.any? ? ResultsController.helpers.best_result(discipline_results).to_s : "")
        end
        csv << row
      end
    end
  end

end
