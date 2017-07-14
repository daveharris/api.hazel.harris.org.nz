class Feeding < ApplicationRecord

  validates :at, :type, presence: true
  validates :at, uniqueness: { scope: :type }

  # Insert rows from CSV +input+ into the database
  # +input+: an IO object containing a string
  #
  def self.from_csv(input)
    latest_imported_feeding_date = Feeding.maximum(:at)
    feedings = []

    # Use force_simple_split prevent parsing ...,"Cheese" Toast,...
    SmarterCSV.process(input, force_simple_split: true).each do |line|
      datetime = Time.zone.strptime("#{line[:date]} #{line[:time]}", '%d/%m/%y %l:%M:%S %p')

      # Reduce SQL calls by not attempting to import old data (but not on first time)
      next if latest_imported_feeding_date && datetime < (latest_imported_feeding_date - 1.day)

      if line[:food].present?
        # {date: "15/06/17", time: "6:30:21 AM", food: "Banana Porridge", quantity: "3/4 Bowl"}
        feeding = Solid.new
        feeding.quantity = line[:quantity] # quantity -> String
        feeding.description = line[:food]
        feeding.infer_amount!
      else
        # {date: "15/06/17", time: "6:22:40 PM", amount: 90, formula: 1}
        feeding = Bottle.new
        feeding.amount = line[:amount] # amount -> Integer
        feeding.duration = line[:bottle] # duration in seconds -> Integer
      end

      feeding.at = datetime
      feeding.notes = line[:notes]

      feedings << feeding if feeding.valid?
    end

    Feeding.import(feedings)
  end

end
