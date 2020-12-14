--What grades are stored in the database?
-- EXPECTED: 1st Grade, 2nd Grade, 3rd Grade, 4th Grade, 5th Grade

--What emotions may be associated with a poem?
-- EXPECTED: Anger, Fear, Sadness, Joy

--How many poems are in the database?
--EXPECTED: 32,842

--Sort authors alphabetically by name. What are the names of the top 76 authors?
--EXPECTED: .lilly - abdul

--Starting with the above query, add the grade of each of the authors.
--EXPECTED: .lilly - abdul

--Starting with the above query, add the recorded gender of each of the authors.
--EXPECTED: --EXPECTED: .lilly - abdul

--What is the total number of words in all poems in the database?
--EXPECTED: 374,584

--Which poem has the fewest characters?
--EXPECTED: Hi

--How many authors are in the third grade?
--EXPECTED: 2,344

--How many authors are in the first, second or third grades?
--EXPECTED: 1st: 623, 2nd: 1,437, 3rd: 2,344

--What is the total number of poems written by fourth graders?
-- EXPECTED: 10,806

--How many poems are there per grade?
-- EXPECTED: 1st: 886, 2nd: 3,160, 3rd: 6,636, 4th: 10,806, 5th: 11,354

--How many authors are in each grade? (Order your results by grade starting with 1st Grade)
--EXPECTED: 1st: 623, 2nd: 1,437, 3rd: 2,344, 4th: 3,288, 5th: 3,464

--What is the title of the poem that has the most words?
--EXPECTED: The Misterious Black

--Which author(s) have the most poems? (Remember authors can have the same name.)
--EXPECTED: TOP 3 jessica(118) emily(115) emily(98)

--How many poems have an emotion of sadness?
--EXPECTED: 14,570

--How many poems are not associated with any emotion?
--EXPECTED: 3,368

--Which emotion is associated with the least number of poems?
--EXPECTED: Anger

--Which grade has the largest number of poems with an emotion of joy?
--EXPECTED: 5th Grade

--Which gender has the least number of poems with an emotion of fear?
-- EXPECTED: Ambiguous 



------------------------------------------------------------------------------------------------
--********                                      QUERIES                               ********--
------------------------------------------------------------------------------------------------


-- What grades are stored in the database?
SELECT Name FROM Grade;


-- What emotions may be associated with a poem?
SELECT Name FROM Emotion;


-- How many poems are in the database?
SELECT COUNT(*) as PoemCount FROM Poem;


-- Sort authors alphabetically by name. What are the names of the top 76 authors?
SELECT TOP 76 Name 
FROM Author
ORDER BY Name ASC;


-- Starting with the above query, add the grade of each of the authors.
SELECT TOP 76 a.Name, g.Name as Grade 
FROM Author a
JOIN Grade g ON a.GradeId = g.Id


-- Starting with the above query, add the recorded gender of each of the authors.
SELECT TOP 76 a.Name as Author, gr.Name as Grade, ge.Name as Gender 
FROM Author a
JOIN Grade gr ON a.GradeId = gr.Id
JOIN Gender ge ON a.GenderId = ge.Id


-- What is the total number of words in all poems in the database?
SELECT SUM(WordCount) as TotalWords FROM Poem;


-- Which poem has the fewest characters?
SELECT TOP 1 Title FROM Poem
ORDER BY CharCount ASC


-- How many authors are in the third grade?
SELECT COUNT(*) as ThirdGradeAuthors
FROM Author a
JOIN Grade g ON a.GradeId = g.Id
WHERE g.Name = '3rd Grade'


-- How many authors are in the first, second or third grades?
SELECT COUNT(*) as AuthorCount, g.Name
FROM Author a
JOIN Grade g ON a.GradeId = g.Id
WHERE g.Name IN ('1st Grade', '2nd Grade', '3rd Grade')
GROUP BY g.Name


-- What is the total number of poems written by fourth graders?
SELECT COUNT(p.Id) as FourthGradePoemCount
FROM Author a
JOIN Grade g ON a.GradeId = g.Id
JOIN Poem p ON p.AuthorId = a.Id
WHERE g.Name = '4th Grade'


-- How many poems are there per grade?
SELECT COUNT(p.Id) as PoemCount, g.Name
FROM Poem p
JOIN Author a ON p.AuthorId = a.Id
JOIN Grade g ON a.GradeId = g.Id
GROUP BY g.Name


-- How many authors are in each grade? (Order your results by grade starting with 1st Grade)
SELECT COUNT(a.Id) as AuthorCount, g.Name
FROM Author a
JOIN Grade g ON a.GradeId = g.Id
GROUP BY g.Name
ORDER BY g.Name


-- What is the title of the poem that has the most words?
SELECT TOP 1 Title
FROM Poem
ORDER BY WordCount DESC


-- Which author(s) have the most poems? (Remember authors can have the same name.)
SELECT a.Name, COUNT(p.Id) as PoemCount
FROM Author a
JOIN Poem p ON p.AuthorId = a.Id
GROUP BY a.Id, a.Name
ORDER BY COUNT(p.Id) DESC


-- How many poems have an emotion of sadness?
SELECT COUNT(*) as SadPoemCount
FROM Poem p
JOIN PoemEmotion pe ON pe.PoemId = p.Id
JOIN Emotion e ON pe.EmotionId = e.Id
WHERE e.Name = 'Sadness'


-- How many poems are not associated with any emotion?
SELECT COUNT(*) AS EmotionlessPoems
FROM Poem p
LEFT JOIN PoemEmotion pe ON pe.PoemId = p.Id
WHERE pe.Id IS NULL


-- Which emotion is associated with the least number of poems?
SELECT TOP 1 e.Name
FROM Poem p
JOIN PoemEmotion pe ON pe.PoemId = p.Id
JOIN Emotion e ON pe.EmotionId = e.Id
GROUP BY e.Name
ORDER BY COUNT(e.Id)


-- Which grade has the largest number of poems with an emotion of joy?
SELECT TOP 1 g.Name 
FROM Poem p
JOIN PoemEmotion pe ON pe.PoemId = p.Id
JOIN Emotion e ON pe.EmotionId = e.Id
JOIN Author a ON p.AuthorId = a.Id
JOIN Grade g ON a.GradeId = g.Id
WHERE e.Name = 'Joy'
GROUP BY g.Name
ORDER BY COUNT(p.Id) DESC


-- Which gender has the least number of poems with an emotion of fear?
SELECT TOP 1 g.Name
FROM Poem p
JOIN PoemEmotion pe ON pe.PoemId = p.Id
JOIN Emotion e ON pe.EmotionId = e.Id
JOIN Author a ON p.AuthorId = a.Id
JOIN Gender g ON a.GenderId = g.Id
WHERE e.Name = 'Fear'
GROUP BY g.Name
ORDER BY COUNT(p.Id) ASC