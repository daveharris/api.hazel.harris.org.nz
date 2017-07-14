class SolidsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
    stats = Solid.pluck('count(id), avg(amount), min(amount), max(amount), sum(amount)').flatten

    render json: {
      count:      stats[0],
      avg_amount: stats[1].try(:round, 0).to_i,
      min_amount: stats[2],
      max_amount: stats[3],
      sum_amount: stats[4]
    }
  end

  def week
    sum_amount = Solid
      .group_by_week(:at, week_start: :mon)
      .sum(:amount)
      .reverse_merge(empty_weeks_since_birth)
      .sort

    render json: Hash[ sum_amount ]
  end

end
