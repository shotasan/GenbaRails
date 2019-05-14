class Task < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma

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

  # CSVデータにどの属性をどの順番で出力するかをクラスメソッドから得られるように定義
  def self.csv_attributes
    %w[name description created_at updated_at]
  end

  # CAVデータの文字列を生成。生成した文字列がgenerate_csvメソッドの戻り値になる
  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr) }
      end
    end
  end

  # CSVデータのインポート機能メソッド
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
