<!--- ------------------------------------------------------------------------- ----
	
	File:		permissionForm.cfm
	Author:		James Griffiths
	Date:		April 9, 2014
	Desc:		Customize blank permission forms
	
----- ------------------------------------------------------------------------- --->
	
<!--- Import CustomTag --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />

<cfparam name="FORM.submitted" default="0">
<cfparam name="FORM.tour_ID" default="0">
<cfparam name="FORM.companyID" default="1">
<cfparam name="FORM.customTourName" default="">
<cfparam name="FORM.customTourDates" default="">
<cfparam name="FORM.customTourPrice" default="">

<cfsilent>

	<!--- Get Tours --->
    <cfquery name="qGetTours" datasource="#APPLICATION.DSN#">
        SELECT * 
        FROM smg_tours
        WHERE tour_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="active">
        ORDER BY tour_name
    </cfquery>

</cfsilent>

<cfif VAL(FORM.submitted)>
	<cfset FORM.blank = 1>
    <style type="text/css">
		body {
			margin: 0px;
			padding: 0px;
			font-size: 0px;
		}
	</style>
	<cfinclude template="tripPermission.cfm">
    <cfabort>
</cfif>
    
<cfoutput>

	<!--- Table Header --->
	<gui:tableHeader
		tableTitle="Permission Form"
	/>
	
	<form action="tours/permissionForm.cfm" method="post">
		<input type="hidden" name="submitted" value="1" />
		
		<table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
			<tr>
				<td>
					Tour
					<select name="tour_ID">
						<option value="0">None</option>
						<cfloop query="qGetTours">
							<option value="#tour_ID#" <cfif FORM.tour_ID EQ tour_ID>selected="selected"</cfif>>#tour_name#</option>
						</cfloop>
					</select>
				</td>
				<td>
					Custom Tour Name: <input type="text" name="customTourName" />
					<br/>
					Custom Tour Dates: <input type="text" name="customTourDates" />
                    <br/>
					Custom Price: <input type="text" name="customTourPrice" />
				</td>
				<td>
					Company
					<select name="companyID">
						<option value="1">ISE</option>
						<option value="10">CASE</option>
						<option value="14">ESI</option>
						<option value="6">PHP</option>
					</select>
				</td>
				<td>
					<input type="submit" />
				</td>
			</tr>
		</table>
		
	</form>
	
	<!--- Table Footer --->
	<gui:tableFooter />
	
</cfoutput>