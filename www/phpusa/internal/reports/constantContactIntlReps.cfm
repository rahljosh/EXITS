<!--- ------------------------------------------------------------------------- ----
	
	File:		constantContactIntlReps.cfm
	Author:		James Griffiths
	Date:		March 12, 2012
	Desc:		Constant Contact Information for Students

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="">
    
	<cfscript>
        // Data Validation
        // Program ID
        if ( NOT LEN(FORM.programID) ) {
            SESSION.formErrors.Add("Please select at least one program");
        }
		vColorTitle = 'ACB9CD';
        vColorRow = 'D5DCE5';
    </cfscript>
    
    <!--- No Errors - Run Report --->
    <cfif NOT SESSION.formErrors.length()>
        
        <!--- Run Query --->
        <cfquery name="qGetResults" datasource="mysql">
            SELECT DISTINCT
                u.email,
                u.businessname
          	FROM
            	smg_students s
           	INNER JOIN
            	smg_users u on u.userid = s.intrep
            INNER JOIN
            	php_students_in_program php on php.studentid = s.studentid
        	WHERE
                php.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
           	GROUP BY
            	u.businessname
            ORDER BY
            	u.businessname              
        </cfquery>        
    
    </cfif>
                
</cfsilent>
 
<!--- Display Errors --->
<cfif SESSION.formErrors.length()>

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

	<!--- Table Footer --->
	<gui:tableFooter 
		width="98%"
	/>

<!--- Report --->
<cfelse>
 
 	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=constantContactIntlReps.xls"> 
 
 <cfoutput>
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" border="1">
            <tr>
                <td>Business Name</td>
                <td>Email</td>
            </tr>   
          
            <cfloop query="qGetResults">
                <tr>
                    <td>#qGetResults.businessname#</td>
                	<td>#qGetResults.email#</td>          
                </tr>              
            </cfloop>
    
    	</table>
    
    </cfoutput>
    
</cfif> 