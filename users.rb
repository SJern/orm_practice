class User
  attr_accessor :fname, :lname
  attr_reader :id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(id)
    user = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0

    User.new(user.first)
  end

  def self.find_by_name(fname, lname)
    user = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil unless user.length > 0

    User.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    raise "#{self} not in database" unless @id
    questions = QuestionDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    questions.map { |question| Question.new(question) }
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    raise "#{self} not in database" unless @id
    num_questions_and_likes = QuestionDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        COUNT(DISTINCT questions.id) AS num_questions, COUNT(question_likes.question_id) AS num_likes
      FROM
        users
        JOIN questions ON questions.user_id = users.id
        LEFT JOIN question_likes ON question_likes.question_id = questions.id
      WHERE
        questions.user_id = ? AND question_likes.question_id IS NOT NULL
    SQL
    p num_questions_and_likes

    num_questions_and_likes.first['num_likes'].fdiv(num_questions_and_likes.first['num_questions'])
  end

end
