module Api
  module V1
    class BehaviorsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_behavior, only: [:show, :update, :destroy]
      before_action :set_pet, only: [:index, :create]

      def index
        render json: @pet.behaviors.all
      end

      def show
        render json: @behavior
      end

      def create
        @behavior = @pet.behaviors.new(filtered_params)

        if @behavior.save
          render json: @behavior,
                 status: :created,
                 location: url_for(action: :show, id: @behavior)
        else
          render_bad_request
        end
      end

      def update
        if @behavior.update_attributes(filtered_params)
          render json: @behavior,
                 status: :ok,
                 location: url_for(action: :show, id: @behavior)
        else
          render_bad_request
        end
      end

      def destroy
        if @behavior.destroy
          render json: @behavior, status: :ok
        else
          # TODO: This should probably return another code such as 500
          render_bad_request
        end
      end

      private

      def set_behavior
        @behavior = Behavior.find(params[:id])
        validate_ownership
      end

      def set_pet
        @pet = Pet.where(user_id: current_user.id).find(params[:pet_id])
      end

      def validate_ownership
        return if @behavior.pet.user == current_user
        render_json_error('403 Forbidden', :forbidden)
      end

      def filtered_params
        params.require(:behavior).permit(:name)
      end

      def render_bad_request
        render_model_errors(@behavior, :bad_request)
      end
    end
  end
end
