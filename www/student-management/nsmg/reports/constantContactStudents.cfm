<!--- ------------------------------------------------------------------------- ----
	
	File:		constantContactStudents.cfm
	Author:		James Griffiths
	Date:		March 16, 2012
	Desc:		Constant Contact Information for Students

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.studentStatus" default="">
    <cfparam name="FORM.studentProgram" default="">
    
    <!--- No Errors - Run Report --->
    <cfif NOT SESSION.formErrors.length()>
        
        <!--- Run Query --->
        <cfquery name="qGetStudents" datasource="mysql">
        	SELECT DISTINCT s.email, s.firstname, s.familylastname
          	FROM smg_students s
           	INNER JOIN smg_programs p ON p.programid = s.programid
            WHERE s.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentProgram#" list="yes"> )
          	AND s.email !=  <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            <cfswitch expression="#FORM.studentStatus#">
               	<cfcase value="activeStudent">
                    AND s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                </cfcase>
                <cfcase value="inactiveStudent">
                    AND s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">         	
                </cfcase>
            </cfswitch>
            <cfif CLIENT.companyID EQ 5>
           		AND s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
           	<cfelse>
            	AND s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyid)#"> 
            </cfif>
            
        	GROUP BY s.familylastname
            ORDER BY s.familylastname                 
        </cfquery>        
    
    </cfif>
                
</cfsilent>
 
<!--- Display Errors --->
<cfif SESSION.formErrors.length()> 

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

	<!--- Table Footer --->
	<gui:tableFooter 
		width="98%"
	/>

<!--- Report --->
<cfelse>
 
  	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=constantContactStudents.xls">
 
 <cfoutput>
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" border="1">
            <tr>
                <td>Student Name</td>
                <td>Email</td>
            </tr>   
          
            <cfloop query="qGetStudents">
                <tr>
         			<td>#qGetStudents.firstname# #qGetStudents.familylastname#</td>
            		<td>#qGetStudents.email#</td>
                </tr>              
            </cfloop>
    
    	</table>
    
    </cfoutput>
    
</cfif> 