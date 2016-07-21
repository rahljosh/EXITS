<!--- ------------------------------------------------------------------------- ----
	
	File:		constantContactMenu.cfm
	Author:		James Griffiths
	Date:		March 12, 2012
	Desc:		Constant Contact Reports Menu

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.active" default="">
    
    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(isActive=1,dateActive=1,companyID=CLIENT.companyID);
	</cfscript>
    
</cfsilent>

<cfoutput>
    
	<!--- Table Header --->
    <gui:tableHeader
        width="98%"
        tableTitle="Constant Contact Reports"
        imageName="students.gif"
    />    
	  
	<!--- Page Messages --->
	<gui:displayPageMessages 
		pageMessages="#SESSION.pageMessages.GetCollection()#"
		messageType="tableSection"
		width="98%"
		/>

	<!--- Form Errors --->
	<gui:displayFormErrors 
		formErrors="#SESSION.formErrors.GetCollection()#"
		messageType="tableSection"
		width="98%"
		/>

	<table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
		<tr>
			<td>
				
                <!--- Students --->
				<form action="reports/constantContactStudents.cfm" method="post" target="_blank">
					<table class="reportTableLeft" cellpadding="4" cellspacing="0">
						<tr><th colspan="2" class="title">Students</th></tr>
						<tr>
							<td class="fieldTitle">Program:</td>
							<td>
								<select name="ProgramID" class="mediumField" multiple size="4">
									<cfloop query="qGetProgramList">
										<option value="#qGetProgramList.ProgramID#">#qGetProgramList.programname#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td class="fieldTitle">Active:</td>
							<td>
								<select name="active" class="xLargeField">
									<option value="" <cfif NOT LEN(FORM.active)> selected="selected" </cfif> >All</option>
									<option value="active" <cfif FORM.active EQ 'active'> selected="selected" </cfif> >Active</option>
									<option value="inactive" <cfif FORM.active EQ 'inactive'> selected="selected" </cfif> >Inactive</option>
									<option value="cancelled" <cfif FORM.active EQ 'cancelled'> selected="selected" </cfif> >Cancelled</option>
                                </select>
							</td>
						</tr>		
						<tr><td colspan="2" class="submitButton"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
					</table>
				</form>
				
                <!--- Host Families --->
				<form action="reports/constantContactHostFamilies.cfm" method="post" target="_blank">
					<table class="reportTableRight" cellpadding="4" cellspacing="0">
						<tr><th colspan="2" class="title">Host Families</th></tr>
						<tr>
							<td class="fieldTitle">Program:</td>
							<td>
								<select name="ProgramID" class="mediumField" multiple size="4">
									<cfloop query="qGetProgramList">
										<option value="#qGetProgramList.ProgramID#">#qGetProgramList.programname#</option>
									</cfloop>
								</select>
							</td>
						</tr>		
						<tr><td colspan="2" class="submitButton"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
					</table>
				</form>
         	</td>
     	</tr>
        <tr>
        	<td>
            
                <!--- International Representatives --->
                <form action="reports/constantContactIntlReps.cfm" method="post" target="_blank">
					<table class="reportTableLeft" cellpadding="4" cellspacing="0">
						<tr><th colspan="2" class="title">International Representatives</th></tr>
						<tr>
							<td class="fieldTitle">Program:</td>
							<td>
								<select name="ProgramID" class="mediumField" multiple size="4">
									<cfloop query="qGetProgramList">
										<option value="#qGetProgramList.ProgramID#">#qGetProgramList.programname#</option>
									</cfloop>
								</select>
							</td>
						</tr>		
						<tr><td colspan="2" class="submitButton"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
					</table>
				</form>
				
                <!--- Schools --->
				<form action="reports/constantContactSchools.cfm" method="post" target="_blank">
					<table class="reportTableRight" cellpadding="4" cellspacing="0">
						<tr><th colspan="2" class="title">Schools</th></tr>
						<tr>
							<td class="fieldTitle">Program:</td>
							<td>
								<select name="ProgramID" class="mediumField" multiple size="4">
									<cfloop query="qGetProgramList">
										<option value="#qGetProgramList.ProgramID#">#qGetProgramList.programname#</option>
									</cfloop>
								</select>
							</td>
						</tr>		
						<tr><td colspan="2" class="submitButton"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
					</table>
				</form>
                
			</td> 
		</tr>
	</table> <!--- end of main table --->
	
	<!--- Table Footer --->
	<gui:tableFooter 
		width="98%"
	/>

</cfoutput>