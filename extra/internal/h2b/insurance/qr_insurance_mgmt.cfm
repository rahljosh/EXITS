<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance Management Update</title>
</head>

<body>

<cfquery name="get_candidate" datasource="MySQL">
	SELECT can.candidateid, can.uniqueid, can.firstname, can.lastname, can.sex, can.dob,
		 u.extra_insurance_typeid,
		 p.insurance_startdate, p.insurance_enddate, 
		 c.countrycode,
		 co.orgcode,
		 insu_codes.policycode
	FROM extra_candidates can
	INNER JOIN smg_users u 		ON u.userid = can.intrep  
	INNER JOIN smg_programs p 	ON p.programid = can.programid
	LEFT JOIN smg_countrylist c 	ON c.countryid = can.residence_country
	INNER JOIN smg_companies co 	ON co.companyid = can.companyid
	LEFT JOIN smg_insurance_codes insu_codes ON (u.extra_insurance_typeid = insu_codes.insutypeid AND can.companyid = insu_codes.companyid)<!--- TAKE THIS LINE OUT FOR TRAINEE AND p.seasonid = insu_codes.seasonid --->
	WHERE candidateid = <cfqueryparam value="#form.candidateid#" cfsqltype="cf_sql_integer">
</cfquery>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	
	<!--- NEW INSURANCE RECORD --->
	<cfif NOT IsDefined('form.insuranceid') AND  form.new_start_date NEQ '' AND form.new_end_date NEQ ''> 
		<cfquery name="check_insu" datasource="MySql">
			SELECT candidateid
			FROM extra_insurance_history 
			WHERE filed_date IS NULL 
				AND candidateid = '#get_candidate.candidateid#'
		</cfquery>
		<cfif check_insu.recordcount EQ 0>
			<cfquery name="insert_new_record" datasource="MySql">
				INSERT INTO extra_insurance_history
					(candidateid, firstname, lastname, sex, dob, country_code, start_date, end_date, org_code, policy_code, transtype)
				VALUES
					('#get_candidate.candidateid#', '#get_candidate.firstname#', '#get_candidate.lastname#', '#get_candidate.sex#', 
					#CreateODBCDate(get_candidate.dob)#, '#get_candidate.countrycode#', #CreateODBCDate(form.new_start_date)#,
					#CreateODBCDate(form.new_end_date)#, '#get_candidate.orgcode#', '#get_candidate.policycode#', '#form.insu_trans_type#');	
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- UPDATE INSURANCE RECORD - IT HAS NOT BEEN FILED --->
	<cfif IsDefined('form.insuranceid') AND form.start_date NEQ '' AND form.end_date NEQ ''> 
		<cfquery name="update_correction" datasource="MySql">
			UPDATE extra_insurance_history
			SET start_date = #CreateODBCDate(form.start_date)#,
				end_date = #CreateODBCDate(form.end_date)#
			WHERE insuranceid = '#form.insuranceid#'
			LIMIT 1
		</cfquery>
	</cfif>
</cftransaction>

<cflocation url="insurance_mgmt.cfm?uniqueid=#get_candidate.uniqueid#">

</body>
</html>