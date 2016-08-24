<!--- ------------------------------------------------------------------------- ----
	
	File:		activate_menu.cfm
	Author:		Marcus Melo
	Date:		January 11, 2010
	Desc:		DS-2019 Form Activation Menu

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param URL Variables --->
	<cfparam name="URL.text" default="no">
    <cfparam name="URL.all" default="no">

    <cfparam name="batch_type" default="activate">

	<cfscript>
        // Get Programs
        qGetPrograms = APPCFC.PROGRAM.getPrograms(dateActive=1);
    </cfscript>

	<!-----Company Information----->
    <cfquery name="get_company" datasource="MySQL">
        SELECT 
            companyID,
            companyName,
            companyshort,
            companyshort_nocolor,
            sevis_userid,
            iap_auth,
            team_id
        FROM 
            smg_companies
        WHERE 
            companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    </cfquery>
    
    <cfquery name="qGetSevisHistory" datasource="MySql">
        SELECT s.batchid, s.companyid, s.createdby, s.datecreated, s.totalstudents, s.totalprint, s.received, 
                c.companyshort,
                u.firstname, u.lastname
        FROM smg_sevis s
        INNER JOIN smg_companies c ON c.companyid = s.companyid
        INNER JOIN smg_users u ON u.userid = s.createdby
        WHERE type = 'activate'
        <cfif URL.all is 'no'>AND s.companyid = #client.companyid#</cfif>
        ORDER BY s.batchID DESC
    </cfquery>

</cfsilent>    

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<span class="application_section_header">SEVIS BATCH INTERFACE SYSTEM - Version 5.0</span><br>

<cfoutput>
<table class="nav_bar" cellpadding=4 cellspacing="0" align="center" width="96%">
<tr><th bgcolor="ededed">&nbsp; &nbsp; &nbsp; &nbsp; A D D R E S S &nbsp; A D D I T I O N</th>
	<td width="15%" align="right" bgcolor="ededed"><a href="" onClick="javascript: win=window.open('sevis/xml_list_files.cfm?type=activate', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Virtual Folder</a>&nbsp; - &nbsp;<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/menu"><img src="pics/sevis_menu.gif" border="0"></a></td></tr>
</table><br>

<!--- ACTIVATE STUDENTS THAT HAVE ALREADY ARRIVED IN THE USA --->
<cfform action="sevis/update_address.cfm" method="POST" target="blank">
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr><th colspan="2" bgcolor="ededed">Update address of students that have already arrived in the USA according to flight info received - (Up to 250 students)</th></tr>
	<tr align="left">
		<TD width="15%">Program :</td>
		<TD><select name="programid" multiple size="8">			
			<cfloop query="qGetPrograms"><option value="#ProgramID#">#programname#</option></cfloop>
			</select></td></tr>
	<tr align="left">
		<TD width="15%">Pre-AYP :</td>
		<TD><input type="checkbox" name="pre_ayp">Only Pre-AYP students</td></tr>
	<tr align="left">
		<TD width="15%">Arrival Date : </td>
		<TD><cfinput type="text" name="arrival_date" size="8" value="#DateFormat(now(), 'mm/dd/yyyy')#" validate="date" required="yes" message="You must include an arrival date" maxlength="10"></td></tr>
	<tr><td colspan="2" align="center" bgcolor="ededed"><input type="image" src="pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td></tr>
</table><br>
</cfform>

<!--- ACTIVATE STUDENTS --->
<cfform action="sevis/activate_xml.cfm" method="POST" target="blank">
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr><th colspan="2" bgcolor="ededed">Address Update Forms (Up to 250 students)</th></tr>
	<tr align="left">
		<TD width="15%">Program :</td>
		<TD><select name="programid" multiple size="8">			
			<cfloop query="qGetPrograms"><option value="#ProgramID#">#programname#</option></cfloop>
			</select></td></tr>
	<tr align="left">
		<TD width="15%">Pre-AYP :</td>
		<TD><input type="checkbox" name="pre_ayp">Only Pre-AYP students</td></tr>
	<tr><td colspan="2" align="center" bgcolor="ededed"><input type="image" src="pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td></tr>
</table><br>
</cfform>

<!--- XML EXTRACT DATA --->
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<th align="center" bgcolor="ededed">SEVIS Batch Activation XML Results Extractor</th></tr>
	<tr><td bgcolor="ededed"><cfform method="post" action="?curdoc=sevis/address_results" enctype="multipart/form-data">
		File Name &nbsp; : &nbsp; <input type="text" name="filename" size="50">
		<div align="center"><input type="submit" value="Update #CLIENT.DSFormName#"></div>
		</cfform></td></tr>
</table><br>
</cfoutput>

<cfinclude template="ds_forms.cfm">

<Table class="nav_bar" cellpadding=3 cellspacing="0" align="center" width="96%">
<tr><th colspan="7" bgcolor="ededed">
	<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/address_menu&text=yes&all=yes">(all companies)</a> &nbsp; &nbsp;
	XML Files History &nbsp; &nbsp;
	<Cfif URL.text is 'no'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/address_menu&text=yes">(show list)</a>
	<cfelseif URL.text is 'yes'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/address_menu&text=no">(hide list)</a>
	</Cfif>
</th></tr>
<cfif URL.text NEQ 'no'>
	<tr bgcolor="ededed">
		<td width="11%" align="center"><b>Batch ID</b></td>
		<td width="10%" align="center"><b>Company</b></td>
		<td width="18%" align="center"><b>Date Created</b></td>
		<td width="18%" align="center"><b>Total Students</b></td>
		<td width="18%" align="center"><b>Total Created</b></td>
		<td width="5%" align="center"><b>Errors</b></td>
		<td width="20%" align="center"><b>Created By</b></td>				
	</tr>
	<cfoutput query="qGetSevisHistory">
	<cfif totalprint is 0 and received is 'no'><cfset toterrors = 'n/a'><cfelse><cfset toterrors = (#totalstudents# - #totalprint#)></cfif>
	<cfif received is 'yes'><cfset fontcolor = '3333CC'><cfelse><cfset fontcolor = 'FF0000'></cfif>
	<tr bgcolor="#iif(qGetSevisHistory.currentrow MOD 2 ,DE("white") ,DE("ededed"))#">
		<td align="center"><font color="#fontcolor#"><a href="sevis/activate_list.cfm?batchid=#batchid#" target="_blank">0#batchid#</font></a></td>
		<td align="center"><font color="#fontcolor#"><a href="sevis/activate_list.cfm?batchid=#batchid#" target="_blank">#companyshort#</a></font></td>
		<td align="center"><font color="#fontcolor#"><a href="sevis/activate_list.cfm?batchid=#batchid#" target="_blank">#DateFormat(datecreated, 'mm-dd-yyyy')#</font></a></td>
		<td align="center"><font color="#fontcolor#">#totalstudents#</font></td>
		<td align="center"><font color="#fontcolor#">#totalprint#</font></td>
		<td align="center"><cfif toterrors GT 0><font color="FF0000"><cfelse><font color="3333CC"></cfif>#toterrors#</font></td>
		<td align="center"><font color="#fontcolor#">#firstname# #lastname#</font></td>				
	</tr>
	</cfoutput>
	<tr><td colspan="3"><font size="-1" color="FF0000">* Pending Batch Files</font></td>
	<td colspan="4">* Click in the link(s) above to see the list of students.</td></tr>
</cfif>
</table><br>