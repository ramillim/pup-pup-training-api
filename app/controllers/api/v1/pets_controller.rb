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
          message = { errors: { code: 400,
                                message: @pet.errors.full_messages.to_sentence } }
          render json: message, status: :bad_request
        end
      end

      # PUT /api/v1/pets
      def update
        if @pet.update_attributes(pet_params)
          render json: @pet, status: :accepted, location: url_for(action: :show, id: @pet)
        else
          message = { errors: { code: 400,
                                message: @pet.errors.full_messages.to_sentence } }
          render json: message, status: :bad_request
        end
      end

      private

      def set_pet
        @pet = Pet.where(user_id: current_user.id).find(params[:id])
      end

      def pet_params
        params.require(:pet).permit(:name, :birth_date)
      end
    end
  end
end
