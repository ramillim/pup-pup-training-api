module Api
  module V1
    class TrainingActivitiesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_activity, only: [:show, :update, :destroy]
      before_action :set_behavior, only: [:index, :create]

      def index
        render json: @behavior.training_activities.all
      end

      def show
        render json: @activity
      end

      def create
        @activity = @behavior.training_activities.new(filtered_params)

        if @activity.save
          render json: @activity,
                 status: :created,
                 location: url_for(action: :show, id: @activity)
        else
          render_bad_request
        end
      end

      def update
        if @activity.update_attributes(filtered_params)
          render json: @activity,
                 status: :ok,
                 location: url_for(action: :show, id: @activity)
        else
          render_bad_request
        end
      end

      def destroy
        if @activity.destroy
          render json: @activity, status: :ok
        else
          # TODO: This should probably return another code such as 500
          render_bad_request
        end
      end

      private

      def set_activity
        @activity = TrainingActivity.find(params[:id])
        validate_ownership(@activity.behavior)
      end

      def set_behavior
        @behavior = Behavior.find(params[:behavior_id])
        validate_ownership(@behavior)
      end

      def validate_ownership(behavior)
        return if behavior.pet.user == current_user
        render_json_error('403 Forbidden', :forbidden)
      end

      def filtered_params
        params.require(:training_activity).permit(:name,
                                                  :notes,
                                                  :duration,
                                                  :duration_notes,
                                                  :distance,
                                                  :distance_notes,
                                                  :distraction,
                                                  :distraction_notes,
                                                  :trained_at,
                                                  :training_duration)
      end

      def render_bad_request
        render_model_errors(@activity, :bad_request)
      end
    end
  end
end
