drop table dml_history
/
CREATE TABLE DML_HISTORY (	
	OPERATION VARCHAR2(200), 
	WHEN TIMESTAMP (6), 
	T_NAME VARCHAR2(30 CHAR), 
	ATTR	varchar2(300),
	BEFORE_VAL varchar2(300),
	AFTER_VAL varchar2(300)
)
/
