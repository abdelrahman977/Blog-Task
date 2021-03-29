class CommentJob < ApplicationJob
  queue_as :default

  def perform()
    p "tessttttt"
  end
end
