<cfquery name="check_insurance" datasource="caseusa">
	SELECT studentid, insurance_policy_type, businessname
	FROM smg_students
	INNER JOIN smg_users ON smg_users.userid = smg_students.intrep
	WHERE studentid = '#client.studentid#'
</cfquery>

<cfquery name="get_students" datasource="caseusa">
  SELECT 
		s.firstname, s.familylastname, s.sex, s.dob, s.studentid,
		u.insurance_policy_type,
		p.insurance_enddate, 
		c.countrycode,
		co.orgcode, co.insurance_policy_non_ded, co.insurance_policy_deductible, co.insurance_policy_gold
  FROM 	smg_students s
  INNER JOIN smg_users u 		ON u.userid = s.intrep  
  INNER JOIN smg_programs p 	ON s.programid = p.programid
  INNER JOIN smg_countrylist c 	ON s.countryresident = c.countryid
  INNER JOIN smg_companies co 	ON s.companyid = co.companyid	
  WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cflocation url="../insurance/insurance_management.cfm"> 