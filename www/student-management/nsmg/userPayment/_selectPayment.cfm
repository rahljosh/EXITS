<!--- ------------------------------------------------------------------------- ----
	
	File:		_selectPayment.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Process Representative Payment
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<cfscript>
		// Data Validation - selectRepresentative
		if ( NOT VAL(FORM.areaRepID) AND NOT VAL(FORM.placeRepID) AND NOT VAL(FORM.secondVisitRepID) AND NOT VAL(FORM.studentID) ) {
			// Error Message
			SESSION.formErrors.Add('You must enter one of the criterias below');			
		} else if ( VAL(FORM.areaRepID) AND VAL(FORM.placeRepID) AND VAL(FORM.secondVisitRepID) ) {
			// Error Message
			SESSION.formErrors.Add('You must select only ONE of the criterias below');		
		}

		// Check if there are errors
		if ( SESSION.formErrors.length() ) {			
			// Relocate to Inital page and display error message
			Location("#CGI.SCRIPT_NAME#?curdoc=userPayment/index&errorSection=selectRepresentative", "no");
		}

		// Data Validation - Search Representative Form
		if ( ListLen(FORM.areaRepID) GT 1 ) {
			// Error Message
			SESSION.formErrors.Add('You must select only ONE representative');			

			// Relocate to Inital page and display error message
			Location("#CGI.SCRIPT_NAME#?curdoc=userPayment/index&errorSection=searchRepresentative", "no");
		}
	
		// Data Validation - Search Student Form
		if ( ListLen(FORM.studentID) GT 1 ) {
			// Error Message
			SESSION.formErrors.Add('You must select only ONE student');			

			// Relocate to Inital page and display error message
			Location("#CGI.SCRIPT_NAME#?curdoc=userPayment/index&errorSection=searchStudent", "no");
		}

		if ( VAL(FORM.areaRepID) ) {
			FORM.userID = FORM.areaRepID;	
		}

		if ( VAL(FORM.placeRepID) ) {
			FORM.userID = FORM.placeRepID;	
		}

		if ( VAL(FORM.secondVisitRepID) ) {
			FORM.userID = FORM.secondVisitRepID;	
		}

    	// Student Select - Locate to search by Rep
    	if ( VAL(FORM.studentID) AND NOT VAL(FORM.userID) ) {
			Location("#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=listStudentRepresentatives&studentID=#FORM.studentID#", "no");
		}
    </cfscript>
	    
    <cfquery name="qGetsupervisedPaymentType" datasource="MySql">
        SELECT 
        	id, 
            type
        FROM 
        	smg_payment_types
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
        	( 
        		paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="Supervision">
            OR
            	paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            )
    </cfquery>
    
    <cfquery name="qGetPlacedPaymentType" datasource="MySql">
        SELECT 
        	id, 
            type
        FROM 
        	smg_payment_types
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
        	( 
        		paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="Placement">
            OR
            	paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            )
    </cfquery>

    <cfquery name="qGetSecondVisitPaymentType" datasource="MySql">
        SELECT 
        	id, 
            type
        FROM 
        	smg_payment_types
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
            paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisit">
    </cfquery>

    <cfquery name="qGetRepInfo" datasource="MySQL">
        SELECT 
        	userid,
        	firstName, 
            lastname
        FROM 
        	smg_users
        WHERE 
			userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
    </cfquery>

    <!--- Get all students supervised by selected rep --->
    <cfquery name="qGetSupervisedStudents" datasource="MySQL">
        SELECT DISTINCT
        	s.studentID, 
            s.familyLastName, 
            s.firstName, 
            s.programID, 
            p.programName
        FROM
        	smg_students s
        INNER JOIN
        	smg_programs p ON p.programID = s.programID
                AND
                    p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -13, now())#">
        WHERE 
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND	
            s.areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
        
        <cfif VAL(FORM.studentID)>
        	AND
            	s.studentID =<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
        </cfif>

		<!--- Split Payments - Display All students from the placement history --->
        <cfif FORM.isSplitPayment>
            UNION
            
            SELECT DISTINCT 
                s.studentID, 
                s.familyLastName, 
                s.firstName,
                s.programID, 
                programName
            FROM 
                smg_students s
            INNER JOIN
                smg_programs p ON p.programID = s.programID
                    AND
                        p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -13, now())#">
            INNER JOIN 
                smg_hosthistory h ON h.studentID = s.studentID
            WHERE 
                h.areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
            AND 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
			
            UNION
            
            <!--- Area Rep History | New Table --->
            SELECT DISTINCT 
                s.studentID, 
                s.familyLastName, 
                s.firstName,
                s.programID, 
                programName
            FROM 
                smg_students s
            INNER JOIN
                smg_programs p ON p.programID = s.programID
                    AND
                        p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -13, now())#">
            INNER JOIN
                smg_hostHistoryTracking sht ON sht.studentID = s.studentID
                    AND
                        sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="areaRepID">
                    AND
                    	sht.fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
            WHERE 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">

            GROUP BY 
                studentID        
		</cfif>               
		<!--- End of Split Payments - Display All students pl --->
        
        ORDER BY
        	studentID DESC
    </cfquery>
    
    <!--- Get all students placed by selected rep --->
    <cfquery name="qGetPlacedStudents" datasource="mysql">
        SELECT DISTINCT
        	s.studentID, 
            s.familyLastName, 
            s.firstName, 
            s.programID, 
            p.programName
        FROM
        	smg_students s
        INNER JOIN
        	smg_programs p ON p.programID = s.programID
                AND
                    p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -13, now())#">
        WHERE 
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND	
            s.placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">

        <cfif VAL(FORM.studentID)>
        	AND
            	s.studentID =<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
        </cfif>

		<!--- Split Payments - Display All students from the placement history --->
        <cfif FORM.isSplitPayment>
            UNION
            
            SELECT DISTINCT 
                s.studentID, 
                s.familyLastName, 
                s.firstName,
                s.programID, 
                programName
            FROM 
                smg_students s
            INNER JOIN
                smg_programs p ON p.programID = s.programID
                    AND
                        p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -13, now())#">
            INNER JOIN 
                smg_hosthistory h ON h.studentID = s.studentID
             WHERE 
                h.placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
             AND 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
			
            UNION
            
            <!--- Place Rep History | New Table --->
            SELECT DISTINCT 
                s.studentID, 
                s.familyLastName, 
                s.firstName,
                s.programID, 
                programName
            FROM 
                smg_students s
            INNER JOIN
                smg_programs p ON p.programID = s.programID
                    AND
                        p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -13, now())#">
            INNER JOIN
                smg_hostHistoryTracking sht ON sht.studentID = s.studentID
                    AND
                        sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="placeRepID">
                    AND
                    	sht.fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
            WHERE 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">

            GROUP BY 
                studentID        
		</cfif>               
		<!--- End of Split Payments - Display All students pl --->
            
        ORDER BY 
        	studentID DESC
    </cfquery>

    <!--- Get all students visited by the by selected rep --->
    <cfquery name="qGetSecondVisitedStudents" datasource="mysql">
        SELECT DISTINCT
        	s.studentID, 
            s.familyLastName, 
            s.firstName, 
            s.programID, 
            p.programName
        FROM
        	smg_students s
        INNER JOIN
        	smg_programs p ON p.programID = s.programID
                AND
                    p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -13, now())#">
        WHERE 
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND	
            s.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">

        <cfif VAL(FORM.studentID)>
        	AND
            	s.studentID =<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
        </cfif>
        
		<!--- Split Payments - Display All students from the placement history --->
        <cfif FORM.isSplitPayment>
            UNION
            
            SELECT DISTINCT 
                s.studentID, 
                s.familyLastName, 
                s.firstName,
                s.programID, 
                programName
            FROM 
                smg_students s
            INNER JOIN
                smg_programs p ON p.programID = s.programID
                    AND
                        p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -13, now())#">
            INNER JOIN 
                smg_hosthistory h ON h.studentID = s.studentID
             WHERE 
                h.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
             AND 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
			
            UNION
            
            <!--- Place Rep History | New Table --->
            SELECT DISTINCT 
                s.studentID, 
                s.familyLastName, 
                s.firstName,
                s.programID, 
                programName
            FROM 
                smg_students s
            INNER JOIN
                smg_programs p ON p.programID = s.programID
                    AND
                        p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m', -13, now())#">
            INNER JOIN
                smg_hostHistoryTracking sht ON sht.studentID = s.studentID
                    AND
                        sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisitRepID">
                    AND
                    	sht.fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
            WHERE 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">

            GROUP BY 
                studentID        
		</cfif>               
		<!--- End of Split Payments - Display All students pl --->

        ORDER BY 
        	studentID DESC
    </cfquery>

</cfsilent>

<cfoutput>

    <h2 style="margin-top:10px;">
        Representative: #qGetRepInfo.firstName# #qGetRepInfo.lastname# (###qGetRepInfo.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
        <a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetRepInfo.userid#', 700, 500);" class="nav_bar">Payment History</a>
    </h2>
    
    <cfform method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment">
        <input type="hidden" name="userID" value="#qGetRepInfo.userid#">
		<input type="hidden" name="isSplitPayment" value="#FORM.isSplitPayment#">
        
        <div style="margin-top:10px;">Check each student you want to apply payments for.</div>        
		
        <!--- SUPERVISED STUDENTS --->
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
            <tr>
                <td colspan="5" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Supervised Students &nbsp; - &nbsp; Total of #qGetSupervisedStudents.recordcount# student(s)</td>
            </tr>
            <cfif qGetSupervisedStudents.recordCount>
                <tr>
                    <td colspan="5" style="font-weight:bold;">
                        Please, select type of payment for the supervised students: 
                        <cfselect name="supervisedPaymentType" query="qGetsupervisedPaymentType" value="id" display="type" queryPosition="below" class="xLargeField">
                            <option value="">-- Select a Type --</option>
                        </cfselect>
                    </td>
                </tr>
                <tr style="background-color:##E2EFC7; font-weight:bold;">
                    <td width="4%">&nbsp;</td>
                    <td width="10%">ID</td>
                    <td width="25%">Last Name, First Name</td>
                    <td width="25%">Program</td>
                    <td width="36%">Actions</td>
                </tr>
                <cfloop query="qGetSupervisedStudents">
                    <tr bgcolor="###iif(qGetSupervisedStudents.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                        <td align="center"><input type="checkbox" name="supervisedStudentIDList" id="superCheckBox#qGetSupervisedStudents.studentID#" value="#qGetSupervisedStudents.studentID#"></td>
                        <td>
                            <label for="superCheckBox#qGetSupervisedStudents.studentID#">
                                #qGetSupervisedStudents.studentID#
                            </label>
                        </td>
                        <td>
                            <label for="superCheckBox#qGetSupervisedStudents.studentID#">
                                #qGetSupervisedStudents.familyLastName#, #qGetSupervisedStudents.firstName#
                            </label>
                        </td>
                        <td>#qGetSupervisedStudents.programName#</td>
                        <td><a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetSupervisedStudents.studentID#', 700, 500);" class="nav_bar">[ Payment History ]</a></td>  
                    </tr>
                </cfloop>
            <cfelse>
            	<tr bgcolor="##FFFFFF">
                	<td align="center">No supervised students found</td>
				</tr>                                
			</cfif>
		</table>
        
        <!--- PLACED STUDENTS --->
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr>
                <td colspan="5" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Placed Students &nbsp; - &nbsp; Total of #qGetPlacedStudents.recordcount# student(s)</td>
            </tr>
            <cfif qGetPlacedStudents.recordCount>
                <tr>
                    <td colspan="5" style="font-weight:bold;">
                        Please, select type of payment for the placed students: 
                        <cfselect name="placedPaymentType" query="qGetPlacedPaymentType" value="id" display="type" queryPosition="below" class="xLargeField">
                            <option value="">-- Select a Type --</option>
                        </cfselect>
                    </td>
                </tr>
                <tr style="background-color:##E2EFC7; font-weight:bold;">
                    <td width="4%">&nbsp;</td>
                    <td width="10%">ID</td>
                    <td width="25%">Last Name, First Name</td>
                    <td width="25%">Program</td>
                    <td width="36%">Actions</td>
                </tr>
                <cfloop query="qGetPlacedStudents">
                    <tr bgcolor="###iif(qGetPlacedStudents.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                        <td align="center"><input type="checkbox" name="placedStudentIDList" id="placeCheckBox#qGetPlacedStudents.studentID#" value="#qGetPlacedStudents.studentID#"></td>
                        <td>
                            <label for="placeCheckBox#qGetPlacedStudents.studentID#">
                                #qGetPlacedStudents.studentID#
                            </label>
                        </td>
                        <td>
                            <label for="placeCheckBox#qGetPlacedStudents.studentID#">
                                #qGetPlacedStudents.familyLastName#, #qGetPlacedStudents.firstName#
                            </label>
                        </td>
                        <td>#qGetPlacedStudents.programName#</td> 
                        <td><a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetPlacedStudents.studentID#', 700, 500);" class="nav_bar">[ Payment History ]</a></td>  
                    </tr>
                </cfloop>
            <cfelse>
            	<tr bgcolor="##FFFFFF">
                	<td align="center">No placed students found</td>
				</tr>                                
			</cfif>
        </table>

        <!--- 2nd VISIT REPRESENTATIVE STUDENTS --->
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr>
                <td colspan="5" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">2<sup>nd</sup> visit Representative Students &nbsp; - &nbsp; Total of #qGetSecondVisitedStudents.recordcount# student(s)</td>
            </tr>
            <cfif qGetSecondVisitedStudents.recordCount>
                <tr>
                    <td colspan="5" style="font-weight:bold;">
                        Please, select type of payment for the second visit students: 
                        <cfselect name="secondVisitPaymentType" query="qGetSecondVisitPaymentType" value="id" display="type" queryPosition="below" class="xLargeField">
                            <!--- <option value="">-- Select a Type --</option> --->
                        </cfselect>
                    </td>
                </tr>
                <tr style="background-color:##E2EFC7; font-weight:bold;">
                    <td width="4%">&nbsp;</td>
                    <td width="10%">ID</td>
                    <td width="25%">Last Name, First Name</td>
                    <td width="25%">Program</td>
                    <td width="36%">Actions</td>
                </tr>
                <cfloop query="qGetSecondVisitedStudents">
                    <tr bgcolor="###iif(qGetSecondVisitedStudents.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                        <td align="center"><input type="checkbox" name="secondVisitStudentIDList" id="secondVisitCheckBox#qGetSecondVisitedStudents.studentID#" value="#qGetSecondVisitedStudents.studentID#"></td>
                        <td>
                            <label for="secondVisitCheckBox#qGetSecondVisitedStudents.studentID#">
                                #qGetSecondVisitedStudents.studentID#
                            </label>
                        </td>
                        <td>
                            <label for="secondVisitCheckBox#qGetSecondVisitedStudents.studentID#">
                                #qGetSecondVisitedStudents.familyLastName#, #qGetSecondVisitedStudents.firstName#
                            </label>
                        </td>
                        <td>#qGetSecondVisitedStudents.programName#</td> 
                        <td><a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetSecondVisitedStudents.studentID#', 700, 500);" class="nav_bar">[ Payment History ]</a></td>  
                    </tr>
                </cfloop>
            <cfelse>
            	<tr bgcolor="##FFFFFF">
                	<td align="center">No second visit students found</td>
				</tr>                                
			</cfif>
        </table>
	
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr style="background-color:##E2EFC7;">
                <td colspan="5" align="center"><input name="submit" type="image" src="pics/next.gif" border="0" alt="search"></td>
            </tr>
		</table>
    </cfform>
    
</cfoutput>