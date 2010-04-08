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

<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	<cfif check_insurance.insurance_policy_type is 'none' or check_insurance.insurance_policy_type is ''><cfelse> 
		<!--- new insurance file --->
		<cfif form.insu_new_date is not '' and not IsDefined('form.insuranceid')> 
			<cfquery name="check_insu" datasource="caseusa">
				SELECT studentid
				FROM smg_insurance WHERE sent_to_caremed is NULL AND studentid = '#client.studentid#'
			</cfquery>
			<cfif check_insu.recordcount is '0'>
				<cfquery name="insert_new_correction" datasource="caseusa">
					INSERT INTO smg_insurance
						(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype, type)
					VALUES
						('#client.studentid#', '#get_students.firstname#', '#get_students.familylastname#', '#get_students.sex#', 
						#CreateODBCDate(get_students.dob)#, '#get_students.countrycode#',
						#CreateODBCDate(form.insu_new_date)#, #CreateODBCDate(get_students.insurance_enddate)#, '#get_students.orgcode#',
						<cfif get_students.insurance_policy_type is 'non-deductible'>'#get_students.insurance_policy_non_ded#',
							<cfelseif get_students.insurance_policy_type is 'deductible'>'#get_students.insurance_policy_deductible#',
							<cfelse>'#get_students.insurance_policy_gold#',</cfif> 
						'#form.insu_trans_type#', 'arrival');	
				</cfquery>
			</cfif>
		</cfif>
		
		<!--- Update insurance file --->
		<cfif form.insu_new_date is not '' and IsDefined('form.insuranceid')> 
			<cfquery name="update_correction" datasource="caseusa"> <!--- that has not been sent_to_caremed to caremed --->
				UPDATE smg_insurance
				set new_date = #CreateODBCDate(form.insu_new_date)#
				WHERE insuranceid = '#form.insuranceid#'
				LIMIT 1
			</cfquery>
		</cfif>
	</cfif>
</cftransaction>

<cflocation url="../insurance/insurance_management.cfm"> 