class Restaurant < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true

  def created_by?(user)
    self.user == user
  end

  def destroy_as(user)
    unless created_by? user
      errors.add(:user, 'cannot delete this restaurant')
      return false
    end
    destroy
  end

  def average_rating
    if reviews.none?
      "N/A"
    else
      reviews.average(:rating)
    end
  end

end
