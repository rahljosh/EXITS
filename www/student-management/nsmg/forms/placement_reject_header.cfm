<link rel="stylesheet" href="../smg.css" type="text/css">
<link rel="stylesheet" href="profile.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_region_assigned" datasource="MySQL">
	SELECT smg_students.regionassigned, smg_regions.regionname
	FROM smg_students 
	RIGHT JOIN smg_regions on smg_students.regionassigned = smg_regions.regionid
	WHERE studentid = #client.studentid#
</cfquery>
<title>Pending Placement Rejection</title>

<cfoutput>
<table width="580" align="center">
<tr><td><span class="application_section_header">#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</span></td></tr>
</table>
  <table width="580" align="center">
    <tr>
      <td><span class="application_section_header">Placement Rejection</span></td>
    </tr>		
<tr><td>		
<div align="center">#get_student_info.firstname# is being rejected as of #DateFormat(now(), 'ddd. mmm. d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')# </div>		
</td></tr>
</table>
</cfoutput>


