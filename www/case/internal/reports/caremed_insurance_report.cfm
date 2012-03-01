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
				smg_countrylist.countryname, smg_countrylist.countrycode
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		INNER JOIN smg_programs p ON p.programid = s.programid
		INNER JOIN smg_countrylist ON smg_countrylist.countryid = s.countryresident
		WHERE s.studentid =  #studentid#
		GROUP BY end_date
	</Cfquery>

	#get_student_info.familylastname#, #get_student_info.firstname#, #DateFormat(get_student_info.end_date,'mm/ddyyyy')#, #DateFormat(get_student_info.dob,'mm/ddyyyy')#, #get_student_info.countryname#, #get_student_info.countrycode#<br><cfflush>
</cfloop>
</Cfoutput>


