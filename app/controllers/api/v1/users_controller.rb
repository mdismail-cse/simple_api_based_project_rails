module Api
  module V1
    class UsersController < ApplicationController

      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
      rescue_from StandardError, with: :standard_error
      def index
        @users = User.all
        render json: { status: 'success', message: 'load user', data: @users}, status: :ok
      end

      def show
        @user = User.find(params[:id])
        render json: {status: 'success', message: 'load user', data: @user}, status: :ok
      end

      def create
        debugger
        @user = User.new(user_params)

        if @user.save
          render json: {status: 'success', message: 'user saved', data: @user}, status: :ok
        else
          render json: {status: 'error', message: 'user not saved', data: @user.errors}, status: :unprocessable_entity
        end

      end

      def update
        @user = User.find(params[:id])

        if @user.update_attributes(user_params)
          render json: {status: 'SUCCESS', message: 'user is updated', data:@user}, status: :ok
        else
          render json: {status: 'Error', message: 'User is not updated', data:@user.errors}, status: :unprocessable_entity
        end
      end

      def user_list
        @users = User.all
        render json: { status: 'success', message: 'load user', data: @users}, status: :ok
      end




      private
      def user_params
        params.permit(:name)
      end


      def record_not_found(e)
        render json: { error: "Record not found", Error_code: 404 }, status: :not_found
      end

      def record_invalid(e)
        render json: { error: "Record invalid", errors: e.record.errors }, status: :unprocessable_entity
      end

      def standard_error(e)
        render json: { error: "An error occurred", details: e.message }, status: :internal_server_error
      end




    end
  end
end