class Reply
  attr_accessor :reply_id, :question_id, :user_id, :body
  attr_reader :id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_id(id)
    reply = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil unless reply.length > 0

    Reply.new(reply.first)
  end

  def self.find_by_reply_id(reply_id)
    reply = Reply.find_by_id(reply_id)
    raise "#{reply_id} not found in database" unless reply
    replies = QuestionDBConnection.instance.execute(<<-SQL, reply.id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end
  def self.find_by_user_id(user_id)
    user = User.find_by_id(user_id)
    raise "#{user_id} not found in database" unless user
    replies = QuestionDBConnection.instance.execute(<<-SQL, user.id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    question = Question.find_by_id(question_id)
    raise "#{question_id} not found in database" unless question
    replies = QuestionDBConnection.instance.execute(<<-SQL, question.id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end

  def initialize(options)
    @id = options['id']
    @reply_id = options['reply_id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @body = options['body']
  end



  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(@reply_id)
  end

  def child_replies
    Reply.find_by_reply_id(id)
  end


end
