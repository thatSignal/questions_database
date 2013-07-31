class Reply
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.id = ?
    SQL

    Reply.new(result.first)
  end

  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.question_id = ?
    SQL
    result.map { |reply| Reply.new(reply) }
  end

  def self.find_by_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.author_id = ?
    SQL

    result.map { |reply| Reply.new(reply) }
  end

  attr_reader :id, :question_id, :parent_id, :author_id, :body

  def initialize(options = {})
    @INSERT_STRING = "(question_id, parent_id, author_id, body)" <<
                     " VALUES (?, ?, ?, ?)"
    @UPDATE_STRING = "question_id = ?, parent_id = ?, author_id = ?, body = ?"
    @TABLE_NAME = "replies"

    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @author_id = options['author_id']
    @body = options['body']
  end

  def author
    User.find_by_id(@author_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.parent_id = ?
    SQL

    result.map { |child| Reply.new(child) }
  end

  def save
    attrs = [@question_id, @parent_id, @author_id, @body, @id]
    super(attrs)
  end

end