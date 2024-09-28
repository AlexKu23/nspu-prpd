/* Сколько в каждой группе учеников*/ 
SELECT `name`, COUNT(*)  FROM list_of_students JOIN `group` ON id=group_id group by group_id;

/* Найти каких студентов учит преподаватели */ 
SELECT teacher.name, group_concat(student.full_name separator ', ') as `Студенты`
FROM teacher JOIN subject ON teacher.subject_id=subject.id
JOIN `group` ON group.subject_id=subject.id 
JOIN list_of_students ON list_of_students.group_id=group.id 
JOIN student ON student.id=list_of_students.student_id
GROUP BY teacher.id; 

