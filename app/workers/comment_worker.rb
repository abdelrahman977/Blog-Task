require 'sidekiq-scheduler'

class CommentWorker
  include Sidekiq::Worker

  def perform(comment_id)
    comment = Comment.find(comment_id)
    comment.destroy
  end
end
