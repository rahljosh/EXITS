<cfif isdefined('URL.studentid')>
	<cfset CLIENT.studentid = URL.studentid>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="qGetStudentInfo" datasource="mysql">
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
    	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentid)#">
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
    	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.doublePlacementID)#">
</cfquery>

<cfquery name="get_hf" datasource="MySql">
	SELECT hostid, familylastname, fatherfirstname, fatherlastname, motherfirstname, motherlastname, address, city, state, zip
	FROM smg_hosts
	WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.hostid)#">
</cfquery>

<cfquery name="get_school" datasource="MySql">
	SELECT schoolid, schoolname, address, city, state, zip
	FROM smg_schools
	WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.schoolid)#">
</cfquery>

<link rel="stylesheet" href="../profile.css" type="text/css">

<style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>

<!--- template page header --->
<cfoutput>
<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr>
	<td><img src="../pics/logos/#CLIENT.companyid#.gif"  alt="" border="0" align="left"></td>	
	<td align="center">
		<br><br>
		<font size="+1">REQUEST FOR A DOUBLE PLACEMENT</font>
		<br><br>
	</td>
	<td  align="right"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort_nocolor#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td>
</tr>		
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" >	
	<tr><td class="style1">
		TO : &nbsp; <cfif qGetStudentInfo.schoolid is qGetDoublePlacementInfo.schoolid>#get_school.schoolname#</cfif><br><br></td></tr>
	<tr><td class="style1">
		FROM :  &nbsp; #companyshort.companyname#<br><br></td></tr>
	<tr><td class="style1">
		DATE : &nbsp; #DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br><br></td></tr>
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" >	
	<tr><td class="style1">
    <div align="justify">		
		<p>Request for a Double Placement</p>
		<p>#companyshort.companyname# is requesting a double placement for the following two students:</p>
	 </div></td></tr>
</table>

<table width=650 align="center" cellpadding=8 cellspacing="0" frame="below">
<tr>
	<td width="20" class="style1" valign="top">1.</td>
	<td width="300" class="style1" valign="top">#UCASE(RTRIM(qGetStudentInfo.firstname))# #UCASE(RTRIM(qGetStudentInfo.familylastname))# <br>
		DS2019 no.: &nbsp; #qGetStudentInfo.ds2019_no# <br>
		Program Start Date: &nbsp; #DateFormat(qGetStudentInfo.startdate, 'mm/dd/yyyy')#</td>
	<td width="80" class="style1" valign="top"><p>FROM</p>
	  <p>GENDER</p>
	  </td>
	<td class="style1" valign="top"><p>#UCASE(RTRIM(qGetStudentInfo.countryname))#</p>
	  <p>#UCASE(RTRIM(qGetStudentInfo.sex))#</p></td>
</tr>
<tr>
	<cfif NOT VAL(qGetStudentInfo.doublePlacementID)>
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
</tr>
</table>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
<tr><td class="style1"><div align="justify">
	<p>As you may know, the Department of State requires that the student, the natural family and the international representative 
	agree in writing to any double placements.</p>
	<p>Please sign on the lines below and return to #companyshort.companyshort_nocolor# so that we may finalize the placement.</p>
	</div>
</td></tr>
</table>

<table width=650 border=0 align="center" bgcolor="FFFFFF" cellpadding=4 cellspacing="0">
<tr valign="top">
	<td class="style1" width="280" align="right">Host Mother Name: </td>
	<td class="style1" width="260">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1" width="110"><cfoutput><u>#dateFormat(now(), 'mmm. dd, yyyy')#</u><br>date</cfoutput> </td>
</tr>
<tr>
	<td class="style1" align="right">Print Name: </td>
	<td class="style1" colspan="2"><cfif qGetStudentInfo.hostid is qGetDoublePlacementInfo.hostid><u>#get_hf.motherfirstname# #get_hf.motherlastname#</u><cfelse>__________________________________________________ </cfif> </td>
</tr>
<tr valign="top">
	<td class="style1" align="right">Host Father Name:</td>
	<td class="style1">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1"><cfoutput><u>#dateFormat(now(), 'mmm. dd, yyyy')#</u><br>date</cfoutput> </td>
</tr>
<tr>
	<td class="style1" align="right">Print Name: </td>
	<td class="style1" colspan="2"><cfif qGetStudentInfo.hostid is qGetDoublePlacementInfo.hostid><u>#get_hf.fatherfirstname# #get_hf.fatherlastname#</u><cfelse>__________________________________________________ </cfif></td>
</tr>
<tr>
	<td class="style1" align="right">Address: &nbsp; </td>
	<td class="style1" colspan="2"><cfif qGetStudentInfo.hostid is qGetDoublePlacementInfo.hostid><u>#get_hf.address#</u><cfelse>__________________________________________________ </cfif></td>
</tr>
<tr>
	<td class="style1" align="right">&nbsp;</td>
	<td class="style1" colspan="2"><cfif qGetStudentInfo.hostid is qGetDoublePlacementInfo.hostid><u>#get_hf.city#, #get_hf.state# #get_hf.zip#</u><cfelse>__________________________________________________ </cfif></td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr><td class="style1" colspan="2">
	<div align="justify">
		By signing this, we agree that the two students listed above will live with the above host
		 family while participating in the #companyshort.companyshort_nocolor# Program.</div></td></tr>
<tr><td class="style1">Thank you.</td></tr>
</table>
</cfoutput>		 