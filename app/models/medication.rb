class Medication < ApplicationRecord

  validates :at, :medication, presence: true
  validates :at, uniqueness: { scope: :medication }

  scope :pamol, -> { where(medication: 'Pamol') }

  # Insert rows from CSV +input+ into the database
  # +input+: an IO object containing a string
  #
  def self.from_csv(input)
    latest_imported_medication_date = Medication.maximum(:at)
    medications = []

    # Use force_simple_split prevent parsing ...,"Cheese" Toast,...
    SmarterCSV.process(input, force_simple_split: true).each do |line|
      datetime = Time.zone.strptime("#{line[:date]} #{line[:time]}", '%d/%m/%y %l:%M:%S %p')

      # Reduce SQL calls by not attempting to import old data (but not on first time)
      next if latest_imported_medication_date && datetime < (latest_imported_medication_date - 1.day)

      # {date: "13/06/17", time: "8:36:16 PM", medication: "Pamol", dosage: "3 ml", notes: ""}
      medication = Medication.new({
        at:          datetime,
        medication:  line[:medication],
        quantity:    line[:dosage],
        notes:       line[:notes]
      })
      medication.infer_amount!

      medications << medication if medication.valid?
    end

    Medication.import(medications)
  end

  # Infers and sets the 'amount' from the quantity and notes
  #
  def infer_amount!
    self.amount = nil

    full_description = "#{quantity} #{notes}".downcase

    inferred = full_description.gsub(/[a-z|\s]/, '').to_f
    self.amount = inferred if inferred > 0

    if self.amount == nil
      Rails.logger.warn "Couldn't infer amount from [#{full_description}]"
    end
  end

end
