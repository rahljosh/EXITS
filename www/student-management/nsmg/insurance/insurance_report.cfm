
<cfquery name = "active_students" datasource="mysql">
Select studentid
from smg_students s
where active = 1 and companyid < 6
</cfquery>


<cfoutput>


<cfloop query="active_students">
	<Cfquery name="get_student_info" datasource="MySQL">
		SELECT distinct MAX(i.insuranceid), s.familylastname, s.firstname, s.studentid, s.hostid, s.flight_info_notes, s.cancelinsurancedate,
				s.insurance, c.companyshort, u.insurance_typeid , u.businessname,
				p.insurance_startdate, p.insurance_enddate, p.programid, p.programname,
				i.new_date, i.end_date, i.sent_to_caremed, i.transtype
		FROM smg_students s
		OUTTER JOIN smg_users u ON u.userid = s.intrep
		OUTTER JOIN smg_programs p ON p.programid = s.programid
		OUTTER JOIN smg_insurance i ON i.studentid = s.studentid
		OUTTER JOIN smg_companies c ON c.companyid = s.companyid
		WHERE s.studentid =  #active_students.studentid#
		Group By i.end_date
			</Cfquery>
			
		#get_student_info.familylastname#,#get_student_info.firstname#
		,#get_student_info.studentid#,#get_student_info.programname#, #get_student_info.programid#, #get_student_info.companyshort#,
			<cfif get_student_info.insurance_enddate is not ''>#DateFormat(get_student_info.insurance_enddate, 'mm/dd/yyyy')#</cfif>,<cfif get_student_info.end_date is not ''>#DateFormat(get_student_info.end_date, 'mm/dd/yyyy')#</cfif>
		
		
		<cfflush> <br>
		
</cfloop>
</cfoutput>





