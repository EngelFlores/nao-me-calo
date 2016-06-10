class WelcomeController < ApplicationController
  before_action :set_client, only: [:index, :search]

  def index
    @establishments = Establishment.select('establishments.* , MAX(ratings.rating_date) as rd').joins(:ratings).order('rd desc').group('establishments.id').first(5)
  end

  def search
    @establishment = Establishment.search_by_id(params[:place_id_2]).first
    if(@establishment.nil?)
      $establishment = @client.spot(params[:place_id_2])
      redirect_to root_path, :flash => { :error => "Lugar ainda não foi avaliado. Clique nessa mensagem para avalia-lo." }
    else
      redirect_to @establishment
    end
  end

  def help
  end

  def terms
  end

  private

  def set_client
    @client = GooglePlaces::Client.new(G_PLACE_KEY)
  end

end
