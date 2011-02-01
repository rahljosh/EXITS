<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Pending Placements</title>
</head>

<body>

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.form.sele_region.options[document.form.sele_region.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<div class="application_section_header">Pending Placements</div>

<!--- Office --->
<cfif client.usertype LTE 4>

	<cfquery name="pending_hosts" datasource="MySQL">
		SELECT 
        	s.host_fam_approved, 
            s.studentid, 
            s.hostid, 
            s.firstname, 
            s.familylastname as student_lastname, 
            s.regionassigned, 
            s.dateplaced,
			h.familylastname, 
            h.fatherfirstname, 
            h.fatherlastname, 
            h.motherlastname, 
            h.motherfirstname, 
            h.city, 
            h.state,  
			p.programname,
            c.companyShort,
            r.regionName
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
		INNER JOIN 
        	smg_programs p ON p.programid = s.programid
		LEFT OUTER JOIN
        	smg_companies c ON c.companyID = s.companyID            
		LEFT OUTER JOIN
        	smg_regions r ON r.regionID = s.regionAssigned
        WHERE 
        	s.active = '1'		
        AND 
        	s.host_fam_approved > 4			
		<cfif CLIENT.companyID EQ 5>
            AND
                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
        <cfelse>
            AND
                s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
		ORDER BY 
        	host_fam_approved
	</cfquery>

<cfelse>

	<!--- List All Field Regions --->
	<cfquery name="list_regions" datasource="MySql"> 
		SELECT 
        	uar.regionid, 
            uar.usertype,
            smg_regions.regionname
		FROM 
        	user_access_rights uar
		INNER JOIN 
        	smg_regions ON smg_regions.regionid = uar.regionid
		WHERE 
        	userid = '#client.userid#' 
        AND 
        	uar.companyid = '#client.companyid#'
        AND 
        	uar.usertype != '9'
		ORDER BY 
        	default_region DESC, regionname
	</cfquery>
		
	<cfif NOT IsDefined('url.regionid')><cfset url.regionid = list_regions.regionid></cfif>
	
	<!--- Get Usertype From Selected Region --->
	<cfquery name="get_user_region" datasource="MySql"> 
		SELECT uar.regionid, uar.usertype, u.usertype as user_access
		FROM user_access_rights uar
		INNER JOIN smg_usertype u ON  u.usertypeid = uar.usertype
		WHERE userid = '#client.userid#'
			AND companyid = '#client.companyid#'	
			<cfif IsDefined('url.regionid')>AND uar.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer"></cfif>
			AND uar.usertype != '9'
	</cfquery>  
	
	<cfset client.usertype = #get_user_region.usertype#>

	<!--- REGIONS DROP DOWN LIST --->
	<cfif list_regions.recordcount GT 1>
		<cfoutput>
		<form name="form">
			You have access to multiple regions filter by region: &nbsp; 
			<select name="sele_region" onChange="javascript:formHandler()">
			<cfloop query="list_regions">
				<option value="?curdoc=pending_hosts&regionid=#regionid#" <cfif url.regionid is #regionid#>selected</cfif>>#regionname#</option>
			</cfloop>
			</select>
			&nbsp; &nbsp; Access Level : &nbsp; #get_user_region.user_access#<br>
		</form>	
		</cfoutput>
	</cfif> 
	
	<cfquery name="pending_hosts" datasource="MySQL">
		SELECT 
        	s.host_fam_approved, 
            s.studentid, 
            s.hostid, 
            s.firstname, 
            s.familylastname as student_lastname, 
            s.regionassigned, 
            s.dateplaced,
            s.host_fam_approved,
			h.familylastname, 
            h.fatherfirstname, 
            h.fatherlastname, 
            h.motherlastname, 
            h.motherfirstname, 
            h.city, 
            h.state,  
			p.programname,
            c.companyShort,
            r.regionName
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
		INNER JOIN 
        	smg_programs p ON p.programid = s.programid
		LEFT OUTER JOIN
        	smg_companies c ON c.companyID = s.companyID 
		LEFT OUTER JOIN
        	smg_regions r ON r.regionID = s.regionAssigned
		WHERE 
        	s.active = '1'
        AND 
        	s.host_fam_approved > 4
        <!--- Managers --->
        <cfif client.usertype EQ 5>
            AND 
            	(s.regionassigned = '#get_user_region.regionid#') 
        <!--- Advisor --->
        <cfelseif client.usertype EQ 6>
            <cfquery name="get_reps" datasource="mysql">
                SELECT DISTINCT userid 
                FROM user_access_rights
                WHERE advisorid = '#client.userid#' 
                    AND companyid = '#client.companyid#'
                    OR userid = '#client.userid#'
            </cfquery>
            <cfif get_reps.recordcount>
            AND 
            	(s.arearepid = 
                <cfloop query="get_reps">
                #userid# <cfif get_reps.currentrow EQ #get_reps.recordcount#><cfelse> or s.arearepid = </cfif>
                </cfloop>)
            </cfif>
        <!--- Area Rep --->
        <cfelseif client.usertype EQ 7>
            AND 
            	(s.arearepid = '#client.userid#' or s.placerepid = '#client.userid#')
        </cfif>
		ORDER BY 
        	host_fam_approved
	</cfquery>

</cfif>

<br>
<cfif client.usertype EQ 7>
	The following list shows the placements that you have submitted and the status of that placement.  If the report is marked Rejected, you can click on piece of the Host Information to see 
	why it was rejected and then make the neccesary changes or remove the placement.
<Cfelse>
	The following students have been tentatively placed with this hosts indicated.  Please review the host information by clicking on any host information.  To approve, please visit the student's page or click on the link below and go to Placement Management, you will have the option to Approve or Reject the Placement.
</cfif>
<br><br>


<style type="text/css">
<!--
div.scroll {
	height: 325px;
	width: 600px;
	overflow: auto;
}
-->
</style>

<table border=0 cellpadding=4 cellspacing=0 width=100%>
	<tr>
		<td colspan=4 align="center" bgcolor="#EAEAF2">Student</td><td colspan=6 align="center" bgcolor="#FFDFE1">Host</td>
	</tr>
	<tr>
		<td width="30">ID</td>
		<td width="100">Last Name</td>
		<td width="100">First Name</td>
		<td width="80">Region</td>
		<td width="80">Program</td>
		<td width="30">ID</td>
		<td width="100">Last Name(s)</td>
		<td width="100">First Name(s)</td>
        <td width="70">Date Placed</td>
        <td>Rejected in..</td>
	</tr>

<cfoutput query="pending_hosts">
<cfset DisplayEndDate = #DateAdd('d', 4, '#dateplaced#')#>
    <tr bgcolor="<Cfif host_fam_Approved EQ '7'>FCC8C8<cfelseif host_fam_Approved is '6'>FDFF6D<cfelseif host_fam_approved is '5'>A0E1A1<cfelseif host_fam_approved is '99'>FB8822</cfif>">
            <td>#studentid#</td>
            <td>#student_lastname#</td>
            <td>#firstname#</td>
            <td>
                <cfif CLIENT.companyID EQ 5>
                	#companyShort# - 
                </cfif>
                #regionname#
            </td>
            <td>#programname#</td>
            <td><a class=nav_bar href="" onClick="javascript: win=window.open('forms/place_menu.cfm?studentid=#studentid#', 'Settings', 'height=550, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#hostid#</a></td>
            <td><a class=nav_bar href="" onClick="javascript: win=window.open('forms/place_menu.cfm?studentid=#studentid#', 'Settings', 'height=550, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><cfif fatherlastname is motherlastname> #fatherlastname#<Cfelseif fatherlastname is''> #motherlastname# <Cfelseif motherlastname is ''>#fatherlastname#<Cfelse>#fatherlastname# #motherlastname#</cfif></td>
            <td><a class=nav_bar href="" onClick="javascript: win=window.open('forms/place_menu.cfm?studentid=#studentid#', 'Settings', 'height=550, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"> #fatherfirstname# <Cfif fatherfirstname is '' or motherfirstname is ''><cfelse>&</Cfif> #motherfirstname#</td>
            <td>#DateFormat(dateplaced,'mm/dd/yyyy')#</td>
            <td><Cfif host_fam_approved eq 99>N/A<cfelse> <cf_timer dateEnd="#DisplayEndDate#"></cfif></td>
    </tr>
    <tr>
        <td></td>
    </tr>
</cfoutput>
</table>

<br>
<table align="Center" cellpadding =4 cellspacing =0 class="nav_bar">
<th bgcolor="CC0000" ><font color="white">Key</th>
	<tr>
		<td>Waiting for approval from...</td>
	</tr>
	<tr bgcolor="#FCC8C8">
		<td align="Center">Regional Advisor</td>
	</tr>
	<tr bgcolor="FDFF6D">
		<td align="Center">Regional Director / Manager</td>
	</tr>
	<tr bgcolor="A0E1A1">
		<td align="Center">Facilitator</td>
	</tr>
		<tr bgcolor="FB8822">
		<td align="Center">Rejected</td>
	</tr>
</table>
*you can over-ride anyone below you in the approval process.  You can not approve past your level.	

</body>
</html>