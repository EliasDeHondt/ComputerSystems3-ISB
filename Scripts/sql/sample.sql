/***************************************
 *   @Created by Elias De Hondt        *
 *   @Visit https://eliasdh.com        *
 *   @since 11/10/2024                 *
 ***************************************/

-- 1
SELECT * FROM ibmuser.emp;

-- 2
SELECT job FROM ibmuser.emp;

-- 3
SELECT lastname, empno, phoneno FROM ibmuser.emp;

-- 4
SELECT firstnme FROM ibmuser.emp WHERE job = 'MANAGER';

-- 5
SELECT COUNT(*) FROM ibmuser.emp;
SELECT AVG(salary) FROM ibmuser.emp;
SELECT SUM(salary) FROM ibmuser.emp;
SELECT MAX(salary) FROM ibmuser.emp;
SELECT MIN(salary) FROM ibmuser.emp;

-- 6
SELECT deptname, COUNT(empno)
        FROM ibmuser.dept D, ibmuser.emp E
        WHERE D.deptno = E.workdept
        GROUP BY deptname
        ORDER BY deptname;

-- 7 (challenge)
SELECT D.deptname, MAX(E.salary + E.comm + E.bonus) AS MAX_COMPENSATION
        FROM ibmuser.dept D, ibmuser.emp E
        WHERE D.deptno = E.workdept
        GROUP BY D.deptname
        ORDER BY D.deptname;