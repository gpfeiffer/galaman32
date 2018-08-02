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
    results = swimmers.results.map(&:results).sum
    disciplines = results.map(&:discipline).uniq.sort_by(&:course).reverse.sort_by(&:distance).sort_by(&:stroke)
    headers = [ "Swimmer", "Swim Ireland ID" ] + disciplines.map(&:nickname_course)
    CSV.generate(headers: true) do |csv|
      csv << headers
      swimmers.each do |swimmer|
        row = [swimmer.first_last, swimmer.number]
        swimmer_results = swimmer.results
        disciplines.each do |discipline|
          discipline_results = swimmer_results.select { |x| x.discipline == discipline and x.time.present? }
          row << (discipline_results.any? ? ResultsController.helpers.best_result(discipline_results).to_s : "")
        end
        csv << row
      end
    end
  end

  def to_csv_old
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

end
