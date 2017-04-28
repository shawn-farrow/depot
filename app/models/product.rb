class Product < ActiveRecord::Base
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|jpg|png)\Z}i,
      message: 'must be a URL for GIF, JPG, or PNG image.'
  }
  validates_length_of :title, :minimum => 10, :allow_blank => true, message: 'must be at least 10 characters'

  def self.latest
    Product.order(:updated_at).last
  end

  has_many :line_items

  before_destroy :ensure_not_referrenced_by_any_line_item

  private

    def ensure_not_referrenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line Items present')
        return false
      end
    end
end