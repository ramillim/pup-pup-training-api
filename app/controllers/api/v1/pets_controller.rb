module Api
  module V1
    class PetsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_pet, only: [:show, :update, :destroy]

      # GET /api/v1/pets
      def index
        @pets = Pet.where(user: current_user)
        render json: @pets
      end

      # GET /api/v1/pets/1
      def show
        render json: @pet
      end

      # POST /api/v1/pets
      def create
        @pet = Pet.new(pet_params)
        @pet.user = current_user

        if @pet.save
          render json: @pet, status: :created, location: url_for(action: :show, id: @pet)
        else
          render_bad_request
        end
      end

      # PUT/PATCH /api/v1/pets
      def update
        if @pet.update_attributes(pet_params)
          render json: @pet, status: :ok, location: url_for(action: :show, id: @pet)
        else
          render_bad_request
        end
      end

      # DELETE /api/v1/pets/1
      def destroy
        if @pet.destroy
          render json: @pet, status: :ok
        else
          # TODO: This should probably return another code such as 500
          render_bad_request
        end
      end

      private

      def set_pet
        @pet = Pet.find(params[:id])
        validate_ownership
      end

      def validate_ownership
        return if @pet.user == current_user
        render_json_error('403 Forbidden', :forbidden)
      end

      def pet_params
        params.require(:pet).permit(:name, :birth_date)
      end

      def render_bad_request
        render_model_errors(@pet, :bad_request)
      end
    end
  end
end
