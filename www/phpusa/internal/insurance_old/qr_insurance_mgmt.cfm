<cfquery name="get_student" datasource="MySQL">
	SELECT s.studentid, s.firstname, s.familylastname, s.sex, s.dob, s.studentid, s.uniqueid,
		 u.businessname, u.insurance_typeid,
		 p.insurance_startdate, p.insurance_enddate, 
		 c.countrycode, c.countryname
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	INNER JOIN smg_users u 		ON u.userid = s.intrep  
	INNER JOIN smg_programs p 	ON stu_prog.programid = p.programid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	INNER JOIN smg_companies co ON s.companyid = co.companyid
	LEFT JOIN smg_insurance_codes insu_codes ON (u.insurance_typeid = insu_codes.insutypeid AND s.companyid = insu_codes.companyid AND p.seasonid = insu_codes.seasonid)
	WHERE stu_prog.assignedid = <cfqueryparam value="#form.assignedid#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

<cfquery name="get_last_insu_record" datasource="MySql">
	SELECT insuranceid, companyid, studentid, org_code, policy_code, country_code
	FROM smg_insurance
	WHERE studentid = <cfqueryparam value="#get_student.studentid#" cfsqltype="cf_sql_integer">
		AND sent_to_caremed IS NOT NULL
	ORDER BY insuranceid DESC
</cfquery>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	<!--- GET VSC GROUP --->
	<cfquery name="get_group" datasource="MySql">
		SELECT groupid, insutypeid, vsc_group
		FROM smg_insurance_vsc_group
		WHERE insutypeid = 	'#get_last_insu_record.policy_code#'
			AND MONTH(startdate) = #DateFormat(insu_new_date, 'mm')#
			AND YEAR(startdate) = #DateFormat(insu_new_date, 'yyyy')#
	</cfquery>

	<!--- NEW INSURANCE RECORD --->
	<cfif form.insu_new_date NEQ '' AND form.insu_end_date NEQ '' AND NOT IsDefined('form.insuranceid')> 
		<cfquery name="check_insu" datasource="MySql">
			SELECT studentid
			FROM smg_insurance WHERE sent_to_caremed is NULL 
				AND studentid = '#get_student.studentid#'
		</cfquery>
		<cfif check_insu.recordcount EQ '0'>
			<cfquery name="insert_new_record" datasource="MySql">
				INSERT INTO smg_insurance
					(companyid, vsc_group, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
				VALUES
					('6', '#get_group.vsc_group#', '#get_student.studentid#', '#get_student.firstname#', '#get_student.familylastname#', '#get_student.sex#', 
					#CreateODBCDate(get_student.dob)#, 
					<cfif get_student.insurance_typeid GTE 7 AND get_student.insurance_typeid LTE 10> <!--- VSC --->
						'#get_student.countryname#',
					<cfelse> <!--- CAREMED --->
						'#get_student.countrycode#',
					</cfif> 
					#CreateODBCDate(form.insu_new_date)#,
					#CreateODBCDate(form.insu_end_date)#, '#get_last_insu_record.org_code#', '#get_last_insu_record.policy_code#', '#form.insu_trans_type#')	
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- UPDATE INSURANCE RECORD --->
	<cfif form.insu_new_date NEQ '' AND form.insu_end_date NEQ '' AND IsDefined('form.insuranceid')> 
		<cfquery name="update_correction" datasource="MySql"> <!--- that has not been sent_to_caremed to caremed --->
			UPDATE smg_insurance
			SET companyid = '6',
				vsc_group = '#get_group.vsc_group#',
				org_code = '#get_last_insu_record.org_code#',
				policy_code = '#get_last_insu_record.policy_code#',
				new_date = #CreateODBCDate(form.insu_new_date)#,
				end_date = #CreateODBCDate(form.insu_end_date)#,
				firstname = '#get_student.firstname#',
				lastname = '#get_student.familylastname#',
				sex = '#get_student.sex#',
				dob = #CreateODBCDate(get_student.dob)#,
				<cfif get_student.insurance_typeid GTE 7 AND get_student.insurance_typeid LTE 10> <!--- VSC - COUNTRY NAME --->
					country_code = '#get_student.countryname#'
				<cfelse> <!--- CAREMED - COUNTRY CODE --->
					country_code = '#get_student.countrycode#'
				</cfif> 
			WHERE insuranceid = '#form.insuranceid#'
			LIMIT 1
		</cfquery>
	</cfif>
</cftransaction>

<cflocation url="insurance_mgmt.cfm?unqid=#get_student.uniqueid#&assignedid=#form.assignedid#" addtoken="no">
