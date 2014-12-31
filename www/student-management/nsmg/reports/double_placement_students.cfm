<cfif isdefined('URL.studentID')>
	<cfset CLIENT.studentID = URL.studentID>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_info" datasource="mysql">
	SELECT 
    	s.studentID,
        s.intRep,
    	s.familylastname, 
        s.address,
        s.address2, 
        s.city, 
        s.zip, 
        s.firstname, 
        s.ds2019_no, 
        s.sex,
        s.regionassigned, 
        s.programid, 
        sh.hostID, 
        sh.schoolID,
		sh.arearepID, 
        sh.doublePlacementID, 
		c.countryname,
		p.programname, 
        p.startdate
	FROM 
    	smg_students s
	INNER JOIN
    	smg_hosthistory sh ON sh.studentID = s.studentID
        AND
        	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">        
	INNER JOIN 
    	smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN 
    	smg_programs p ON p.programid = s.programid        
	WHERE 
    	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">
</cfquery>

<!--- Double Placement Student --->
<cfquery name="qGetDoublePlacementInfo" datasource="MySQL">
	SELECT 
    	s.firstname, 
        s.familylastname, 
        s.countryresident, 
        c.countryname, 
        s.schoolid, 
        s.hostid, 
        s.ds2019_no, 
        s.sex,
		p.programname, 
        p.startdate
	FROM 
    	smg_students s
    INNER 
    	JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER 
    	JOIN smg_programs p ON p.programid = s.programid
	WHERE 
    	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.doublePlacementID)#">
</cfquery>

<link rel="stylesheet" href="../profile.css" type="text/css">

<style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>

<!--- include template page header --->
<cfinclude template="report_header.cfm">

<cfoutput>
<table  width=650 align="center" border=0 bgcolor="FFFFFF" >	
	<tr><td class="style1">
    <div align="justify">		
		<p>Request for a Double Placement</p>
		<p>#companyshort.companyname# is requesting a double placement for the following two students:</p>
	 </div></td></tr>
</table>
<br>
<table width=650 align="center" cellpadding=12 cellspacing="0" frame="below">
<tr>
	<td width="20" class="style1" valign="top">1.</td>
	<td width="300" class="style1" valign="top">#UCASE(RTRIM(get_student_info.firstname))# #UCASE(RTRIM(get_student_info.familylastname))# <br>
		DS2019 no.: &nbsp; #get_student_info.ds2019_no# <br>
		Program Start Date: &nbsp; #DateFormat(get_student_info.startdate, 'mm/dd/yyyy')#</td>
	<td width="80" class="style1" valign="top"><p>FROM</p>
    <p>GENDER</p></td>
	<td class="style1" valign="top"><p>#UCASE(RTRIM(get_student_info.countryname))#</p>
	  <p>#UCASE(RTRIM(get_student_info.sex))#</p></td>
</tr>
<tr>
	<cfif get_student_info.doublePlacementID is 0>
		<td colspan="4" class="style1"><b><font color="FF0000">There is no double placement assigned for the student above.</font><font color="FF0000"></font></b></td>
	<cfelse>
	<td class="style1" valign="top">2.</td>
	<td width="300" class="style1" valign="top">#UCASE(RTRIM(qGetDoublePlacementInfo.firstname))# #UCASE(RTRIM(qGetDoublePlacementInfo.familylastname))# <br>
		DS2019 no.: &nbsp; #qGetDoublePlacementInfo.ds2019_no# <br>
		Program Start Date: &nbsp; #DateFormat(qGetDoublePlacementInfo.startdate, 'mm/dd/yyyy')#</td>

	
	 <td width="80" class="style1" valign="top"><p>FROM</p>
    <p>GENDER</p></td>
	<td class="style1" valign="top"><p>#UCASE(RTRIM(qGetDoublePlacementInfo.countryname))#</p>
	  <p>#UCASE(RTRIM(qGetDoublePlacementInfo.sex))#</p></td>
	</cfif>

</table>

<BR>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
<tr><td class="style1"><div align="justify">
	<p>As you may know, the Department of State requires that the student, the natural family and the international representative 
	agree in writing to any double placements.</p>
	<p>Please sign on the lines below and return to #companyshort.companyshort_nocolor# so that we may finalize the placement.</p>
	<p>Thank you.</p>
	</div>
</td></tr>
</table>
</cfoutput>
		
<BR>

<table width=650 border=0 align="center" bgcolor="FFFFFF" cellpadding=6 cellspacing="0">
<tr>
	<td class="style1" width="150" align="right">Student:</td>
	<td class="style1" width="260">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1" width="200"><cfoutput><u>#dateFormat(now(), 'mmm. dd, yyyy')#</u><br>date </cfoutput></td>
</tr>
<tr><td class="style1"><br></td></tr>
<tr>
	<td class="style1" align="right">Print Name:</td>
	<td class="style1" colspan="2">___________________________________________</td>
</tr>
<tr><td class="style1"><br></td></tr>
<tr>
	<td class="style1" align="right">Student:</td>
	<td class="style1">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1"><cfoutput><u>#dateFormat(now(), 'mmm. dd, yyyy')#</u><br>date </cfoutput></td>
</tr>
<tr><td class="style1"><br></td></tr>
<tr>
	<td class="style1" align="right">Print Name:</td>
	<td class="style1" colspan="2">___________________________________________</td>
</tr>
<tr><td class="style1"><br><br></td></tr>
<tr><td class="style1" colspan="3">By signing this, we agree to the double placement.</td></tr>
</table>