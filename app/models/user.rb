class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token

	has_many :microposts, dependent: :destroy
	has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
	# source указывает, что источников массива following будет followed_id
	has_many :following, through: :active_relationships, source: :followed

	before_save   :downcase_email
	before_create :create_activation_digest

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	has_secure_password

	def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

	def self.new_token
    SecureRandom.urlsafe_base64
  end

	def remember_me
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

	def forget_me
    update_attribute(:remember_digest, nil)
		self.remember_token = nil
  end

	def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

	 # Активирует аккаунт.
	 def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Отправляет электронное письмо для активации.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

	# Устанавливает атрибуты для сброса пароля.
	def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
									 reset_sent_at: Time.zone.now)
  end

  # Отправляет электронное письмо для сброса пароля.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

	def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

	def feed
    Micropost.where("user_id = ?", id)
  end

	 # Начать читать сообщения пользователя.
	 def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Перестать читать сообщения пользователя.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Возвращает true, если текущий пользователь читает сообщения другого пользователя.
  def following?(other_user)
    following.include?(other_user)
  end

	private

	def downcase_email
		self.email = email.downcase
	end

	def create_activation_digest
		self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
	end
end
