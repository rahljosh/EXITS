<cfquery name="ins_stu" datasource="mysql">
SELECT DISTINCT smg_flight_info.studentid, smg_flight_info.dep_date,
stu.studentid, stu.firstname, stu.familylastname, stu.dob, stu.schoolid, stu.programid, stu.programid AS stu_program_id,
smg_insurance_type.insutypeid, smg_insurance_type.type,  smg_insurance_codes.policycode, smg_insurance_type.insutypeid, 
smg_programs.startdate, smg_programs.enddate,  smg_programs.seasonid, smg_programs.insurance_startdate, smg_programs.insurance_enddate, smg_programs.enddate AS program_end_Date
FROM smg_flight_info
LEFT JOIN smg_students stu ON smg_flight_info.studentid = stu.studentid
LEFT JOIN smg_programs ON smg_programs.programid = stu.programid
LEFT JOIN smg_users ON smg_users.userid = stu.intrep
LEFT JOIN smg_insurance_type ON smg_insurance_type.insutypeid = smg_users.insurance_typeid
LEFT JOIN smg_insurance_codes ON smg_insurance_codes.insutypeid = smg_insurance_type.insutypeid

WHERE smg_flight_info.flight_type = 'departure'
AND smg_flight_info.dep_date < '2009-06-30'
AND smg_programs.active =1
AND stu.companyid =1
AND stu.active =1
AND insurance_batch =1
AND smg_users.insurance_typeid >10
AND (

smg_programs.programid =234
OR smg_programs.programid =217
OR smg_programs.programid =215
OR smg_programs.programid =261
)
group BY policycode

</cfquery>

<cfdump var="#ins_stu#">