require 'sqlite3'
require 'singleton'
require_relative './user'
require_relative './question'
require_relative './reply'
require_relative './question_follower'
require_relative './question_like'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")

    self.results_as_hash = true

    self.type_translation = true
  end
end

u = User.find_by_id(4)
#p u.id, u.fname, u.lname
# p u.authored_questions
#
# p QuestionFollower.followers_for_question_id(2)
# p Reply.find_by_question_id(1)
# p Question.find_by_author_id(1)
# p QuestionFollower.most_followed_questions(2)
# p QuestionLike.num_likes_for_question_id(1)
#
# p QuestionLike.most_liked_questions(2)
# p u.average_karma

u.fname = "Daru"
u.save

u2 = User.new("fname"=>"Mayuri", "lname"=>"Shiina")
u2.save