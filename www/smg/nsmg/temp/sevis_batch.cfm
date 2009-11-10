<cfquery name="jan_students" datasource="mysql">
select 
s.studentid, s.dateapplication, s.active, s.ds2019_no, s.firstname, s.familylastname, s.middlename, s.dob, s.sex,	s.citybirth, s.hostid, s.schoolid, s.host_fam_approved, s.ayporientation, s.aypenglish, h.familylastname as hostlastname, h.fatherlastname, h.motherlastname, h.address as hostaddress, h.address2 as hostaddress2, h.city as hostcity, h.state as hoststate, h.zip as hostzip, u.businessname FROM smg_students s INNER JOIN smg_programs p ON s.programid = p.programid INNER JOIN smg_users u ON s.intrep = u.userid LEFT JOIN smg_hosts h ON s.hostid = h.hostid WHERE s.programid = 249 or s.programid = 235 or s.programid = 257  ORDER BY u.businessname, s.familylastname, s.firstname
</cfquery>

<cfdump var="#jan_students#">
<!----
<cfloop query="update_sevis_Status">
INSERT INTO smg_sevis_history (batchid, studentid, hostid, school_name, start_date, end_date)	
			VALUES (9999, #studentid#, #
</cfloop>
---->