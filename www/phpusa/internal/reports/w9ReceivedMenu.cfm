<!--- ------------------------------------------------------------------------- ----
	
	File:		flightMenu.cfm
	Author:		Marcus Melo
	Date:		May 12, 2010
	Desc:		Flight Reports Menu

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.reportOption" default="">
    <cfparam name="FORM.date1" default="">
    <cfparam name="FORM.date2" default="">
    <cfparam name="FORM.orderBy" default="familyLastName">
    
    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(isActive=1,dateActive=1,companyID=CLIENT.companyID);
	</cfscript>
    
</cfsilent>

<cfoutput>
    
	<!--- Table Header --->
    <gui:tableHeader
        width="98%"
        tableTitle="Flight Information Reports"
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
				
                <!--- Received Flight --->
				<form action="index.cfm?curdoc=reports/w9received" method="post">
					<table class="reportTableLeft" cellpadding="4" cellspacing="0">
						<tr><th colspan="2" class="title">Status of W9 Forms per program</th></tr>
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
						<!----<tr>
							<td class="fieldTitle">Report Option:</td>
							<td>
								<select name="reportOption" class="xLargeField">
									<option value="" <cfif NOT LEN(FORM.reportOption)> selected="selected" </cfif> >Select an Option</option>
									<option value="receivedArrival" <cfif FORM.reportOption EQ 'receivedW9'> selected="selected" </cfif> >At least 1 Received W-9 Forms</option>
									<option value="receivedDeparture" <cfif FORM.reportOption EQ 'missingW9'> selected="selected" </cfif> >Both Missing W-9 Forms</option>
								</select>
							</td>
						</tr>	---->	
					
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