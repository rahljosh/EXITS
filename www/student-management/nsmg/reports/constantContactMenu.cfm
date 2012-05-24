<!--- ------------------------------------------------------------------------- ----
	
	File:		constantContactMenu.cfm
	Author:		James Griffiths
	Date:		March 16, 2012
	Desc:		Constant Contact Reports Menu
				
----- ------------------------------------------------------------------------- --->

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.active" default="">
    
    <cfscript>
		// Get Program List
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(isActive=1,dateActive=1,companyID=CLIENT.companyID);
		
		// Get Field User Type
		qGetUserType = APPLICATION.CFC.LOOKUPTABLES.getUserType(userTypeList="5,6,7,8,9,15");
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
					<table cellpadding="4" cellspacing="0" class="nav_bar" width="90%" align="center">
						<tr><th colspan="2" bgcolor="e2efc7" class="title">Students</th></tr>
						<tr>
							<td class="fieldTitle">Students:</td>
							<td>
								<select name="studentStatus" class="xLargeField">
                                	<option value="allStudent">All</option>
                                	<option value="activeStudent">Active</option>
                                    <option value="inactiveStudent">Inactive</option>
								</select>
							</td>
						</tr>
                        <tr>
							<td class="fieldTitle">Program:</td>
							<td>
								<select name="studentProgram" class="xLargeField" multiple="multiple" size="10">
									<cfloop query="qGetPrograms">
                                    	<option value="#qGetPrograms.programid#">#qGetPrograms.programname#</option>
                                    </cfloop>
                                </select>
							</td>
						</tr>		
						<tr><td colspan="2" bgcolor="e2efc7" class="submitButton" align="center"><input type="image" src="pics/view.gif" border="0"></td></tr>
					</table>
				</form>

			</td>
			<td valign="top"> 
				
             	<!--- Representatives --->
                <form action="reports/constantContactReps.cfm" method="post" target="_blank">
					<table cellpadding="4" cellspacing="0" class="nav_bar" width="90%" align="center">
						<tr><th colspan="2" bgcolor="e2efc7" class="title">Representatives</th></tr>
						<tr>
							<td class="fieldTitle">Status:</td>
							<td>
								<select name="representativeStatus" class="xLargeField">
                                	<!--- <option value="allRepresentatives">All</option> --->
                                	<option value="activeFullyEnabledRepresentatives">Active and Fully Enabled</option>
                                    <option value="activeNotFullyEnabledRepresentatives">Active and not Fully Enabled</option>
                                    <option value="inactiveRepresentatives">Inactive</option>
                                </select>
							</td>
						</tr>
                        <tr>
							<td class="fieldTitle">Type:</td>
							<td>
								<select name="representativeType" class="xLargeField" multiple="multiple" size="6">
									<cfloop query="qGetUserType">
                                    	<option value="#qGetUserType.userTypeID#">#qGetUserType.userType#</option>
                                    </cfloop>
                                </select>
							</td>
						</tr>		
						<tr><td colspan="2" bgcolor="e2efc7" class="submitButton" align="center"><input type="image" src="pics/view.gif" border="0"></td></tr>
					</table>
				</form>
                
         	</td>
		</tr>
        <tr>
        	<td>
            
            	<!--- Active Host Families --->
				<form action="reports/constantContactHostFamilies.cfm" method="post" target="_blank">
					<table cellpadding="4" cellspacing="0" class="nav_bar" width="90%" align="center">
						<tr><th colspan="2" bgcolor="e2efc7" class="title">Active Host Families</th></tr>
						<tr>
							<td class="fieldTitle">Students:</td>
							<td>
								<select name="hostFamilyStudents" class="xLargeField">
                                	<option value="allHostFamilies">All</option>
                                	<option value="withStudentsHostFamilies">Current Hosting</option>
                                    <option value="withoutStudentsHostFamilies">Not Current Hosting</option>
								</select>
							</td>
						</tr>		
						<tr><td colspan="2" bgcolor="e2efc7" class="submitButton" align="center"><input type="image" src="pics/view.gif" border="0"></td></tr>
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