class Feeding < ApplicationRecord

  validates :at, :type, presence: true
  validates :at, uniqueness: { scope: :type }

  def latest_date

  end

  def self.from_csv(filepath)
    imported_count = Feeding.count
    latest_imported_feeding_date = Feeding.maximum(:at) || Time.current
    feedings = []

    # Standardise line endings
    File.write(filepath, File.read(filepath).encode(universal_newline: true))

    # Use ' as quote to prevent parsing ...,"Cheese" Toast,...
    SmarterCSV.process(filepath, quote_char: "'").each do |line|
      datetime = Time.zone.strptime("#{line[:date]} #{line[:time]}", '%d/%m/%y %l:%M:%S %p')

      # Reduce SQL calls by not attempting to import old data (but not on first time)
      next if datetime < (latest_imported_feeding_date - 1.day) && imported_count > 0

      if line[:food].present?
        # {:date=>"15/06/17", :time=>"6:30:21 AM", :food=>"Banana Porridge", :quantity=>"3/4 Bowl"}
        feeding = Solid.new
        feeding.quantity = line[:quantity] # quantity -> String
        feeding.description = line[:food]
      else
        # {:date=>"15/06/17", :time=>"6:22:40 PM", :amount=>90, :formula=>1}
        feeding = Bottle.new
        feeding.amount = line[:amount] # amount -> Integer
      end

      feeding.at = datetime

      feedings << feeding if feeding.valid?
    end

    Feeding.import(feedings)
  end

end
