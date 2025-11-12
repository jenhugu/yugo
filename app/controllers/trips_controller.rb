class TripsController < ApplicationController
  def show
    @trip = Trip.find(params[:id])
  end

  def new
  end

  def create
  end

  def destroy
  end

  def edit
  end

  def update
  end
end
