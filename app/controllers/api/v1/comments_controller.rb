module Api
    module V1
        class CommentsController < ApplicationController
            before_action :authenticate_request

            def show
                comments = Comment.find(params[:id])
                render json: {status: 'SUCCESS', message:'Loaded comment comments', data:comments},status: :ok
            end

            def create
                comment = Comment.create('user_id'=> $current_user,'article_id'=>  params[:article_id],'body'=> params[:body])
                if comment.save
                render json: {status: 'SUCCESS', message:'Saved comment', data:comment},status: :ok
                auto_del_in_24H(comment['id'])
                else
                render json: {status: 'ERROR', message:'Comment not saved', data:comment.errors},status: :unprocessable_entity
                end
            end

            def destroy
                comment = Comment.find(params[:id])
                if !auth_comment(comment)
                    render json: {status: 'ERROR', message:'unauthorized', authorized_user:comment['user_id']},status: :unauthorized
                else
                    comment.destroy
                    render json: {status: 'SUCCESS', message:'Deleted comment', data:comment},status: :ok
                end
            end

            def update
                comment = Comment.find(params[:id])
                if !auth_comment(comment)
                    render json: {status: 'ERROR', message:'unauthorized', authorized_user:comment['user_id']},status: :unauthorized
                else
                    if comment.update(comment_params)
                        render json: {status: 'SUCCESS', message:'Updated comment', data:comment},status: :ok
                    else
                        render json: {status: 'ERROR', message:'Comment not updated', data:comment.errors},status: :unprocessable_entity
                    end
                end
            end

            def comment_params
                params.permit(:user_id,:title, :body , :tags)
            end

            def auto_del_in_24H(comment_id)
                CommentWorker.perform_in(24.hours,comment_id)
            end

            def auth_comment(comment)
                if($current_user != comment["user_id"])
                    return false
                end
                return true
            end

        end 
    end
end