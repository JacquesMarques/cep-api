class ZipAccessesController < ApplicationController
  before_action :authenticate_user

  def index
    zip_accesses = orchestrate_query(ZipAccess.all)
    render serialize(zip_accesses)
  end
end
