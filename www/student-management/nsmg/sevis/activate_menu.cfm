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

	  <cfquery 
			name="qGetPrograms" 
			datasource="MySql">
                SELECT
					p.programID,
                    p.programName,
                    p.type,
                    p.startDate,
                    p.endDate,
                    p.applicationDeadline,
                    p.insurance_startDate,
                    p.insurance_endDate,
                    p.sevis_startDate,
                    p.sevis_endDate,
                    p.preAyp_date,
                    p.companyID,
                    p.programFee,
                    p.application_fee,
                    p.insurance_w_deduct,
                    p.insurance_wo_deduct,
                    p.blank,
                    p.hold,
                    p.progress_reports_active,
                    p.seasonID,
                    p.smgSeasonID,
                    p.tripID,
                    p.active,
                    p.fieldViewable,
                    p.insurance_batch,
                    c.companyName,
                    c.companyShort,
                    s.season as seasonname
                FROM 
                    smg_programs p
				LEFT OUTER JOIN
                	smg_companies c ON c.companyID = p.companyID                    
                LEFT OUTER JOIN 
                	smg_seasons s on s.seasonID = p.seasonID
                WHERE
                	p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">			
                    AND
                        p.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                    AND
                    	p.startDate <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', 6, now())#">
                    AND
                    	p.endDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -3, now())#">
                ORDER BY 
                   p.startDate DESC,
                   p.programName
		</cfquery>
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
	
    <cfquery name="arrivalDates" datasource="MySql">
    select distinct watDateCheckedIn
    from extra_candidates
    where sevis_activated = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
    and watDateCheckedIn > <cfqueryparam value="2015-04-15" cfsqltype="cf_sql_date">
    </cfquery>
</cfsilent>    

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<span class="application_section_header">SEVIS BATCH INTERFACE SYSTEM - Version 5.0</span><br>

<cfoutput>
<table class="nav_bar" cellpadding=4 cellspacing="0" align="center" width="96%">
<tr><th bgcolor="ededed">&nbsp; &nbsp; &nbsp; &nbsp; A C T I V A T E &nbsp; S T U D E N T S</th>
	<td width="15%" align="right" bgcolor="ededed"><a href="" onClick="javascript: win=window.open('sevis/xml_list_files.cfm?type=activate', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Virtual Folder</a>&nbsp; - &nbsp;<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/menu"><img src="pics/sevis_menu.gif" border="0"></a></td></tr>
</table><br>

<!--- ACTIVATE STUDENTS THAT HAVE ALREADY ARRIVED IN THE USA --->
<cfform action="sevis/activate_xml_arrived.cfm" method="POST" target="blank">
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr>
	  <th colspan="2" bgcolor="ededed">Active students that have already arrived in the USA according tocontact update -- (Up to 250 students)</th></tr>
	<tr align="left">
		<TD width="15%">Program :</td>
		<TD><select name="programid" multiple size="8">			
			<cfloop query="qGetPrograms"><option value="#ProgramID#">#programname#</option></cfloop>
			</select></td></tr>
	<!----<tr align="left">
		<TD width="15%">Pre-AYP :</td>
		<TD><input type="checkbox" name="pre_ayp">Only Pre-AYP students</td></tr>---->
	<tr align="left">
		<TD width="15%">Arrival Date : </td>
		<TD><select name="watDateCheckedIn">	
            	<option value="">Please select a verification date</option>
				<cfloop query="arrivalDates"><option value="#watDateCheckedIn#">#DateFormat(watDateCheckedIn, 'yyyy-mm-dd')#</option></cfloop>
			</select></td></tr>
	<tr><td colspan="2" align="center" bgcolor="ededed"><input type="image" src="pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td></tr>
</table><br>
</cfform>

<!--- ACTIVATE STUDENTS --->
<cfform action="sevis/activate_xml.cfm" method="POST" target="blank">
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr><th colspan="2" bgcolor="ededed">Active Students Forms (Up to 250 students)</th></tr>
	<tr align="left">
		<TD width="15%">Program :</td>
		<TD><select name="programid" multiple size="8">			
			<cfloop query="qGetPrograms"><option value="#ProgramID#">#programname#</option></cfloop>
			</select></td></tr>
	<!----<tr align="left">
		<TD width="15%">Pre-AYP :</td>
		<TD><input type="checkbox" name="pre_ayp">Only Pre-AYP students</td></tr>---->
	<tr><td colspan="2" align="center" bgcolor="ededed"><input type="image" src="pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td></tr>
</table><br>
</cfform>

<!--- XML EXTRACT DATA --->
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<th align="center" bgcolor="ededed">SEVIS Batch Activation XML Results Extractor</th></tr>
	<tr><td bgcolor="ededed"><cfform method="post" action="?curdoc=sevis/activate_results" enctype="multipart/form-data">
		File Name &nbsp; : &nbsp; <input type="text" name="filename" size="50">
		<div align="center"><input type="submit" value="Update DS-2019"></div>
		</cfform></td></tr>
</table><br>
</cfoutput>

<cfinclude template="ds_forms.cfm">

<Table class="nav_bar" cellpadding=3 cellspacing="0" align="center" width="96%">
<tr><th colspan="7" bgcolor="ededed">
	<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/activate_menu&text=yes&all=yes">(all companies)</a> &nbsp; &nbsp;
	XML Files History &nbsp; &nbsp;
	<Cfif URL.text is 'no'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/activate_menu&text=yes">(show list)</a>
	<cfelseif URL.text is 'yes'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/activate_menu&text=no">(hide list)</a>
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