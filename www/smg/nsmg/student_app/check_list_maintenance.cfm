<cftry> 

	<SCRIPT>
	<!-- hide script
	function CheckLink()
	{
	  if (document.checklist.CheckChanged.value != 0)
	  {
		if (confirm("You have made changes on this page that have not been submited.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and submit to save your changes."))
		  return true;
		else
		  return false;
	  }
	}
	function DataChanged()
	{
	  document.checklist.CheckChanged.value = 1;
	}
	// unhide script -->
	</SCRIPT>
	
	<cfquery name="get_pages" datasource="MySql">
		SELECT page 
		FROM smg_student_app_field
		GROUP BY page
		ORDER BY page
	</cfquery>
	
	<cfif not IsDefined('url.page')>
		<cfset url.page = #get_pages.page#>
	</cfif>
	
	<cfquery name="get_fields" datasource="MySql">
		SELECT fieldid, field_label, required, section, page, field_order, field_name, table_located 
		FROM smg_student_app_field
		WHERE page = <cfqueryparam value="#url.page#" cfsqltype="cf_sql_integer">
		ORDER BY field_order
	</cfquery>
	
	<cfform name="checklist" method="post" action="?curdoc=querys/upd_check_list_maintenance&page=#url.page#">
	
	<cfoutput>
	<table width="100%" cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
			<td background="../pics/header_background.gif"><h2>CHECK LIST - MAINTENANCE</h2></td>
			<td background="../pics/header_background.gif" align="right">
				[ Pages &middot; 
				<cfloop query="get_pages">
					<cfif url.page is "#page#"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=check_list_maintenance&page=#page#">#page#</a></span> &middot; 
				</cfloop> 
				]		
			</td>
			<td width=17 background="../pics/header_rightcap.gif"></td>
		</tr>
	</table>
	
	<table cellpadding="3" cellspacing="0" bgcolor="FFFFFF" width=100% class="section">
		<tr>
			<td><b>Field Label</b></td>
			<td><b>Section</b></td>
			<td><b>Page</b></td>
			<td><b>Order</b></td>
			<td><b>Field Name</b></td>
			<td><b>Table</b></td>
			<td><b>Required</b></td>
		</tr>
		<cfinput type="hidden" name="count" value="#get_fields.recordcount#">
		<cfloop query="get_fields">
			<cfinput type="hidden" name="fieldid#get_fields.currentrow#" value="#fieldid#">
			<tr>
				<td><cfinput type="text" name="field_label#get_fields.currentrow#" size="50" value="#field_label#" onchange="DataChanged();"></td>
				<td><cfinput type="text" name="section#get_fields.currentrow#" size="1" value="#section#" onchange="DataChanged();"></td>
				<td><cfinput type="text" name="page#get_fields.currentrow#" size="1" value="#page#" onchange="DataChanged();"></td>
				<td><cfinput type="text" name="field_order#get_fields.currentrow#" size="1" value="#field_order#" onchange="DataChanged();"></td>
				<td><cfinput type="text" name="field_name#get_fields.currentrow#" size="30" value="#field_name#" onchange="DataChanged();"></td>
				<td><cfinput type="text" name="table_located#get_fields.currentrow#" size="30" value="#table_located#" onchange="DataChanged();"></td>
				<td><select name="required#get_fields.currentrow#" onchange="DataChanged();">
						<option value="0" <cfif get_fields.required is '0'>selected</cfif> >No</option>
						<option value="1" <cfif get_fields.required is '1'>selected</cfif> >Yes</option>
					</select> 
				</td>
			</tr>			
		</cfloop>
		<tr><td colspan="7" align="center"><cfinput name="Submit" type="image" src="../pics/update.gif" border=0></td></tr>
	</table>
	
	</cfoutput>
	
	</cfform>
		
	<!----footer of table ---->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom">
			<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
			<td width=100% background="../pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
		</tr>
	</table> 
	
<cfcatch type="any">
	<cfinclude template="email_error.cfm">
</cfcatch>
</cftry>