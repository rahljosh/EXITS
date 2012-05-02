<!--- ------------------------------------------------------------------------- ----
	
	File:		constantContactHostFamilies.cfm
	Author:		James Griffiths
	Date:		March 16, 2012
	Desc:		Constant Contact Information for Host Families

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.hostFamilyStudents" default="">
    
    <!--- No Errors - Run Report --->
    <cfif NOT SESSION.formErrors.length()>
        
        <!--- Run Query --->
        <cfquery name="qGetHostFamilies" datasource="mysql">
        	SELECT
                h.familylastname,
                h.fatherfirstname,
                h.motherfirstname,
                h.email
          	FROM
            	smg_hosts h
            WHERE
            	h.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND
            	h.email !=  <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                 <cfif CLIENT.companyID EQ 5>
                    AND          
                        h.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                <cfelse>
                    AND          
                        h.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
                </cfif>
                <cfswitch expression="#FORM.hostFamilyStudents#">
                    
                    <cfcase value="withStudentsHostFamilies">
                        AND
                            h.hostid IN 
                            (SELECT 
                                s.hostid 
                            FROM 
                                smg_students s
                            WHERE 
                                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                            <cfif CLIENT.companyID EQ 5>
                                AND          
                                    s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                            <cfelse>
                                AND          
                                    s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
                            </cfif>
                            )
                    </cfcase>
    
                    <cfcase value="withoutStudentsHostFamilies">
                        AND
                            h.hostid NOT IN 
                            (SELECT 
                                s.hostid 
                            FROM 
                                smg_students s
                            WHERE 
                                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                            <cfif CLIENT.companyID EQ 5>
                                AND          
                                    s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                            <cfelse>
                                AND          
                                    s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
                            </cfif>
                            )
                    </cfcase>
                        
                </cfswitch>
            ORDER BY
            	h.familylastname                 
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
	<cfheader name="Content-Disposition" value="attachment; filename=constantContactHostFamilies.xls"> 
 
 <cfoutput>
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" border="1">
            <tr>
                <td>Host Family Name</td>
                <td>Email</td>
            </tr>   
          
            <cfloop query="qGetHostFamilies">
                <tr>
                	<!--- if this family has both a father and mother first name put an and between them, otherwise output whichever name is there --->
                	<cfif LEN(fatherfirstname) AND LEN(motherfirstname)>
                    	<td>#qGetHostFamilies.fatherfirstname# and #qGetHostFamilies.motherfirstname# #qGetHostFamilies.familylastname#</td>
                   	<cfelse>
                    	<td>#qGetHostFamilies.fatherfirstname# #qGetHostFamilies.motherfirstname# #qGetHostFamilies.familylastname#</td>
                   	</cfif>
                	<td>#qGetHostFamilies.email#</td>        
                </tr>              
            </cfloop>
    
    	</table>
    
    </cfoutput>
    
</cfif> 