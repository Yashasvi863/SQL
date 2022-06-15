An analytic function computes values over a group of rows and returns a single result for each row.

An analytic function includes an OVER clause, which defines a window of rows around the row being evaluated.

We can write complex queries and statistical and computational operations on the data using these window functions.

There are 3 types of window functions :

1.Ranking function	:      RANK, DENSE_RANK, ROW_NUMBER and NTILE

2.Aggregate function	:      SUM, MIN, MAX, AVG and COUNT

3.Value functions	:      LEAD, LAG, FIRST_VALUE and LAST_VALUE

The database on hand consists of 2 tables namely, patient details and patient tests.


These datasets focus primarily on the blood screen results of 11 patients suspected to be experiencing renal failure disorder .

The dataset consists of the tests that were recorded in December 2020 – January 2021.

Patient Details consists  of information related to the patient’s first name, last name, age , gender and their body mass index (BMI).

Patient Tests contains the results of their blood work along with their vitals 
        measured during the test and the fee charged for each visit .
