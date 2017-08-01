class PayType < ApplicationRecord
  has_many :orders
  validates :name, presence: true, uniqueness: true

  def translated_name
    I18n.t(name, scope: 'pay_types')
  end
end
