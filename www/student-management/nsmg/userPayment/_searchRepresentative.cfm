<!--- ------------------------------------------------------------------------- ----
	
	File:		_searchRepresentative.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Searches for a representative
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
    	
	<cfscript>
		// Data Validation
		if ( NOT LEN(FORM.lastName) AND NOT LEN(FORM.userID) ) {
			// Error Message
			SESSION.formErrors.Add('You must enter one of the criterias below');			
		} else if ( LEN(FORM.lastName) AND LEN(FORM.userID) ) {
			// Error Message
			SESSION.formErrors.Add('You must select only ONE of the criterias below');			
		}
		
		// Check if there are errors
		if ( SESSION.formErrors.length() ) {			
			// Relocate to Inital page and display error message
			Location("#CGI.SCRIPT_NAME#?curdoc=userPayment/index&errorSection=searchRepresentative", "no");
		}		
	</cfscript>
    
    <cfquery name="qSearchRepresentative" datasource="MySql">
        SELECT DISTINCT 	
            u.userid,
            u.firstName, 
            u.lastname         
        FROM 
            smg_users u
        INNER JOIN 
            user_access_rights uar ON uar.userid = u.userid
        WHERE 
            uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,15" list="yes"> )
        AND 
            u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND 
            uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            
        <cfif LEN(FORM.lastName)>
            AND 
                u.lastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#FORM.lastName#%">
        </cfif>
        
        <cfif VAL(FORM.userID)>
            AND 
                u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
        </cfif>
        
        ORDER BY 
            <cfswitch expression="#URL.orderBy#">
            
                <cfcase value="userID">
                    u.userID,
                    u.lastName
                </cfcase>
                
                <cfcase value="firstName">
                    u.firstName, 
                    u.lastName
                </cfcase>
        
                <cfcase value="lastName">
                    u.lastname, 
                    u.firstName
                </cfcase>
    
                <cfdefaultcase>
                    u.lastName, 
                    u.firstName
                </cfdefaultcase>
    
            </cfswitch>
                    
    </cfquery>

</cfsilent>

<cfoutput>

	<script language="JavaScript">
        <!-- Begin
        function countChoices(obj) {
        max = 1; // max. number allowed at a time
        
        <cfloop from="1" to="#qSearchRepresentative.recordcount#" index='i'>
        placing#i# = obj.FORM.placing#i#.checked; </cfloop>
        
        count = <cfloop from="1" to="#qSearchRepresentative.recordcount#" index='i'> (placing#i# ? 1 : 0) <cfif qSearchRepresentative.recordcount is #i#>; <cfelse> + </cfif> </cfloop>
        // If you have more checkboxes on your form
        // add more  (box_ ? 1 : 0)  's separated by '+'
        if (count > max) {
        alert("Oops!  You can only choose up to " + max + " choice! \nUncheck an option if you want to pick another.");
        obj.checked = false;
           }
        }
        //  End -->
    </script>

    

    <div style="margin-top:10px;">Specify ONLY ONE Representative that you want to work with from the list below:</div>        

    <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment" name="myform">
        
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
            <tr>
                <td colspan="5" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Representatives Search Results</td>
            </tr>    
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="4%">&nbsp;</td>
                <td width="10%"><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchRepresentative&orderBy=userid&lastname=#lastName#&userid=#userID#">ID</a></Td>
                <td width="25%">
                    <a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchRepresentative&orderBy=lastname&lastname=#lastName#&userid=#userID#">Last Name</a>, 
                    <a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchRepresentative&orderBy=firstName&lastname=#lastName#&userid=#userID#">First Name</a>
                </td>
                <td width="61%">&nbsp;</td>
            </tr>
            
            <cfif VAL(qSearchRepresentative.recordcount)>
                <cfloop query="qSearchRepresentative">	
                    <tr bgcolor="###iif(qSearchRepresentative.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                        <td><input type="checkbox" name="areaRepID" id="userID#currentrow#" value="#userID#" onClick="countChoices(this)"></td>
                        <Td><label for="userID#currentrow#">#userid#</label></Td>
                        <td><label for="userID#currentrow#">#lastname#, #firstName#</label></td>
                        <td>&nbsp;</td>
                    </tr>
                </cfloop>
                <tr style="background-color:##E2EFC7;">
                    <td colspan="4" align="center"> <input name="submit" type="image" src="pics/next.gif" border="0" alt="search"></td>
                </tr>
            <cfelse>
                <tr>
                    <td colspan="4" align="center">Sorry, none representatives have matched your criteria. Please change your criteria and try again.</td>
                </tr>
                <tr style="background-color:##E2EFC7;">
                    <td colspan="4" align="center"><img border="0" src="pics/back.gif" onClick="javascript:history.back()"></td>
                </tr>
            </cfif>
    
        </table>
        
    </form><br>
    
</cfoutput>