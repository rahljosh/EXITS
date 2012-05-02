<!--- ------------------------------------------------------------------------- ----
	
	File:		constantContactIntlReps.cfm
	Author:		James Griffiths
	Date:		March 16, 2012
	Desc:		Constant Contact Information for Representatives

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.representativeStatus" default="">
    <cfparam name="FORM.representativeType" default="">
    
	<cfscript>
		vColorTitle = 'ACB9CD';
        vColorRow = 'D5DCE5';
    </cfscript>
    
    <!--- No Errors - Run Report --->
    <cfif NOT SESSION.formErrors.length()>
        
        <!--- Run Query --->
        <cfquery name="qGetRepresentatives" datasource="mysql">
        	SELECT DISTINCT
                u.email,
                u.firstname,
                u.lastname
          	FROM
            	smg_users u
           	INNER JOIN
            	user_access_rights uar ON uar.userID = u.userID
            WHERE
            	uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.representativeType#" list="yes"> )
          	AND
            	u.email !=  <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            
            <cfswitch expression="#FORM.representativeStatus#">
                
                <cfcase value="activeRepresentatives">
                    AND
                        u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                </cfcase>

                <cfcase value="inactiveRepresentatives">
                    AND
                        u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">         	
                </cfcase>
                    
            </cfswitch>
            
            <cfif CLIENT.companyID EQ 5>
           		AND          
           			uar.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
           	<cfelse>
            	AND          
             		uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
            </cfif>
            
        	GROUP BY
            	u.lastname
            ORDER BY
            	u.lastname                 
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
	<cfheader name="Content-Disposition" value="attachment; filename=constantContactRepresentatives.xls">
 
 <cfoutput>
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" border="1">
            <tr>
                <td>Representative Name</td>
                <td>Email</td>
            </tr>   
          
            <cfloop query="qGetRepresentatives">
                <tr>
         			<td>#qGetRepresentatives.firstname# #qGetRepresentatives.lastname#</td>
            		<td>#qGetRepresentatives.email#</td>
                </tr>              
            </cfloop>
    
    	</table>
    
    </cfoutput>
    
</cfif> 