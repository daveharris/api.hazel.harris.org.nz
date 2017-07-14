class ApplicationController < ActionController::API

  def empty_weeks_since_birth
    weeks_since_birth = HAZEL_BIRTHDAY
                      .step(Date.current, 7)
                      .map(&:beginning_of_week)

    Hash[weeks_since_birth.map {|w| [w, 0]}]
  end

end
