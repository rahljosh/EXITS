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
		
		vSeasons = ('#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#,#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID+1#');
    </cfscript>
	    
    <cfquery name="qGetsupervisedPaymentType" datasource="#APPLICATION.DSN#">
        SELECT 
        	id, 
            type
        FROM 
        	smg_users_payments_type
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
        	( 
        		paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="Supervision">
            OR
            	paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            )
    </cfquery>
    
    <cfquery name="qGetPlacedPaymentType" datasource="#APPLICATION.DSN#">
        SELECT 
        	id, 
            type
        FROM 
        	smg_users_payments_type
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
        	( 
        		paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="Placement">
            OR
            	paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            )
    </cfquery>

    <cfquery name="qGetSecondVisitPaymentType" datasource="#APPLICATION.DSN#">
        SELECT 
        	id, 
            type
        FROM 
        	smg_users_payments_type
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
            paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisit">
    </cfquery>
	
	<cfquery name="qGetPrePlacementPaymentType" datasource="#APPLICATION.DSN#">
        SELECT 
        	id, 
            type
        FROM 
        	smg_users_payments_type
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
            paymentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="PrePlacement">
    </cfquery>

    <cfquery name="qGetRepInfo" datasource="#APPLICATION.DSN#">
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
    <cfquery name="qGetSupervisedStudents" datasource="#APPLICATION.DSN#">
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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
        WHERE 
        
		<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        </cfif>

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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
            INNER JOIN 
                smg_hosthistory h ON h.studentID = s.studentID
            WHERE 
                h.areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
             
			<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                AND
                	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                AND
                	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
            </cfif>
			
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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
            INNER JOIN
                smg_hosthistorytracking sht ON sht.studentID = s.studentID
                    AND
                        sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="areaRepID">
                    AND
                    	sht.fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
            WHERE 
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
    
            GROUP BY 
                studentID        
		</cfif>               
		<!--- End of Split Payments - Display All students pl --->
        
        ORDER BY
        	studentID DESC
    </cfquery>
    
    <!--- Get all students placed by selected rep --->
    <cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
        WHERE 
			<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
            </cfif>
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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
            INNER JOIN 
                smg_hosthistory h ON h.studentID = s.studentID
             WHERE 
                h.placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
			<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                AND
                	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                AND
                	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
            </cfif>
			
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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
            INNER JOIN
                smg_hosthistorytracking sht ON sht.studentID = s.studentID
                    AND
                        sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="placeRepID">
                    AND
                    	sht.fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
            WHERE 
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>

            GROUP BY 
                studentID   
        <cfelse>
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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
            INNER JOIN
                smg_hosthistorytracking sht ON sht.studentID = s.studentID
                    AND
                        sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="placeRepID">
                    AND
                    	sht.fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
            WHERE 
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>

            GROUP BY 
                studentID      
		</cfif>               
		<!--- End of Split Payments - Display All students pl --->
            
        ORDER BY 
        	studentID DESC
    </cfquery>

    <!--- Get all students visited by the by selected rep --->
    <cfquery name="qGetSecondVisitedStudents" datasource="#APPLICATION.DSN#">
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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
        WHERE 
			<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
            </cfif>
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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
            INNER JOIN 
                smg_hosthistory h ON h.studentID = s.studentID
             WHERE 
                h.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
			<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                AND
                	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                AND
                	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
            </cfif>
			
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
                	DATE_ADD(p.endDate, INTERVAL 9 MONTH) >= CURDATE()
            INNER JOIN
                smg_hosthistorytracking sht ON sht.studentID = s.studentID
                    AND
                        sht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisitRepID">
                    AND
                    	sht.fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
            WHERE 
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>

            GROUP BY 
                studentID        
		</cfif>               
		<!--- End of Split Payments - Display All students pl --->

        ORDER BY 
        	studentID DESC
    </cfquery>
	
	<cfquery name="qGetHostPlacements" datasource="#APPLICATION.DSN#">
		SELECT DISTINCT
			h.hostID,
			h.fatherFirstName,
			h.motherFirstName,
			h.familyLastName
		FROM smg_hosts h
		WHERE
			<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                h.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                h.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
            </cfif>
        AND h.areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
        ORDER BY hostID DESC
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
		
		<!--- Pre-placed hosts (only for ESI)--->
		<cfif CLIENT.companyID EQ 14>
	        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
	            <tr>
	                <td colspan="5" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Pre-Placed Hosts &nbsp; - &nbsp; Total of #qGetHostPlacements.recordcount# host(s) </td>
	            </tr>
	            <cfif qGetHostPlacements.recordCount>
	                <tr>
	                    <td colspan="5" style="font-weight:bold;">
	                        Please, select type of payment for the pre-placement hosts: 
	                        <cfselect name="prePlacementPaymentType" query="qGetPrePlacementPaymentType" value="id" display="type" queryPosition="below" class="xLargeField">
	                            <!--- <option value="">-- Select a Type --</option> --->
	                        </cfselect>
	                    </td>
	                </tr>
	                <tr style="background-color:##E2EFC7; font-weight:bold;">
	                    <td width="4%">&nbsp;</td>
	                    <td width="10%">ID</td>
	                    <td width="50%">Last Name, First Name(s)</td>
	                    <td width="36%">Actions</td>
	                </tr>
	                <cfloop query="qGetHostPlacements">
					
						<cfquery name="qGetPrePlacementPaymentsByHost" datasource="#APPLICATION.DSN#">
							SELECT *
							FROM smg_users_payments
							WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostPlacements.hostID#">
							AND agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
							AND isDeleted = 0
							AND paymentType = (SELECT id FROM smg_users_payments_type WHERE type = "Pre-Placement")
						</cfquery>
						<cfset paidProgramsList = ValueList(qGetPrePlacementPaymentsByHost.programID)>
						
	                    <tr bgcolor="###iif(qGetHostPlacements.currentrow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
	                        <td align="center"><input type="checkbox" name="hostPrePlacementsIDList" id="prePlacementCheckBox#qGetHostPlacements.hostID#" value="#qGetHostPlacements.hostID#"></td>
	                        <td>
	                            <label for="prePlacementCheckBox#qGetHostPlacements.hostID#">
	                                #qGetHostPlacements.hostID#
	                            </label>
	                        </td>
	                        <td>
	                            <label for="prePlacementCheckBox#qGetHostPlacements.hostID#">
	                                #qGetHostPlacements.familyLastName#, #qGetHostPlacements.fatherFirstName#
									<cfif LEN(qGetHostPlacements.fatherFirstName) AND LEN(qGetHostPlacements.motherFirstName)> & </cfif>
									#qGetHostPlacements.motherFirstName#
	                            </label>
	                        </td>
	                        <td><a href="javascript:openPopUp('userPayment/index.cfm?action=hostPaymentHistory&hostID=#qGetHostPlacements.hostID#', 700, 500);" class="nav_bar">[ Payment History ]</a></td>  
	                    </tr>
	                </cfloop>
	            <cfelse>
	            	<tr bgcolor="##FFFFFF">
	                	<td align="center">No pre-placement hosts found</td>
					</tr>                                
				</cfif>
	        </table>
	   	</cfif>
	
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr style="background-color:##E2EFC7;">
                <td colspan="5" align="center"><input name="submit" type="image" src="pics/next.gif" border="0" alt="search"></td>
            </tr>
		</table>
    </cfform>
    
</cfoutput>