<!--- ------------------------------------------------------------------------- ----
	
	File:		constantContactStudents.cfm
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
                s.studentid, 
                s.uniqueid, 
                s.firstname, 
                s.familylastname,
                s.sex,
                s.email,
                s.intRep,
                php.active,
                php.canceldate,
                p.programname, 
                php.assignedID,
                php.programID               
            FROM 
                smg_students s
            INNER JOIN 
                php_students_in_program php on php.studentid = s.studentid
            INNER JOIN 
                smg_programs p ON php.programid = p.programid
            WHERE
                p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
            	<cfswitch expression="#FORM.active#">
                
                    <cfcase value="active">
                    	AND
                        	php.active = <cfqueryparam cfsqltype="cf_sql_integer" value=1>
                    </cfcase>

                    <cfcase value="inactive">
                        AND
                        	php.active = <cfqueryparam cfsqltype="cf_sql_integer" value=0>
						AND
                        	php.canceldate IS <cfqueryparam cfsqltype="cf_sql_date" null="no">                  	
                    </cfcase>

                    <cfcase value="cancelled">
                        AND
                        	php.active = <cfqueryparam cfsqltype="cf_sql_integer" value=0>
                        AND
                        	php.canceldate IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes"> 
                    </cfcase>
                    
                </cfswitch>
            GROUP BY
            	s.familylastname
            ORDER BY
            	s.familylastname             
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
	<cfheader name="Content-Disposition" value="attachment; filename=constantContactStudents.xls"> 
 
	<cfoutput>
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" border="1">
            <tr>
                <td>Student Name</td>
                <td>Gender</td>
                <td>Intl. Rep</td>
                <td>Email</td>
                <td>Program</td> 
            </tr>   
          
            <cfloop query="qGetResults">
                <tr>
                    <td>#qGetResults.firstName# #qGetResults.familyLastName#</td>
                    <td>#qGetResults.sex#</td>
                    <td>#qGetResults.intRep#</td>
                    <td>#qGetResults.email#</td>
                    <td>#qGetResults.programname#</td>          
                </tr>              
            </cfloop>
    
    	</table>
    
    </cfoutput>
    
</cfif> 