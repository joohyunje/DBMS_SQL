SELECT * FROM EMPLOYEES;
-- 관계를 맺은 테이블의 DML
SELECT * FROM TBL_PHONE;
SELECT * FROM TBL_CASE;

-- UPDATE
UPDATE TBL_PHONE
SET PHONE_SERIAL_NUMBER = 'S23-444'
WHERE PHONE_SERIAL_NUMBER = 'S23-001';
-- 자식에서 참조하고 있는 PK 값의 수정은 기본적으로 막혀있다.
-- 일반적으로 부모 테이블의 PK를 수정하는 것은 권장하지 않는다.
-- 그 이유는 일관성을 손상시키고, 무결성에 위배 될 수 있기 때문이다.
-- 하지만, 필요에 따라서 수정해야할 때도 있기 때문에,
-- 아래의 방법을 알려드립니다.


-- 1.
-- 참조중인 값을 NULL 로 변경 후 수정
UPDATE TBL_CASE  
SET PHONE_SERIAL_NUMBER = NULL 
WHERE PHONE_SERIAL_NUMBER = 'S23-001';
-- 자식 테이블의 FK 중, 수정하려는 부모 테이블의 값인 친구들을 NULL 로 바꿔준다.(임시)

UPDATE TBL_PHONE
SET PHONE_SERIAL_NUMBER = 'S23-444'
WHERE PHONE_SERIAL_NUMBER = 'S23-001';

UPDATE TBL_CASE  
SET PHONE_SERIAL_NUMBER = 'S23-444'
WHERE PHONE_SERIAL_NUMBER IS NULL;

-- 2.
-- 부모에 임의의 값을 INSERT 하고
-- 자식 FK 를 수정한 후에 진행한다.
INSERT INTO HR.TBL_PHONE
(PHONE_SERIAL_NUMBER, PHONE_COLOR, PHONE_SIZE, PHONE_PRICE, PHONE_PRODUCTION_DATE, PHONE_SALE)
VALUES('111', '', 0, 0, '', 0);

UPDATE TBL_CASE
SET PHONE_SERIAL_NUMBER = '111'
WHERE PHONE_SERIAL_NUMBER = 'S23-002';

UPDATE TBL_PHONE 
SET PHONE_SERIAL_NUMBER = 'S23-222'
WHERE PHONE_SERIAL_NUMBER = 'S23-002';

UPDATE TBL_CASE 
SET PHONE_SERIAL_NUMBER = 'S23-222'
WHERE PHONE_SERIAL_NUMBER = '111';

DELETE FROM TBL_PHONE
WHERE PHONE_SERIAL_NUMBER = '111';

-- [실습]
/*
	TBL_MEMBER, TBL_BOOK 활용!
	
	회원 정보 추가 (3개 이상)
	책 정보 추가 (3개 이상)
	회원 이름 수정
	책 대여 하기
	책 대여한 회원 번호 수정
	회원 삭제  
  
 */

SELECT * FROM TBL_MEMBER;
SELECT * FROM TBL_BOOK;

-- 회원 정보 추가 (3개 이상)
INSERT INTO HR.TBL_MEMBER
(MEMBER_ID, MEMBER_NAME, MEMBER_AGE, MEMBER_PHONE, MEMBER_ADDRESS)
VALUES(1, '짱구', 10, '010-1234-1234', '서울시 떡잎마을');

INSERT INTO HR.TBL_MEMBER
(MEMBER_ID, MEMBER_NAME, MEMBER_AGE, MEMBER_PHONE, MEMBER_ADDRESS)
VALUES(2, '철수', 10, '010-1234-1111', '서울시 깻잎마을');

INSERT INTO HR.TBL_MEMBER
(MEMBER_ID, MEMBER_NAME, MEMBER_AGE, MEMBER_PHONE, MEMBER_ADDRESS)
VALUES(3, '맹구', 10, '010-1234-2222', '서울시 나뭇잎마을');

-- 책 정보 추가 (3개 이상)
INSERT INTO HR.TBL_BOOK
(BOOK_ID, BOOK_NAME, BOOK_GENRE, MEMBER_ID)
VALUES(1, '로미오와 줄리엣', '로맨스', NULL);

INSERT INTO HR.TBL_BOOK
(BOOK_ID, BOOK_NAME, BOOK_GENRE, MEMBER_ID)
VALUES(2, '셜록홈즈', '추리', NULL);

INSERT INTO HR.TBL_BOOK
(BOOK_ID, BOOK_NAME, BOOK_GENRE, MEMBER_ID)
VALUES(3, '거의 모든 IT의 역사', 'IT', NULL);

-- 회원 이름 수정 (짱구 -> 액션가면)
UPDATE TBL_MEMBER  
SET MEMBER_NAME = '액션가면'
WHERE MEMBER_ID = 1;

-- 책 대여 하기  (액션가면이 1,2번 책), (맹구가 3번 책)
UPDATE TBL_BOOK
SET MEMBER_ID = 1
WHERE BOOK_ID = 1;

UPDATE TBL_BOOK
SET MEMBER_ID = 1
WHERE BOOK_ID = 2;

UPDATE TBL_BOOK
SET MEMBER_ID = 3
WHERE BOOK_ID = 3;

-- 책 대여한 회원 번호 수정
UPDATE TBL_BOOK  
SET MEMBER_ID = NULL
WHERE MEMBER_ID = 1;

UPDATE TBL_MEMBER 
SET MEMBER_ID = 111
WHERE MEMBER_ID = 1;

UPDATE TBL_BOOK  
SET MEMBER_ID = 111
WHERE MEMBER_ID IS NULL;

-- 회원 삭제
UPDATE TBL_BOOK 
SET MEMBER_ID = NULL
WHERE MEMBER_ID = 111;

DELETE FROM TBL_MEMBER
WHERE MEMBER_ID = 111;

SELECT * FROM TBL_MEMBER;
SELECT * FROM TBL_BOOK;
--=========================================================================
-- SEQUENCE
-- 회원과 책 정보를 INSERT 할 때
-- PK를 직접 지어하는 것이 아닌, 시퀀스로 받아올거에요!


TRUNCATE TABLE TBL_BOOK;
DELETE FROM TBL_MEMBER;

-- 시퀀스 생성
CREATE SEQUENCE SEQ_BOOK;
CREATE SEQUENCE SEQ_MEMBER;
DROP SEQUENCE SEQ_BOOK;
DROP SEQUENCE SEQ_MEMBER;

--회원 정보 추가 (3개 이상)
INSERT INTO TBL_MEMBER
VALUES(SEQ_MEMBER.NEXTVAL, '류호근', 22, '010-1111-1222', '수원시 장안구');

INSERT INTO TBL_MEMBER
VALUES(SEQ_MEMBER.NEXTVAL, '홍길동', 23, '010-2222-2222', '수원시 장안구');

INSERT INTO TBL_MEMBER
VALUES(SEQ_MEMBER.NEXTVAL, '강감찬', 25, '010-3333-3333', '수원시 장안구');

SELECT * FROM TBL_MEMBER;

--   책 정보 추가 (3개 이상)
INSERT INTO HR.TBL_BOOK
(BOOK_ID, BOOK_NAME, BOOK_GENRE)
VALUES(SEQ_BOOK.NEXTVAL, '셜록 홈즈', '추리');

INSERT INTO TBL_BOOK
(BOOK_ID, BOOK_NAME, BOOK_GENRE)
VALUES(SEQ_BOOK.NEXTVAL, 'DBMS 완전 정복', 'IT');

INSERT INTO TBL_BOOK
(BOOK_ID, BOOK_NAME, BOOK_GENRE)
VALUES(SEQ_BOOK.NEXTVAL, '그리고 아무도 없었다', '추리');

SELECT * FROM TBL_MEMBER;
SELECT * FROM TBL_BOOK;

-- 관계를 맺은 테이블 간의 데이터의 삭제!
SELECT * FROM TBL_MEMBER;
SELECT * FROM TBL_BOOK;

--   책 대여 하기
UPDATE TBL_BOOK 
SET MEMBER_ID = 1
WHERE BOOK_ID = 1;

UPDATE TBL_BOOK 
SET MEMBER_ID = 1
WHERE BOOK_ID = 2;

UPDATE TBL_BOOK 
SET MEMBER_ID = 3
WHERE BOOK_ID = 3;

-- 자식에서 참조하고 있기 때문에 삭제 불가능!
DELETE FROM TBL_MEMBER
WHERE MEMBER_ID = 1;

-- 1. 자식에서 해당 FK 값을 NULL 로 수정!

-- 2. 자동으로 부모 PK 가 삭제되면
-- 자식에서 해당 PK 값을 참조하고 있던 행도 함께 삭제!
-- FK 제약 조건 뒤에 ON DELETE CASCADE 옵션을 추가함으로써 구현!

-- FK 제약조건 삭제!

ALTER TABLE TBL_BOOK DROP CONSTRAINT FI_BOOK;

ALTER TABLE TBL_BOOK
ADD CONSTRAINT FK_BOOK FOREIGN KEY(MEMBER_ID)
REFERENCES TBL_MEMBER(MEMBER_ID) ON DELETE CASCADE;

DELETE FROM TBL_MEMBER
WHERE MEMBER_ID = 1;

SELECT * FROM TBL_BOOK; 
--============================================================================
-- 이미 만들어진 테이블에 NOT NULL 추가 및 삭제
ALTER TABLE TBL_CAR MODIFY CAR_NAME NOT NULL;
ALTER TABLE TBL_CAR MODIFY CAR_NAME NULL;

-- NVL
SELECT * FROM TBL_BOOK; 
SELECT * FROM TBL_MEMBER; 

INSERT INTO HR.TBL_BOOK
(BOOK_ID, BOOK_NAME, BOOK_GENRE)
VALUES(SEQ_BOOK.NEXTVAL, '셜록 홈즈', '추리');

INSERT INTO TBL_BOOK
(BOOK_ID, BOOK_NAME, BOOK_GENRE)
VALUES(SEQ_BOOK.NEXTVAL, 'DBMS 완전 정복', 'IT');

INSERT INTO TBL_BOOK
(BOOK_ID, BOOK_NAME, BOOK_GENRE)
VALUES(SEQ_BOOK.NEXTVAL, '그리고 아무도 없었다', '추리');

SELECT BOOK_ID, BOOK_NAME, BOOK_GENRE, NVL(MEMBER_ID, -1)
FROM TBL_BOOK;

SELECT BOOK_ID, BOOK_NAME, BOOK_GENRE, NVL2(MEMBER_ID, '대여 중', '대여 가능')
FROM TBL_BOOK;




