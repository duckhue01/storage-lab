-- check session isolation level 
SELECT @@SESSION.transaction_isolation, @@SESSION.transaction_read_only;

-- sample schema

CREATE TABLE user ( 
  last_name varchar(50) not null,
  first_name varchar(50)  not null,
  gender enum('m', 'f') not null
);


CREATE TABLE profile ( 
  first_name varchar(50)  not null,
  bio varchar(50)  not null,
);


insert into user (last_name, first_name, gender)  values ('abc', 'abc', 'm');


-- mySQL prevent dirty write in all of the isolation levels despite it use snapshot isolation
-- lock: when we update data the transaction will acquire the lock another transaction want to update this piece of data must wait

-- 1. read uncommitted level

-- set session isolation level
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- transaction 2: 
select * from user

-- transaction 1: 
update user set last_name='abc123' where gender='m';


-- transaction 2: 
select * from user

-- anomaly: dirty read => leading some problems if the application depends on the previous queries to make the decision about what to do next.



-- 2. read committed level

-- set session isolation level
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- using two version to prevent read uncommitted

-- anomaly: non-repeatable read => user can see inconsistent state of database at certain point in time
-- another effects: 
-- backup process 
-- long query 
-- => will see the data at some point in time (some part is old value some part is new) 

-- 3.  Repeatable Read level

-- set session isolation level
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


-- the application logic we have to make sure that only have 2 users have m gender

-- using snapshot isolation: means when start a transaction database create an id for each transaction and any modification is make will be stored. It has visibility rule

-- 1. At the start of each transaction, the database makes a list of all the other transac‐ tions that are in progress (not yet committed or aborted) at that time. Any writes that those transactions have made are ignored, even if the transactions subse‐ quently commit.
-- 2. Any writes made by aborted transactions are ignored.
-- 3. Any writes made by transactions with a later transaction ID (i.e., which started after the current transaction started) are ignored, regardless of whether those transactions have committed.
-- 4. All other writes are visible to the application’s queries.


-- • At the time when the reader’s transaction started, the transaction that created the object had already committed.
-- • The object is not marked for deletion, or if it is, the transaction that requested deletion had not yet committed at the time when the reader’s transaction started.


-- anomaly: phantom read: due to the isolation the transaction don't know about the data it read is outdated or not => when it commit the data outside is changed => premises is no longer true


-- 4.  Serialization level

-- set session isolation level
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- mysql does not use MVCC for serializable isolation level but 2 phase locking

-- The key idea here is that a predicate lock applies even to objects that do not yet exist in the database, but which might be added in the future (phantoms). 

-- • If transaction A wants to read objects matching some condition, like in that SELECT query, it must acquire a shared-mode predicate lock on the conditions of the query. If another transaction B currently has an exclusive lock on any object matching those conditions, A must wait until B releases its lock before it is allowed to make its query.

-- • If transaction A wants to insert, update, or delete any object, it must first check whether either the old or the new value matches any existing predicate lock. If there is a matching predicate lock held by transaction B, then A must wait until B has committed or aborted before it can continue.