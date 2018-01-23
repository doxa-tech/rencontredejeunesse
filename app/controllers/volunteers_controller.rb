class VolunteersController < ApplicationController
  include SectorsHelper

  def index
    @volunteer = Volunteer.new
  end

  def create
  end
end
