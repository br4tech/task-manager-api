class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  # attr_accessor :name
  # validates_presence_of :name
  validates_uniqueness_of :auth_token

  #Sempre quando for criado um usuario executa o metodo generate_authentication_token!
  before_create :generate_authentication_token!

  # Sempre quando o usuario for deletado remover também as tasks desse usuario
  has_many :tasks, dependent: :destroy

  def info
    "#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end

  def generate_authentication_token!
    #Repete o bloco  caso existir algum usuario com o mesmo token informado
    begin
      self.auth_token = Devise.friendly_token
    end while User.exists?(auth_token: auth_token)
  end

end
