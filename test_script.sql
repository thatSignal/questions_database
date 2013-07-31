SELECT
  AVG(count)
FROM
  (SELECT
    COUNT(question_likes.liker_id) count
  FROM
    question_likes
  INNER JOIN
    questions ON question_likes.question_id = questions.id
  WHERE
    questions.author_id = 1
  GROUP BY
    questions.id);