<!--- ------------------------------------------------------------------------- ----
	
	File:		end_program_menu.cfm
	Author:		Marcus Melo
	Date:		January 11, 2010
	Desc:		DS-2019 End Program Menu

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param URL Variables --->
	<cfparam name="URL.text" default="no">
    <cfparam name="URL.all" default="no">

    <cfparam name="batch_type" default="new">

	<cfscript>
        // Get Programs
        qGetPrograms = APPCFC.PROGRAM.getPrograms(companyID=CLIENT.companyID, dateActive=1);
    </cfscript>

    <!-----Company Information----->
    <Cfquery name="get_company" datasource="MySQL">
    select companyid, companyname, sevis_userid, iap_auth
    from smg_companies
    where companyid = #client.companyid#
    </Cfquery>

</cfsilent>

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<span class="application_section_header">SEVIS BATCH INTERFACE SYSTEM - Version 5.0</span><br>

<cfoutput>
<!--- CREATING NEW FORMS --->
<table class="nav_bar" cellpadding=4 cellspacing="0" align="center" width="96%">
<tr><th bgcolor="ededed">&nbsp; &nbsp; &nbsp; &nbsp; E N D &nbsp; P R O G R A M</th><td width="5%" align="right" bgcolor="ededed"><a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/menu"><img src="pics/sevis_menu.gif" border="0"></a></td></tr>
</table><br>
<cfform action="sevis/end_program_xml.cfm" method="POST" target="blank">
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr><th colspan="2" bgcolor="ededed">End Programs (Up to 250 students)</th></tr>
	<tr><td colspan="2" align="center">According to Flight Information or Termination Date prior to today's date.</td></tr>
	<tr>
		<TD width="15%">Program :</td>
		<TD><cfselect name="programid" multiple  size="5">			
			<cfloop query="qGetPrograms"><option value="#ProgramID#">#qGetPrograms.companyshort# - #programname#</option></cfloop>
			</cfselect></td></tr>
	<tr>
		<td width="15%">According to :</td>
		<td><cfselect name="type" required="yes">
			<option value="0"></option>
			<option value="termination">Termination Date</option>
			<option value="departure">Flight Depart Info</option>
			</cfselect>
		</td>
	</tr>
	<tr><td colspan="2" align="center" bgcolor="ededed"><input type="image" src="pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td></tr>
</table><br>
</cfform>
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<th align="center" bgcolor="ededed">SEVIS Batch Create Forms XML Results Extractor</th></tr>
	<tr><td bgcolor="ededed"><cfform method="post" action="?curdoc=sevis/end_program_results" enctype="multipart/form-data">
		File Name &nbsp; : &nbsp; <input type="text" name="filename" size="50">
		<div align="center"><input type="submit" value="Update DS 2019"></div>
		</cfform></td></tr>
</table><br>
</cfoutput>
<!--- END OF CREATING NEW FORMS --->

<cfinclude template="ds_forms.cfm">
