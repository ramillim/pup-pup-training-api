module Api
  module V1
    class BehaviorsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_behavior, only: [:show, :update, :destroy]
      before_action :set_pet, only: [:index, :create]

      def index
        render json: @pet.behaviors.all
      end

      private

      def set_behavior
        @behavior = Behavior.find(params[:id])
      end

      def set_pet
        @pet = Pet.where(user_id: current_user.id).find(params[:pet_id])
      end

      def behavior_params
        params.require(:behavior).permit(:name)
      end

      def render_bad_request
        render_model_errors(@behavior, :bad_request)
      end
    end
  end
end
