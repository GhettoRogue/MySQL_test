USE schema_name;

CREATE TABLE table_first_names(
    id_first_names INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE table_last_names(
    id_last_names INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE table_teachers(
    id_teachers INT NOT NULL PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE table_students(
    id_students INT NOT NULL PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE table_subjects(
    id_subjects INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE table_marks(
    id_marks INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    mark INT NOT NULL,
    date_of_mark DATE NOT NULL,
    id_subjects INT NOT NULL,
    id_teachers INT NOT NULL,
    id_students INT NOT NULL,
    FOREIGN KEY (id_subjects)
        REFERENCES table_subjects(id_subjects)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    FOREIGN KEY (id_teachers)
        REFERENCES table_teachers(id_teachers)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    FOREIGN KEY (id_students)
        REFERENCES table_students(id_students)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

CREATE TABLE table_persons(
    id_persons INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_first_names INT NOT NULL,
    id_last_names INT NOT NULL,
    FOREIGN KEY (id_first_names)
        REFERENCES table_first_names(id_first_names)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    FOREIGN KEY (id_last_names)
        REFERENCES table_last_names(id_last_names)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

INSERT INTO schema_name.table_first_names (name)
VALUES ('Vladimir');
INSERT INTO schema_name.table_first_names (name)
VALUES ('Anonim');

INSERT INTO schema_name.table_last_names (name)
VALUES ('Ignatiew');
INSERT INTO schema_name.table_last_names (name)
VALUES ('Anonimus');

INSERT INTO schema_name.table_persons (id_first_names, id_last_names)
VALUES (1, 1);
INSERT INTO schema_name.table_persons (id_first_names, id_last_names)
VALUES (2, 2);

INSERT INTO schema_name.table_subjects (name)
VALUES ('Programming');

INSERT INTO schema_name.table_marks (mark, date_of_mark, id_subjects, id_teachers, id_students)
VALUES (4, '2023-07-14', 1, 2, 1);
INSERT INTO schema_name.table_marks (mark, date_of_mark, id_subjects, id_teachers, id_students)
VALUES (5, '2023-07-14', 1, 2, 1);

CREATE VIEW view_persons AS
    SELECT table_persons.id_persons AS 'id',
           table_last_names.name AS 'last_name',
           table_first_names.name AS 'first_name'
    FROM table_persons
    JOIN table_first_names
        ON table_persons.id_first_names = table_first_names.id_first_names
    JOIN table_last_names
        ON table_persons.id_last_names = table_last_names.id_last_names;

SELECT * FROM view_persons;

CREATE PROCEDURE procedure_add_teacher(IN first_name TEXT,last_name TEXT)
BEGIN
    IF NOT EXISTS(SELECT * FROM table_first_names WHERE name = first_name) THEN
        INSERT INTO table_first_names (name) VALUES (first_name);
    END IF;

    IF NOT EXISTS(SELECT * FROM table_last_names WHERE name = last_name) THEN
        INSERT INTO table_last_names (name) VALUES (last_name);
    END IF;

 INSERT INTO table_persons (id_first_names, id_last_names)
 VALUES ((SELECT table_first_names.id_first_names
         FROM table_first_names
         WHERE name = first_name),
        (SELECT table_last_names.id_last_names
         FROM table_last_names
         WHERE name = last_name));
END;

CALL procedure_add_teacher('Starinin', 'Andrey');

