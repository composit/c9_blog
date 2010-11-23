class EntriesController < ApplicationController
  def index
    @entries = Entry.order_by( [:created_at, :desc] )
  end
end
