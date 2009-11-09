<link rel="stylesheet" href="../smg.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">
<cfinclude template = "placement_reject_header.cfm">

<!-- USE THIS TO GET THE REGIONAL DIRECTOR WHO WANTS TO BE CC'ED ON THE E-MAIL -->
<cfquery name="get_region_assigned" datasource="MySQL">
	SELECT regionname
	FROM smg_regions
	WHERE regionid = #get_student_info.regionassigned#
</cfquery>

<br><br>
<cfform action="../querys/update_reject_host.cfm?studentid=#client.studentid#" method="post">
  <table width="580" align="center">
    <tr align="center">
      <td> Please provide details as to why you are rejecting this placement:<br><br>
          <textarea cols=50 rows =7 name="reason">Placement Rejection:</textarea>  
      </td>
    </tr>
  </table>
  <br>
  <table width="580" align="center">
  	<tr align="center">
  		<td align="center" width="50%">
          <input name="submit" type="image" src="../pics/update.gif" align="middle" border="0">
</td>
    </tr>
  </table>
</cfform>