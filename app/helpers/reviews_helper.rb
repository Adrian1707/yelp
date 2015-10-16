module ReviewsHelper
  def star_rating(rating)
    return rating unless rating.is_a?(Fixnum)
    '★' * rating + '☆' * (5 - rating)
  end
end
