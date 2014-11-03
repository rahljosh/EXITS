<!--- ------------------------------------------------------------------------- ----
	
	File:		_initial.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Intial Page - User Payments
				
				index.cfm?curdoc=userPayment/index&action=searchRepresentative
				
	Update:		11/02/2012 - Combining all divisions so Thea doesn't need to switch
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
	<!----Students with associated reps---->
    <cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
        SELECT 
        	studentID,
            areaRepID, 
            placeRepID, 
            familyLastName, 
            firstName            
        FROM 
        	smg_students
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
        	hostid != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>
        ORDER BY 
        	familyLastName
    </cfquery>
    
    <!----Reps supervising students---->
    <cfquery name="qGetSupervisingReps" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT 
       		u.userid,
        	u.firstName, 
            u.lastname, 
            s.areaRepID
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON s.areaRepID = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>
        GROUP BY
        	u.userID
        ORDER BY 
        	u.lastname
    </cfquery>
    
    <!----Reps who placed students---->
    <cfquery name="qGetPlacingReps" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT 
        	u.userid,        	
            u.firstName, 
            u.lastname,
			s.placeRepID
        FROM 
        	smg_students s 
        INNER JOIN 
        	smg_users u ON s.placeRepID = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>
        GROUP BY
        	u.userID
        ORDER BY 
        	u.lastname
    </cfquery>

    <!----Reps who second visited students---->
    <cfquery name="qGetSecondVisitReps" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT 
        	u.userid,        	
            u.firstName, 
            u.lastname,
			s.placeRepID
        FROM 
        	smg_students s 
        INNER JOIN 
        	smg_users u ON s.secondVisitRepID = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>
        GROUP BY
        	u.userID
        ORDER BY 
        	u.lastname
    </cfquery>
    
    <!--- GET CURRENT AND HISTORY PLACE AND SUPER --->
    <cfquery name="qGetSplitPaymentReps" datasource="#APPLICATION.DSN#">
        <!--- Area History --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_hosthistory h ON h.studentID = s.studentID
        INNER JOIN 
        	smg_users u ON h.areaRepID = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>

        UNION
		
        <!--- Area Active --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON s.areaRepID = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>

        UNION
		
        <!--- Place History --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_hosthistory h ON h.studentID = s.studentID
        INNER JOIN 
        	smg_users u ON h.placeRepID = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>

        UNION

		<!--- Place Active --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON s.placeRepID = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>
		
        UNION

        <!--- Second Rep History --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_hosthistory h ON h.studentID = s.studentID
        INNER JOIN 
        	smg_users u ON h.secondVisitRepID = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>

        UNION
            
		<!--- Second Rep Active --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON s.secondVisitRepID = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>

        UNION
        
        <!--- Area Rep History | Place Rep History | Second Rep History | New Table --->
        SELECT DISTINCT 
        	u.userid,
            u.firstName, 
            u.lastname             
        FROM 
        	smg_users u
        INNER JOIN
        	smg_hosthistorytracking sht ON sht.fieldID = u.userID
            	AND
                	sht.fieldName IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="areaRepID,placeRepID,secondVisitRepID" list="yes"> )
        INNER JOIN 
        	smg_students s ON sht.studentID = s.studentID
            AND	
                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                AND
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                AND
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
            </cfif>
        
        GROUP BY 
        	userid
        ORDER BY 
        	lastname, 
            firstName
    </cfquery>
    
</cfsilent>

<cfoutput>

<!--- Search Representative --->
<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchRepresentative">
    <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
        <tr>
            <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Search for a Representative by</td>
        </tr>	
		<!--- Display Error Message --->
        <cfif URL.errorSection EQ 'searchRepresentative'> 
            <tr>
                <td colspan="2">
                    <!--- Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="divOnly"
                        width="95%"
                        />
                </td>
            </tr>                        
        </cfif>
        <tr>		
            <td align="center" style="height:50px;">
                <p>Specify the Representative that you want to work with:</p>
                
                Last Name: <input type="text" name="lastName" class="xLargeField">
                &nbsp;&nbsp;&nbsp;<strong>- OR -</strong>&nbsp;&nbsp;&nbsp; 
                User ID: <input type="text" name="userID" size="4" class="smallField">
            </td>
        </tr>
        <tr style="background-color:##E2EFC7;">
            <td align="center" colspan="2"><input name="submit" type="image" src="pics/next.gif" align="center" border="0" alt="Next"></td>
        </tr>
    </table>
</form>
<!--- End of Search Representative --->


<!--- Select Representative --->
<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment">
    <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
        <tr>
            <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Select Representative from List &nbsp; (Representatives current linked to a student)</td>
        </tr>	
		<!--- Display Error Message --->
        <cfif URL.errorSection EQ 'selectRepresentative'> 
            <tr>
                <td colspan="2">
                    <!--- Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="divOnly"
                        width="95%"
                        />
                </td>
            </tr>                        
        </cfif>
        <tr>
            <td colspan="2">
                <p> 
                	Lists only contain reps that placed an active student or are activily supervising a student. 
                	To see the payment details of a rep who isn't activly supervising or didn't place an active student, use the search above.
                </p>
            </td>
        </tr>
        <tr>
            <td width="45%" align="right">Select by Supervising Representative: </td>
            <td>
                <select name="areaRepID" class="xLargeField">
                    <option value="0"></option>
                    <cfloop query="qGetSupervisingReps">
                    <option value="#qGetSupervisingReps.userid#">#qGetSupervisingReps.lastname#, #qGetSupervisingReps.firstName# (###qGetSupervisingReps.userid#)</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center"><strong>- OR -</strong></td>
        </tr>
        <tr>
            <td align="right">Select by Placing Representative:</td>
            <td>
                <select name="placeRepID" class="xLargeField">
                    <option value="0"></option>
                    <cfloop query="qGetPlacingReps">
                    	<option value="#qGetPlacingReps.userid#">#qGetPlacingReps.lastname#, #qGetPlacingReps.firstName# (###qGetPlacingReps.userid#)</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center"><strong>- OR -</strong></td>
        </tr>
        <tr>
            <td align="right">Select by Second Visit Representative:</td>
            <td>
                <select name="secondVisitRepID" class="xLargeField">
                    <option value="0"></option>
                    <cfloop query="qGetSecondVisitReps">
                    	<option value="#qGetSecondVisitReps.userid#">#qGetSecondVisitReps.lastname#, #qGetSecondVisitReps.firstName# (###qGetSecondVisitReps.userid#)</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center"><strong>- OR -</strong></td>
        </tr>
        <tr>
            <td align="right">Select by Student:</td><td>
                <select name="studentID" class="xLargeField">
                    <option value="0"></option>
                    <cfloop query="qGetPlacedStudents">
                        <option value="#qGetPlacedStudents.studentID#">#qGetPlacedStudents.familyLastName#, #qGetPlacedStudents.firstName# (###qGetPlacedStudents.studentID#)</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr style="background-color:##E2EFC7;">
            <td align="center" colspan="2"><input name="submit" type="image" src="pics/next.gif" align="center" border="0" alt="Next"></td>
        </tr>
    </table>
</form>
<!--- End of Select Representative --->


<!--- Search Student --->
<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchStudent">
    <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
        <tr>
            <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Search for a Student</td>
        </tr>	
		<!--- Display Error Message --->
        <cfif URL.errorSection EQ 'searchStudent'> 
            <tr>
                <td colspan="2">
                    <!--- Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="divOnly"
                        width="95%"
                        />
                </td>
            </tr>                        
        </cfif>
        <tr>		
            <td align="center"><br>
                Last Name: <input type="text" name="familyLastName" class="xLargeField">
                &nbsp;&nbsp;&nbsp;<strong>- OR -</strong>&nbsp;&nbsp;&nbsp; 
                Student ID: <input type="text" name="studentID" size="4" class="smallField"><br><br>
            </td>
        </tr>
        <tr style="background-color:##E2EFC7;">
            <td align="center" colspan="2"><input name="submit" type="image" src="pics/next.gif" align="center" border="0" alt="Next"></td>
        </tr>
    </table>
</form>
<!--- End of Search Student --->


<!--- Split Payments  --->
<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment">
	<input type="hidden" name="isSplitPayment" value="1" />
    <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
        <tr>
            <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Split Payments</td>
        </tr>	
        <!--- Display Error Message --->
        <cfif URL.errorSection EQ 'splitPayments'> 
            <tr>
                <td colspan="2">
                    <!--- Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="divOnly"
                        width="95%"
                        />
                </td>
            </tr>                        
        </cfif>
        <tr>
            <td width="45%" align="right">Select the Representative: </td>
            <td>
                <select name="areaRepID" class="xLargeField">
                    <option value="0"></option>
                    <cfloop query="qGetSplitPaymentReps">
                        <option value="#qGetSplitPaymentReps.userid#">#qGetSplitPaymentReps.lastname#, #qGetSplitPaymentReps.firstName# (###qGetSplitPaymentReps.userid#)</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr style="background-color:##E2EFC7;">
            <td align="center" colspan="2"><input name="submit" type="image" src="pics/next.gif" align="center" border="0" alt="Next"></td>
        </tr>
    </table>
</form>
<!--- End of Split Payments  --->


<!--- Incentive Trip  --->
<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=incentiveTripPayment">
    <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
        <tr>
            <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Incentive Trip Payments</td>
        </tr>	
        <!--- Display Error Message --->
        <cfif URL.errorSection EQ 'incentiveTrip'> 
            <tr>
                <td colspan="2">
                    <!--- Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="divOnly"
                        width="95%"
                        />
                </td>
            </tr>                        
        </cfif>
        <tr>
            <td width="45%" align="right">Select the Representative: </td>
            <td>
                <select name="userID" class="xLargeField">
                    <option value="0"></option>
                    <cfloop query="qGetPlacingReps">
                        <option value="#userid#">#lastname#, #firstName# (#userid#)</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr style="background-color:##E2EFC7;">
            <td align="center" colspan="2"><input name="submit" type="image" src="pics/next.gif" align="center" border="0" alt="Next"></td>
        </tr>
    </table>
</form>
<!--- End of Incentive Trip --->

<!--- Credits --->
<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=credits">
    <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
        <tr>
            <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Credits</td>
        </tr>	
		<!--- Display Error Message --->
        <cfif URL.errorSection EQ 'credits'> 
            <tr>
                <td colspan="2">
                    <!--- Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="divOnly"
                        width="95%"
                        />
                </td>
            </tr>                        
        </cfif>
        <tr>		
            <td align="center"><br>
            	Representative: 
                <select name="agentID" class="xLargeField">
                    <option value="0"></option>
                    <cfloop query="qGetSplitPaymentReps">
                        <option value="#qGetSplitPaymentReps.userid#">#qGetSplitPaymentReps.lastname#, #qGetSplitPaymentReps.firstName# (###qGetSplitPaymentReps.userid#)</option>
                    </cfloop>
                </select>
                &nbsp;&nbsp;&nbsp;<strong>- OR -</strong>&nbsp;&nbsp;&nbsp; 
                Student ID: <input type="text" name="studentID" size="6" class="smallField">
                &nbsp;&nbsp;&nbsp;<strong>- OR -</strong>&nbsp;&nbsp;&nbsp; 
                Payment ID: <input type="text" name="paymentID" size="6" class="smallField">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="checkbox" name="payments" value="1" />Credit Payments
                <br><br>
            </td>
        </tr>
        <tr style="background-color:##E2EFC7;">
            <td align="center" colspan="2"><input name="submit" type="image" src="pics/next.gif" align="center" border="0" alt="Next"></td>
        </tr>
    </table>
</form>
<!--- End of Credits --->

<table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
	<tr>
		<td colspan="2"><strong><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=maintenance">Supervising Payment Maintenance</a></strong></font></td>
	</tr>	
</table>

</cfoutput>