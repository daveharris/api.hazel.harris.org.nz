class BottlesController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
    stats = Bottle.pluck('count(amount), avg(amount), min(amount), max(amount), sum(amount)').flatten

    render json: {
      count:      stats[0],
      avg_amount: stats[1].round(0).to_i,
      min_amount: stats[2],
      max_amount: stats[3],
      sum_amount: stats[4],
      count_per_month: Bottle.group_by_month(:at).count,
      sum_amount_per_month: Bottle.group_by_month(:at).sum(:amount),
      count_per_week: Bottle.group_by_week(:at, week_start: :mon).count,
      sum_amount_per_week: Bottle.group_by_week(:at, week_start: :mon).sum(:amount),
    }
  end

end
