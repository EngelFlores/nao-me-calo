require 'rails_helper'

RSpec.describe RatingsController, type: :controller do

  describe "#new" do
    before :each do
      @est1 = Establishment.create!(name:"Teste", address:"Logo Ali", lat:"0", lng:"0", id_places:"ChIJ-ZgW_AB5GZUR-LPwX7gPUNs", city:"Porto Alegre")
      @est2 = Establishment.create!(name:"Teste", address:"Logo Ali", lat:"0", lng:"0", id_places:"123", city:"Porto Alegre")
    end
    it "expect @est1 to be a valid spot in google places" do
      get :new
      expect(@est1.id_places).to eq("ChIJ-ZgW_AB5GZUR-LPwX7gPUNs")
    end
    it "expect @rating to be a new Ratings" do
      get :new
      expect(assigns[:rating]).to be_a(Rating)
    end
    it 'flash error when there is a invalid Establishment' do
      get :new, id: @est2
      expect(flash[:error]).to eq("Erro, por favor, pesquise de novo.")
    end
  end

  describe "#create" do
    before :each do
      @est1 = Establishment.create!(name:"Teste", address:"Logo Ali", lat:"0", lng:"0", id_places:"ChIJ-ZgW_AB5GZUR-LPwX7gPUNs", city:"Porto Alegre")
    end
    it "expect to flash notice when the rating is created" do
      post :create, {placeId:"ChIJ-ZgW_AB5GZUR-LPwX7gPUNs", accepted_terms: true, rating:
        {
          woman: 4.0,
          race: 4.0,
          lgbtqia: 4.0,
          disability: 4.0,
          elder: 4.0,
          obese: 4.0,
          name: "Teste",
          cpf: "123456",
          email: "teste",
          phone: "teste",
          rating_date:"06/06/06",
          description: "",
          establishment_id: @est1.id
        }
      }
      expect(flash[:notice]).to eq("Avaliação feita com sucesso!")
    end

    it "expect to flash notice when the rating is created" do
      post :create, {placeId:"ChIJ-ZgW_AB5GZUR-LPwX7gPUNs", accepted_terms: true, rating:
        {
          woman: 4.0,
          race: 4.0,
          lgbtqia: 4.0,
          disability: 4.0,
          elder: 4.0,
          obese: 4.0,
          name: "Teste",
          cpf: "123456",
          email: "teste",
          phone: "teste",
          rating_date:"06/06/06",
          description: "opa",
          establishment_id: @est1.id
        }
      }
      expect(flash[:notice]).to eq("Avaliação feita com sucesso! Sua avaliação irá passar pela moderação.")
    end

    it "expect to flash notice when using bad words" do
      post :create, {placeId:"ChIJ-ZgW_AB5GZUR-LPwX7gPUNs", accepted_terms: true, rating:
        {
          woman: 4.0,
          race: 4.0,
          lgbtqia: 4.0,
          disability: 4.0,
          elder: 4.0,
          obese: 4.0,
          name: "Teste",
          cpf: "123456",
          email: "teste",
          phone: "teste",
          rating_date:"06/06/06",
          establishment_id: @est1.id,
          description: "grelo"
        }
      }
      expect(flash[:notice]).to eq("* Você usou palavras de baixo calão, por favor, preencha o formulário novamente *")
    end

    it "expect to render new when the rating is not created" do
      post :create,{placeId:"ChIJ-ZgW_AB5GZUR-LPwX7gPUNs", rating:
        {
          woman: 4.0,
          race: 4.0,
          lgbtqia: 4.0,
          disability: 4.0,
          elder: 4.0,
          obese: 4.0,
          name: "Teste",
          email: "teste",
          phone: "teste",
          rating_date:"06/06/06",
        }
      }
      expect(response).to redirect_to(root_path)
    end
  end
end
