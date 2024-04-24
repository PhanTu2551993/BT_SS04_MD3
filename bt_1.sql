create database bai_1;
use bai_1;
-- Bước 3: Tiếp theo sử dụng câu lệnh Create Table để tạo bảng Class với các trường ClassId, ClassName, StartDate, Status như sau:
CREATE TABLE Class
(
    ClassID   INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME    NOT NULL,
    Status    BIT
);
-- Bước 4: Tạo bảng Student với các thuộc tính StudentId, StudentName, Address, Phone, Status, ClassId với rằng buộc như sau:
CREATE TABLE Student
(
    StudentId   INT AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address     VARCHAR(50),
    Phone       VARCHAR(20),
    Status      BIT,
    ClassId     INT         NOT NULL,
    FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);
-- Bước 5: Tạo bảng Subject với các thuộc tính SubId, SubName, Credit, Status với các ràng buộc như sau :
CREATE TABLE Subject
(
    SubId   INT AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit  TINYINT     NOT NULL DEFAULT 1 CHECK ( Credit >= 1 ),
    Status  BIT                  DEFAULT 1
);
-- Bước 6: Tạo bảng Mark với các thuộc tính MarkId, SubId, StudentId, Mark, ExamTimes với các ràng buộc như sau :
CREATE TABLE Mark
(
    MarkId    INT AUTO_INCREMENT PRIMARY KEY,
    SubId     INT NOT NULL,
    StudentId INT NOT NULL,
    Mark      FLOAT   DEFAULT 0 CHECK ( Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubId, StudentId),
    FOREIGN KEY (SubId) REFERENCES Subject (SubId),
    FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
);

insert into Class ( ClassName, StartDate, Status)
values ('class1','2024-04-23 08:10:51',1),
        ('class2','2024-04-23 09:10:51',1);

insert into Student(studentname, address, phone, status, classid)
values ('Student 1', 'Address 1', 'Phone 1', 1, 1),
        ('Student 2', 'Address 2', 'Phone 2', 1, 2);
insert into Subject (SubName, Credit, Status)
values ('Subject 1', 3, 1),
         ('Subject 2', 2, 1),
         ('Subject 3', 2, 1);
insert into Mark (SubId, StudentId, Mark, ExamTimes)
values (1, 1, 85.5, 1),
       (2, 2, 90.0, 1),
       (3, 1, 50.0, 1),
       (1, 2, 40.0, 1),
       (3, 2, 30.0, 1);

#hiển thị số lượng sinh viên theo từng địa chỉ nơi ở
select Address, count(*) as 'Số lượng sinh viên'
from Student
group by Address;

#hiển thị các thông tin môn học có điểm thi lớn nhất

select s.SubId, s.SubName , m.Mark as 'Điểm cao nhất'
from Subject s
join Mark m on s.SubId = m.SubId
where m.Mark = (select max(Mark) from Mark);

#tính điểm trung bình các môn học của từng học sinh

select StudentId, avg(Mark) as 'Điểm trung binh'
from Mark
group by StudentId;

#hiển thị các bạn học có điểm trung bình các môn nhỏ hơn 70

select s.StudentId,s.StudentName,avg(m.Mark) as 'Điểm trung bình'
from Student s
join Mark m on s.StudentId = m.StudentId
group by s.StudentId,s.StudentName
having avg(m.Mark) <= 70;

#hiển thị thông tin học viên có điểm trung bình lớn nhất

select s.StudentId,s.StudentName,avg(m.Mark) as 'Điểm trung bình'
from Student s
         join Mark m on s.StudentId = m.StudentId
group by s.StudentId,s.StudentName
having avg(m.Mark) >= all (select avg(Mark) from Mark group by StudentId);

#hiển thị thông tin sinh viên và điểm trung bình của mỗi sinh viên xếp theo giảm dần

select s.StudentId,s.StudentName,s.Address,s.Phone,s.ClassId, avg(m.Mark) as 'Điểm trung bình'
    from Student s
        join Mark m on s.StudentId = m.StudentId
group by s.StudentId,s.StudentName,s.Address,s.Phone,s.ClassId
order by avg(m.Mark) desc