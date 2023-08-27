module Api
  module V1
    class PostsController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
      rescue_from StandardError, with: :standard_error

      def index
        posts = Post.order('created_at DESC')
        render json: {status: 'SUCCESS', message: 'Loaded posts', data:posts}, status: :ok

      end

      def show
        @post = Post.find(params[:id])
        render json: {status: 'SUCCESS', message: 'Loaded posts', data:@post}, status: :ok


      end

      def create
        @post = Post.new(params.permit(:title, :user_id))

        if @post.save
          render json: {status: 'SUCCESS', message: 'Post is saved', data:@post}, status: :ok
        else
          render json: {status: 'Error', message: 'Post is not saved', data:@post.errors}, status: :unprocessable_entity
        end
      end

      def update
        @post = Post.find(params[:id])

        if @post.update_attributes(post_params.permit(:title, :body))
          render json: {status: 'SUCCESS', message: 'Post is updated', data:@post}, status: :ok
        else
          render json: {status: 'Error', message: 'Post is not updated', data:@post.errors}, status: :unprocessable_entity
        end
      end

      def destroy
        @post = Post.find(params[:id])
        @post.destroy

        render json: {status: 'SUCCESS', message: 'Post successfully deleted', data:@post}, status: :ok
      end

      private
      def post_params
        params.require(Post).permit(:title, :body, :user_id)
      end


      private

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