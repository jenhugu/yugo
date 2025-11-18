class User < ApplicationRecord
  # Modules Devise
  # Others available are: :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_trip_statuses, dependent: :destroy
  has_many :preferences_forms, through: :user_trip_statuses
  has_many :trips, through: :user_trip_statuses
end
