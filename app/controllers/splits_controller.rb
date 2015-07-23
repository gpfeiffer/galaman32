class SplitsController < ApplicationController
  before_filter :set_split, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @splits = Split.all
    respond_with(@splits)
  end

  def show
    respond_with(@split)
  end

  def new
    @split = Split.new
    respond_with(@split)
  end

  def edit
  end

  def create
    @split = Split.new(params[:split])
    @split.save
    respond_with(@split)
  end

  def update
    @split.update_attributes(params[:split])
    respond_with(@split)
  end

  def destroy
    @split.destroy
    respond_with(@split)
  end

  private
    def set_split
      @split = Split.find(params[:id])
    end
end
