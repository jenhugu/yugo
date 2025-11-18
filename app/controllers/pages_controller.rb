class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def styleguide
    # Chargement de données de test
    @sample_activity = ActivityItem.first
  end
end
