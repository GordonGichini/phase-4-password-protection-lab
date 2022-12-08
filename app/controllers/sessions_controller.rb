class SessionsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def create
        user=User.find_by(username:params[:username])
        if user&.authenticate(params[:password])
            session[:user_id]=user.id
            render json: user, status: :ok
        else
            render json: {error: "Wrong password or username"}, status: :unauthorized
        end
    end

    def destroy
        session.delete  :user_id
        head :no_content
    end

    private
    def render_not_found_response
        render json: {error: "user not found"}
    end
end