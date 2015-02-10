<!--- ------------------------------------------------------------------------- ----
	
	File:		new_forms_menu.cfm
	Author:		Marcus Melo
	Date:		January 11, 2010
	Desc:		DS-2019 New Form Menu

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param URL Variables --->
	<cfparam name="URL.text" default="no">
    <cfparam name="URL.all" default="no">

    <cfparam name="batch_type" default="new">


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
		
          <cfquery 
			name="qGetIntlRep" 
			datasource="MySql">
              SELECT DISTINCT
					u.*
                FROM 
                    smg_users u
                INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
                INNER JOIN
                	extra_candidates s ON s.intRep = u.userID
                    	AND
                        	s.isDeleted = 0
						
                            AND          
                                s.companyID = 8
                WHERE
                    uar.usertype = 8
                GROUP BY
                	u.userID 
                ORDER BY 
                    u.businessName                  
			</cfquery>
            
    <cfquery name="qGetSevisHistory" datasource="MySql">
        SELECT s.batchid, s.companyid, s.createdby, s.datecreated, s.totalstudents, s.totalprint, s.received, 
                c.companyshort,
                u.firstname, u.lastname
        FROM smg_sevis s
        INNER JOIN smg_companies c ON c.companyid = s.companyid
        INNER JOIN smg_users u ON u.userid = s.createdby
        WHERE type = 'new'
        <cfif url.all is 'no'>AND s.companyid = #client.companyid#</cfif>
        ORDER BY s.batchID DESC
    </cfquery>
    
</cfsilent>    

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<span class="application_section_header">SEVIS BATCH INTERFACE SYSTEM - Version 5.0</span><br>

<cfoutput>
<!--- CREATING NEW FORMS --->
<table class="nav_bar" cellpadding=4 cellspacing="0" align="center" width="96%">
<tr><th bgcolor="ededed">&nbsp; &nbsp; &nbsp; &nbsp; N E W &nbsp; D S - 2 0 1 9 &nbsp; F O R M S</th>
	<td width="15%" align="right" bgcolor="ededed"><a href="" onClick="javascript: win=window.open('sevis/xml_list_files.cfm?type=new_forms', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Virtual Folder</a>&nbsp; - &nbsp;<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/menu"><img src="../pics/sevis_menu.gif" border="0"></a></td>
</tr>
</table><br>
<cfform action="sevis/newFormXML.cfm" method="POST" target="blank">
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr><th colspan="2" bgcolor="ededed">DS-2019 Create XML Files (Up to 250 students)</th></tr>
	<tr align="left">
		<td width="15%">Program :</td>
		<td>
        	<select name="programid" multiple size="8">			
				<cfloop query="qGetPrograms"><option value="#qGetPrograms.ProgramID#">#qGetPrograms.programname#</option></cfloop>
			</select>
        </td>
	</tr>
	<tr align="left">
		<td width="15%">Intl. Representative :</td>
		<td>
        	<select name="intRep" multiple  size="10">			
				<cfloop query="qGetIntlRep"><option value="#qGetIntlRep.userID#">#qGetIntlRep.businessName#</option></cfloop>
			</select>
        </td>
	</tr>
	<tr><td colspan="2" align="center" bgcolor="ededed"><input type="image" src="../pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td></tr>
</table><br>
</cfform>
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<th align="center" bgcolor="ededed">SEVIS Batch Create Forms XML Results Extractor</th></tr>
	<tr><td bgcolor="ededed"><cfform method="post" action="?curdoc=sevis/new_forms_results" enctype="multipart/form-data">
		File Name &nbsp; : &nbsp; <input type="text" name="filename" size="50">
		<div align="center"><input type="submit" value="Update DS-2019"></div>
		</cfform></td></tr>
</table><br>
</cfoutput>
<!--- END OF CREATING NEW FORMS --->

<cfinclude template="ds_forms.cfm">

<Table class="nav_bar" cellpadding=3 cellspacing="0" align="center" width="96%">
<tr><th colspan="7" bgcolor="ededed">
	<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/new_forms_menu&text=yes&all=yes">(all companies)</a> &nbsp; &nbsp;
	XML Files History &nbsp; &nbsp;
	<Cfif url.text is 'no'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/new_forms_menu&text=yes">(show list)</a>
	<cfelseif url.text is 'yes'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/new_forms_menu&text=no">(hide list)</a>
	</Cfif>
</th></tr>
<cfif url.text is 'no'><cfelse>
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
		<td align="center"><font color="#fontcolor#"><a href="sevis/new_forms_list.cfm?batchid=#batchid#" target="_blank">0#batchid#</font></a></td>
		<td align="center"><font color="#fontcolor#"><a href="sevis/new_forms_list.cfm?batchid=#batchid#" target="_blank">#companyshort#</a></font></td>
		<td align="center"><font color="#fontcolor#"><a href="sevis/new_forms_list.cfm?batchid=#batchid#" target="_blank">#DateFormat(datecreated, 'mm-dd-yyyy')#</font></a></td>
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