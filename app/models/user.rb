class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :overtimenotifications, inverse_of: 'visitor', through: :attendances, dependent: :destroy
  has_many :editnotofications, dependent: :destroy
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  
 
  has_secure_password
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)(?=.*?[!-\/:-@\[-`{-~])[!-~]{8,20}+\z/i
  validates :password, presence: true, allow_nil: true,
                    format: { with: VALID_PASSWORD_REGEX , message: "８文字以上かつ２０文字以下、半角英数字記号をそれぞれ1種類以上含めてください" } 
  
   # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      return false
    end
  end
  
  def self.import(file)
    if file.present?
      CSV.foreach(file.path, headers: true) do |row|
        # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
        user = find_by(id: row["id"]) || new
        # CSVからデータを取得し、設定する
        user.attributes = row.to_hash.slice(*updatable_attributes)
        # 保存する
        user.save
      end
    else
      return false
    end
  end
  
  def self.updatable_attributes
    ["name", "email", "affiliation", "employee_number", "uid", "password"]
  end
end
