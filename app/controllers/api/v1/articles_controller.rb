module Api
    module V1
        class ArticlesController < ApplicationController
            before_action :authenticate_request

            def index
                articles = Article.order('created_at DESC');
                render json: {status: 'SUCCESS', message:'Loaded articles', data:articles},status: :ok
            end
            
            def show
                article = Article.find(params[:id])
                render json: {status: 'SUCCESS', message:'Loaded article', data:article},status: :ok
            end

            def create
                article = Article.create('user_id'=> $current_user,'title'=>  params[:title],'body'=> params[:body],'tags'=> params['tags'])
                if article.save
                render json: {status: 'SUCCESS', message:'Saved article', data:article},status: :ok
                else
                render json: {status: 'ERROR', message:'Article not saved', data:article.errors},status: :unprocessable_entity
                end
            end

            def destroy
                article = Article.find(params[:id])
                if !auth_article(article)
                    render json: {status: 'ERROR', message:'unauthorized', authorized_user:article['user_id']},status: :unauthorized
                else
                    article.destroy
                    render json: {status: 'SUCCESS', message:'Deleted article', data:article},status: :ok
                end
            end

            def update
                article = Article.find(params[:id])
                if !auth_article(article)
                    render json: {status: 'ERROR', message:'unauthorized', authorized_user:article['user_id']},status: :unauthorized
                else
                    if article.update(article_params)
                        render json: {status: 'SUCCESS', message:'Updated article', data:article},status: :ok
                    else
                        render json: {status: 'ERROR', message:'Article not updated', data:article.errors},status: :unprocessable_entity
                    end
                end
            end

            def show_comments
                comments = Comment.where('article_id' => params[:id])
                render json: {status: 'SUCCESS', message:'Loaded article comments', data:comments},status: :ok
            end

            def article_params
                params.permit(:user_id,:title, :body , :tags)
            end

            def auth_article(article)
                if($current_user != article["user_id"])
                    return false
                end
                return true
            end

        end 
    end
end