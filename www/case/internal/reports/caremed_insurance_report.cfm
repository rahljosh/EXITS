<cfquery name = "active_students" datasource="caseusa">
Select studentid
from smg_students s
where active = 1 and companyid < 6
</cfquery>


<Cfoutput>
<cfloop query="active_students">
	<Cfquery name="get_student_info" datasource="caseusa">
		SELECT   s.familylastname, s.firstname, s.dob, s.studentid, s.hostid, s.flight_info_notes, s.cancelinsurancedate, s.countryresident,
				s.insurance, u.insurance_typeid , u.businessname,
				p.insurance_startdate, p.insurance_enddate,
				i.new_date, i.end_date, i.sent_to_caremed, i.transtype, i.insuranceid,
				smg_countrylist.countryname, smg_countrylist.countrycode
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		INNER JOIN smg_programs p ON p.programid = s.programid
		INNER JOIN smg_insurance i ON i.studentid = s.studentid
		INNER JOIN smg_countrylist ON smg_countrylist.countryid = s.countryresident
		WHERE s.studentid =  #studentid#
		GROUP BY end_date
	</Cfquery>

	#get_student_info.familylastname#, #get_student_info.firstname#, #DateFormat(get_student_info.end_date,'mm/ddyyyy')#, #DateFormat(get_student_info.dob,'mm/ddyyyy')#, #get_student_info.countryname#, #get_student_info.countrycode#<br><cfflush>
</cfloop>
</Cfoutput>
<!----
<cfquery name="get_insurance" datasource="caseusa">
	SELECT insuranceid, new_date, end_date, sent_to_caremed, transtype
	FROM smg_insurance
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
		AND companyid = '#client.companyid#'
	ORDER BY insuranceid
</cfquery>
---->



