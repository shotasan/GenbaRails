class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  # 検索対象にすることを許可するカラムを指定する
  # 名称と登録日時のみ許可する
  def self.ransackable_attributes(auth_objet = nil)
    %w[name created_at]
  end

  # 検索条件に含める関連を指定する
  # 空の配列を返すようにオーバーライドすると、意図しない関連を含めないようにできる
  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
