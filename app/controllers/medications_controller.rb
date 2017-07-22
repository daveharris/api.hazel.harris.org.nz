class MedicationsController < ApplicationController

  def pamol_week
    sum_amount = Medication
      .pamol
      .group_by_week(:at, week_start: :mon)
      .sum(:amount)
      .reverse_merge(empty_weeks_since_birth)
      .sort

    render json: Hash[ sum_amount ]
  end

end
