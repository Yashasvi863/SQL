create database mini_project;
use mini_project;

select * from patient_details;
select * from patient_tests;


alter table patient_details add primary key (patient_id);
alter table patient_tests add foreign key (patient_id) references patient_details(patient_id);

desc patient_details;
desc patient_tests;

-- FIRST VALUE()

-- 1.Track the condition of the patients against their initial diagnosis.

select patient_id,`Pre-existing Medical Condition`,test_date,first_value(`Condition`) 
over(partition by patient_id order by test_date,`Condition`) as First_diagnosis,`Condition` as Present_condition
from patient_tests;

-- 2. How much has the permissible water and sodium intake changed since the patient’s first visit ?

select patient_id,test_date,first_value(water_intake) 
over(partition by patient_id order by test_date) as Initial_water_intake,`Condition` as present_condition,water_intake
from patient_tests;


select patient_id,test_date,`Blood Sugar Level`,BP,`Condition` as present_condition,sodium_intake,first_value(sodium_intake)
over(partition by patient_id order by `Blood Sugar Level`,BP) as Initial_sodium_intake
from patient_tests;

-- 3. Has the patient’s Glomerular Filtration Rate (GFR) improved or deteriorated since the first test ?

select patient_id,test_date,
first_value(GFR) over (partition by patient_id order by test_date) as initial_filtration_rate,GFR as present_filtration_rate
from patient_tests;


-- LEAD()

-- 1. When is the patient due for their next consultation ?

select patient_id,test_date,`Condition`,lead(test_date,1) over(partition by patient_id) as Next_consultation_date from patient_tests;

-- 2. Checking if there are any improvement in the vitals and GFR of the patients .

select patient_id,BP as previous_BP_reading,lead(BP,1) over(partition by patient_id) as current_BP,
`Blood Sugar Level` as previous_FBS,lead(`Blood Sugar Level`,1) over(partition by patient_id) as current_FBS,
GFR as previous_GFR_reading,lead(GFR,1) over (partition by patient_id) as current_GFR_reading
from patient_tests;

-- 3. Is there a change in the condition of the patients since the previous consultation?

select patient_id,test_date,`Condition` as previous_diagnosis,
lead(`Condition`,1) over(partition by patient_id) as current_diagnosis
from patient_tests;


-- LAG()

-- 1. Has there been a decrease in the patient’s dialysis fee?

select patient_id,test_date,dialysis_fee,lag(dialysis_fee,1) over(order by patient_id) as previous_dialysis_fees from patient_tests;

-- 2. How long has it been since the last blood test ?

select patient_id,test_date,`Condition`,lag(test_date,1) over(partition by patient_id) as Previous_test_date from patient_tests;

-- 3. Is there a significant difference in the total fee paid by the patient ?

select patient_id,test_date,total_fee,lag(total_fee,1)over(partition by patient_id) as previous_dues from patient_tests;



-- NTILE()

-- 1.

select  patient_id,total_fee,ntile(6) over(partition by total_fee order by patient_id) from patient_tests;

-- 2 
select patient_id,`Condition`,test_date,ntile(4) over(partition by day(test_date)) from patient_tests;

SELECT *, NTILE(10) OVER () from patient_tests;


-- AGG FUNCTIONS WITH JOINS/SUBQUERY

-- 1. Fetching the patients’  names against their initial diagnostic report  from their patient ID.

select a.patient_id,first_name,last_name,bmi,test_date,`Condition` as Initial_diagnosis from patient_tests a
join patient_details b
on a.patient_id = b.patient_id
group by patient_id;

-- 2. Finding the total number of consultations and total medical costs of each patient .

select a.patient_id,a.first_name,a.last_name,count(b.patient_id) as total_number_of_consultations,sum(total_fee) as total_medical_costs 
from patient_details a
join patient_tests b
on a.patient_id = b.patient_id
group by a.patient_id;

-- 3.Which patients received medical bills less than the average of the total fee paid by all the patients in the month of December ?

select avg(total_fee) from patient_tests;

select patient_id,sum(total_fee) as medical_bill from patient_tests
group by patient_id
having sum(total_fee) < (select avg(total_fee) from patient_tests);

-- 4. Which patient had the highest number of consultations?

select a.patient_id,b.first_name,b.last_name,count(a.patient_id) as highest_consultations from patient_tests a
join patient_details b
on a.patient_id = b.patient_id
group by a.patient_id
order by count(a.patient_id) desc
limit 1;

-- 5. Fetching  the recent diagnosis for all the patients listed in the patient details dataset.

select a.patient_id,first_name,last_name,max(test_date) as last_consultation_date,
last_value(`Condition`) over(partition by patient_id order by test_date desc) as Diagnosis 
from patient_details a join patient_tests b
on a.patient_id = b.patient_id
group by patient_id;




