<!--- ------------------------------------------------------------------------- ----
	
	File:		_processPayment.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Process Payment
	
	Update:		08/23/2011 - Adding second visit representative
				
				06/17/2011 - Blocking departure payments for ayp 5 month students	
		
				04/22/2011 - Pre AYP Bonus - Mutually Exclusive	
					18 - Pre-AYP-250
					19 - Pre-AYP-200
					20 - Pre-AYP-150
				
				04/21/2011 - Mutually Exclusive	Bonus
					17 - Fast Track Bonus - $1500 by April 15th
					15 - Early Placement  - #1000 April 16th to June 1st
					 9 - Paperwork Bonus  - $500 June 2nd to August 1st	
						
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param FORM variables --->

    <cfscript>
		// Mutually Exclusive Bonus
		vMutuallyExclusiveBonus = "9,15,17";
		// Mutually Exclusive PreAyp Bonus
		vMutuallyExclusivePreAyp = "18,19,20";
		
		// AYP 5 Program Type - Departure type must not be paid for 5 month students
		vAYP5ProgramType = "3,4,25,26";
		
		// Stores All Students Selected
		vStudentIDList = 0;
		
		if ( LEN(FORM.supervisedStudentIDList) ) {
			vStudentIDList = ListAppend(vStudentIDList, FORM.supervisedStudentIDList);
		}
		if ( LEN(FORM.placedStudentIDList) ) {
			vStudentIDList = ListAppend(vStudentIDList, FORM.placedStudentIDList);
		}

		if ( LEN(FORM.secondVisitStudentIDList) ) {
			vStudentIDList = ListAppend(vStudentIDList, FORM.secondVisitStudentIDList);
		}

		if ( LEN(URL.timeStamp) ) {
			URL.timeStamp = URLDecode(URL.timeStamp);
		}

		// Get Rep Information
		qGetRepInfo = APPLICATION.CFC.USER.getUserByID(userID=VAL(FORM.userID));
	</cfscript>
    
    <cfquery name="qGetsupervisedPaymentType" datasource="MySQL">
        SELECT 
            pt.type, 
            pt.id, 
            pa.amount
        FROM 
            smg_payment_types pt
        INNER JOIN 
            smg_payment_amount pa ON pt.id = pa.paymentid
        WHERE 
            pt.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.supervisedPaymentType)#">
        AND 
            pt.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>
    
    <cfquery name="qGetPlacementPaymentType" datasource="MySQL">
        SELECT 
            pt.type, 
            pt.id, 
            pa.amount
        FROM 
            smg_payment_types pt
        INNER JOIN 
            smg_payment_amount pa ON pt.id = pa.paymentid
        WHERE 
            pt.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.placedPaymentType)#"> 
        AND 
            pt.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>
	
    <cfquery name="qGetSecondVisitPaymentType" datasource="MySQL">
        SELECT 
            pt.type, 
            pt.id, 
            pa.amount
        FROM 
            smg_payment_types pt
        INNER JOIN 
            smg_payment_amount pa ON pt.id = pa.paymentid
        WHERE 
            pt.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.secondVisitPaymentType)#"> 
        AND 
            pt.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>
    
    <!--- Gets All Selected Students --->
    <cfquery name="qGetAllStudents" datasource="MySQL">
        SELECT 
            s.studentID, 
            s.firstName, 
            s.familyLastName, 
            p.programID,
            p.type
        FROM 
            smg_students s
        INNER JOIN
        	smg_programs p ON p.programID = s.programID
        WHERE 
            studentID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vStudentIDList#" list="yes"> )
        ORDER BY
        	studentID DESC
    </cfquery>

    <cfquery name="qGetSupervisedStudentList" dbtype="query">
        SELECT 
            studentID, 
            firstName, 
            familyLastName, 
            programID,
            type
        FROM 
            qGetAllStudents
        WHERE 
            studentID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.supervisedStudentIDList#" list="yes"> )
    </cfquery>

    <cfquery name="qGetPlacedStudentList" dbtype="query">
        SELECT 
            studentID, 
            firstName, 
            familyLastName, 
            programID,
            type
        FROM 
            qGetAllStudents
        WHERE 
            studentID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.placedStudentIDList#" list="yes"> )
    </cfquery>

    <cfquery name="qGetSecondVisitStudentList" dbtype="query">
        SELECT 
            studentID, 
            firstName, 
            familyLastName, 
            programID,
            type
        FROM 
            qGetAllStudents
        WHERE 
            studentID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.secondVisitStudentIDList#" list="yes"> )
    </cfquery>
	
    <!--- Get Recorded Payments --->
    <cfif IsDate(URL.timeStamp)>
    
		<!--- Get Super Payments Made --->
        <cfquery name="qGetSupervisedPaymentDetail" datasource="MySQL">
            SELECT
                srp.ID,
                srp.amount,
                srp.comment,
                spt.type,
                s.firstName,
                s.familyLastName,
                s.studentID
            FROM 
                smg_rep_payments srp
            LEFT OUTER JOIN
                smg_payment_types spt ON spt.ID = srp.paymentType
            LEFT OUTER JOIN
                smg_students s ON s.studentID = srp.studentID                                
            WHERE
               srp.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#"> 
            AND                
                srp.date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#URL.timeStamp#">
            AND
            	srp.transtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="Supervision">
        </cfquery>
        
		<!--- Get Place Payments Made --->
        <cfquery name="qGetPlacedPaymentDetail" datasource="MySQL">
            SELECT
                srp.ID,
                srp.amount,
                srp.comment,
                spt.type,
                s.firstName,
                s.familyLastName,
                s.studentID
            FROM 
                smg_rep_payments srp
            LEFT OUTER JOIN
                smg_payment_types spt ON spt.ID = srp.paymentType
            LEFT OUTER JOIN
                smg_students s ON s.studentID = srp.studentID                                
            WHERE
               srp.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#"> 
            AND    
                srp.date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#URL.timeStamp#">
            AND
            	srp.transtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="Placement">
        </cfquery>
        
		<!--- Get Second Visit Payments Made --->
        <cfquery name="qGetSecondVisitPaymentDetail" datasource="MySQL">
            SELECT
                srp.ID,
                srp.amount,
                srp.comment,
                spt.type,
                s.firstName,
                s.familyLastName,
                s.studentID
            FROM 
                smg_rep_payments srp
            LEFT OUTER JOIN
                smg_payment_types spt ON spt.ID = srp.paymentType
            LEFT OUTER JOIN
                smg_students s ON s.studentID = srp.studentID                                
            WHERE
               srp.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#"> 
            AND    
                srp.date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#URL.timeStamp#">
            AND
            	srp.transtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisit">
        </cfquery>        
	
    </cfif>
	
    <!--- FORM submitted --->
    <cfif FORM.submitted>

		<cfscript>
			vTimeStamp = now();
        </cfscript>
        
        <!--- Supervised Payments --->
        <cfif VAL(FORM.supervisedStudentIDList)>
        
            <cfloop list="#FORM.supervisedStudentIDList#" index="studentID">
                
                <cfif LEN(Evaluate("FORM." & studentID & "superPaymentTypeID"))>
                
                    <cfquery datasource="MySQL" result="newRecord">
                        INSERT INTO 
                            smg_rep_payments
                        (
                            agentid, 
                            studentID, 
                            programID, 
                            paymenttype, 
                            date, 
                            transtype, 
                            inputby, 
                            amount, 
                            companyID, 
                            comment
                        )
                        VALUES 
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & studentID & 'superProgramID')#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & studentID & 'superPaymentTypeID')#">, 
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vTimeStamp#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="supervision">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & studentID & 'superAmount')#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & studentID & 'superComment')#">
                        )
                    </cfquery>
                
                </cfif>	
                
            </cfloop>
		
        </cfif>

        <!--- Placed Payments --->
        <cfif VAL(FORM.placedStudentIDList)>
        
            <cfloop list="#FORM.placedStudentIDList#" index="studentID">
            
                <cfif LEN(Evaluate("FORM." & studentID & "placePaymentTypeID"))>
                
                    <cfquery datasource="MySQL" result="newRecord">
                        INSERT INTO 
                            smg_rep_payments
                        (
                            agentid, 
                            studentID, 
                            programID, 
                            paymenttype, 
                            date, 
                            transtype, 
                            inputby, 
                            amount, 
                            companyID, 
                            comment
                        )
                        VALUES 
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & studentID & 'placeProgramID')#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & studentID & 'placePaymentTypeID')#">, 
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vTimeStamp#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="placement">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & studentID & 'placeAmount')#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & studentID & 'placeComment')#">
                        )
                    </cfquery>
                    
                </cfif>
                
            </cfloop>
		
        </cfif>
        
        <!--- Second Visit Payments --->
        <cfif VAL(FORM.secondVisitStudentIDList)>
        
            <cfloop list="#FORM.secondVisitStudentIDList#" index="studentID">
            		
                <cfif LEN(Evaluate("FORM." & studentID & "secondVisitPaymentTypeID"))>
                	
                    <cfquery datasource="MySQL" result="newRecord">
                        INSERT INTO 
                            smg_rep_payments
                        (
                            agentid, 
                            studentID, 
                            programID, 
                            paymenttype, 
                            date, 
                            transtype, 
                            inputby, 
                            amount, 
                            companyID, 
                            comment
                        )
                        VALUES 
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & studentID & 'secondVisitProgramID')#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & studentID & 'secondVisitPaymentTypeID')#">, 
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vTimeStamp#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisit">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & studentID & 'secondVisitAmount')#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & studentID & 'secondVisitComment')#">
                        )
                    </cfquery>
                
                </cfif>
                
            </cfloop>
		
        </cfif>
        
        <!--- Location --->
        <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment&userID=#FORM.userID#&timeStamp=#URLEncodedFormat(vTimeStamp)#" addtoken="no">
            
    </cfif>
    
</cfsilent>

<cfoutput>

    <h2 style="margin-top:10px;">
        Representative: #qGetRepInfo.firstName# #qGetRepInfo.lastname# (###qGetRepInfo.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
        <a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetRepInfo.userid#', 700, 500);" class="nav_bar">Payment History</a>
    </h2>
    
	<!--- Display Payment Confirmation --->
    <cfif IsDate(URL.timeStamp)>

        <div style="margin-top:10px;">Below is a summary of the recorded payments:</div>

        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
            <tr>
                <td colspan="4" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Supervised Students</td>
                <td style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                    Total of #qGetSupervisedPaymentDetail.recordCount# student(s)
                </td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="10%">Payment ID</td>
                <td width="20%">Student</td>
                <td width="20%">Type</td>
                <td width="10%">Amount</td>
                <td width="40%">Comment</td>
            </tr>

            <cfloop query="qGetSupervisedPaymentDetail">

                <tr bgcolor="###iif(qGetSupervisedPaymentDetail.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <Td>###qGetSupervisedPaymentDetail.ID#</Td>
                    <td>#qGetSupervisedPaymentDetail.firstName# #qGetSupervisedPaymentDetail.familyLastName# (###qGetSupervisedPaymentDetail.studentID#)</td>
                    <Td>#qGetSupervisedPaymentDetail.type#</Td>  
                    <td>#LSCurrencyFormat(qGetSupervisedPaymentDetail.amount, 'local')#</td>
                    <td>#qGetSupervisedPaymentDetail.comment#</td>
                </tr>
         
            </cfloop>
    
            <cfif NOT VAL(qGetSupervisedPaymentDetail.recordCount)>
                <tr><td colspan="5" align="center">No supervision payments submitted.</td></tr>
            </cfif>
        
		</table>
            
		<!--- PLACED STUDENTS --->
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr>
                <td colspan="4" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Placed Students</td>
                <td style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                    Total of #qGetPlacedPaymentDetail.recordCount# student(s)
                </td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="10%">Payment ID</td>
                <td width="20%">Student</td>
                <td width="20%">Type</td>
                <td width="10%">Amount</td>
                <td width="40%">Comment</td>
            </tr>

            <cfloop query="qGetPlacedPaymentDetail">
                
                <tr bgcolor="###iif(qGetPlacedPaymentDetail.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <Td>###qGetPlacedPaymentDetail.ID#</Td>
                    <td>#qGetPlacedPaymentDetail.firstName# #qGetPlacedPaymentDetail.familyLastName# (###qGetPlacedPaymentDetail.studentID#)</td>
                    <Td>#qGetPlacedPaymentDetail.type#</Td>  
                    <td>#LSCurrencyFormat(qGetPlacedPaymentDetail.amount, 'local')#</td>
                    <td>#qGetPlacedPaymentDetail.comment#</td>
                </tr>
                
            </cfloop>
            
            <cfif NOT VAL(qGetPlacedPaymentDetail.recordCount)>
                <tr><td colspan="5" align="center">No placement payments submitted.</td></tr>
            </cfif>

        </table>
        
		<!--- SECOND VISIT STUDENTS --->
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr>
                <td colspan="4" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Second Visit Students</td>
                <td style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                    Total of #qGetSecondVisitPaymentDetail.recordCount# student(s)
                </td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="10%">Payment ID</td>
                <td width="20%">Student</td>
                <td width="20%">Type</td>
                <td width="10%">Amount</td>
                <td width="40%">Comment</td>
            </tr>

            <cfloop query="qGetSecondVisitPaymentDetail">
                
                <tr bgcolor="###iif(qGetSecondVisitPaymentDetail.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <Td>###qGetSecondVisitPaymentDetail.ID#</Td>
                    <td>#qGetSecondVisitPaymentDetail.firstName# #qGetSecondVisitPaymentDetail.familyLastName# (###qGetSecondVisitPaymentDetail.studentID#)</td>
                    <Td>#qGetSecondVisitPaymentDetail.type#</Td>  
                    <td>#LSCurrencyFormat(qGetSecondVisitPaymentDetail.amount, 'local')#</td>
                    <td>#qGetSecondVisitPaymentDetail.comment#</td>
                </tr>
                
            </cfloop>
            
            <cfif NOT VAL(qGetSecondVisitPaymentDetail.recordCount)>
                <tr><td colspan="5" align="center">No second visit payments submitted.</td></tr>
            </cfif>

        </table>

        <br />

        <div align="center"><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index"><img src="pics/newpayment.gif" border="0" align="bottom"></a></div>

    <!--- Display FORM --->
    <cfelse>

        <div style="margin-top:10px;">Fill in the details for each student, all fields are optional.</div>
        
        <cfform name="payments" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment" method="post">
            <input type="hidden" name="submitted" value="1" />
            <input type="hidden" name="userID" value="#FORM.userID#">
            <input type="hidden" name="supervisedStudentIDList" value="#FORM.supervisedStudentIDList#">
            <input type="hidden" name="placedStudentIDList" value="#FORM.placedStudentIDList#">
            <input type="hidden" name="secondVisitStudentIDList" value="#FORM.secondVisitStudentIDList#">
        	
            <!---- SUPERVISED STUDENTS ---->
            <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
                <tr>
                    <td colspan="4" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">
                    	Supervised Students 
                        &nbsp; - &nbsp;
                    	Payment Type: <cfif LEN(qGetsupervisedPaymentType.type)>#qGetsupervisedPaymentType.type#<cfelse>n/a</cfif>
                    </td>
                    <td style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                    	Total of #qGetSupervisedStudentList.recordCount# student(s)
                    </td>
                </tr>
                <tr style="background-color:##E2EFC7; font-weight:bold;">
                    <td width="10%">ID</td>
                    <td width="20%">Student</td>
                    <td width="15%">Type</td>
                    <td width="10%">Amount</td>
                    <td width="45%">Comment</td>
				</tr>

                <cfloop query="qGetSupervisedStudentList">

                    <cfquery name="qCheckSupervisedCharges" datasource="MySQL">
                        SELECT 
                            rep.date,
                            rep.amount,
                            spt.type,
                            p.programName,
                            u.firstName, 
                            u.lastname
                        FROM 
                            smg_rep_payments rep
                        INNER JOIN 
                            smg_payment_types spt ON rep.paymenttype = spt.id
                        LEFT JOIN 
                            smg_programs p ON rep.programID = p.programID
                        LEFT JOIN 
                            smg_users u ON rep.agentid = u.userid
                        WHERE 
                            rep.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetSupervisedStudentList.studentID#">
                        AND 
                            spt.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.supervisedPaymentType)#"> 
                        <!--- Do Not Include Club Leadership / It's not exclusive --->
                        AND 
                            spt.id != <cfqueryparam cfsqltype="cf_sql_integer" value="10"> 	
                        ORDER BY
                        	rep.date DESC	
                    </cfquery>
                    
                    <cfscript>
						// Check if payment is allowed
						vAllowSuperPayment = 0;
						
						if ( FORM.supervisedPaymentType EQ 12 AND ListFind(vAYP5ProgramType, qGetSupervisedStudentList.type) ) {
							// Departure Payment Type - AYP 5 Month Not Allowed
							vAllowSuperPayment = 0;
						} else if ( VAL(FORM.isSplitPayment) ) {
							// Split Payment - Allow
							vAllowSuperPayment = 1;
						} else if ( NOT VAL(qCheckSupervisedCharges.recordcount) ) {
							// Charge not paid - Allow
							vAllowSuperPayment = 1;
						}

						// Split Payments - No Default value
						if ( FORM.isSplitPayment ) {
							vPlaceAmoutToBePaid = '';
							// vPlaceAmoutToBePaid = DecimalFormat(VAL(qGetsupervisedPaymentType.amount) / 2);	
						} else { 
							vPlaceAmoutToBePaid = qGetsupervisedPaymentType.amount;
						}						
					</cfscript>
                    
                    <tr bgcolor="###iif(qGetSupervisedStudentList.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                        <input type="hidden" name="#qGetSupervisedStudentList.studentID#superProgramID" value="#qGetSupervisedStudentList.programID#">
                        <Td valign="top">
                            <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetSupervisedStudentList.studentID#', 700, 500);" class="nav_bar">
                                #qGetSupervisedStudentList.studentID#
                            </a>
                        </Td>
                        <td valign="top">
                            <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetSupervisedStudentList.studentID#', 700, 500);" class="nav_bar">
                                #qGetSupervisedStudentList.firstName# #qGetSupervisedStudentList.familyLastName#
                            </a>
                        </td>
                        
                        <cfif vAllowSuperPayment>
                        
                            <td valign="top">
                                <select name="#qGetSupervisedStudentList.studentID#superPaymentTypeID" class="xLargeField">
                                    <option value="#qGetsupervisedPaymentType.id#">#qGetsupervisedPaymentType.type#</option>
                                </select>
                            </td>
                            <td valign="top">
                            	<cfinput type="text" name="#qGetSupervisedStudentList.studentID#superAmount" value="#vPlaceAmoutToBePaid#" class="smallField" required="yes" message="Oops! You forgot to enter the amount for student #qGetSupervisedStudentList.studentID#.">
                            </td>
                            <td valign="top" style="color:##F00">
                                <input type="text" name="#qGetSupervisedStudentList.studentID#superComment" class="xLargeField">
                            </td>
							<!--- Display Previous Payment Information --->
                            <cfloop query="qCheckSupervisedCharges">
                                <p>
                                    #qCheckSupervisedCharges.type# paid on #DateFormat(qCheckSupervisedCharges.date, 'mm/dd/yyyy')# <br />
                                    - Program: #qCheckSupervisedCharges.programName# <br />
                                    - Rep: #qCheckSupervisedCharges.firstName# #qCheckSupervisedCharges.lastname# <br />
                                    - Total Paid: #DollarFormat(qCheckSupervisedCharges.amount)# 
                                </p>
							</cfloop>
                        
						<cfelse>
                        
                            <!--- Block Payment --->
                            <td valign="top">
                                <input type="hidden" name="#qGetSupervisedStudentList.studentID#superPaymentTypeID" value="">
                                n/a
                            </td>
                            <td valign="top">n/a</td>
                            <td valign="top"style="color:##F00">
                                <cfif FORM.supervisedPaymentType EQ 12 AND ListFind(vAYP5ProgramType, qGetSupervisedStudentList.type)>
                                    AYP 5 month programs are not eligible for #qGetsupervisedPaymentType.type# payment.
                                <cfelse>
                                    <cfloop query="qCheckSupervisedCharges">
                                        <p>
                                            #qCheckSupervisedCharges.type# paid on #DateFormat(qCheckSupervisedCharges.date, 'mm/dd/yyyy')# <br />
                                            - Program: #qCheckSupervisedCharges.programName# <br />
                                            - Rep: #qCheckSupervisedCharges.firstName# #qCheckSupervisedCharges.lastname# <br />
                                            - Total Paid: #DollarFormat(qCheckSupervisedCharges.amount)# 
                                        </p>
                                    </cfloop>
                                </cfif>
                            </td>
                            
                        </cfif>
                    </tr>
                       
                </cfloop>
				
				<cfif NOT VAL(qGetSupervisedStudentList.recordCount)>
                    <tr><td colspan="5" align="center">No students selected.</td></tr>
                </cfif>
                
            </table>
            
            <!--- PLACED STUDENTS --->
            <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
                <tr>
                    <td colspan="4" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">
                    	Placed Students 
                        &nbsp; - &nbsp; 
                        Payment Type: <cfif LEN(qGetPlacementPaymentType.type)>#qGetPlacementPaymentType.type#<cfelse>n/a</cfif>
                    </td>
                    <td style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                    	Total of #qGetPlacedStudentList.recordCount# student(s)
                    </td>
                </tr>
                <tr style="background-color:##E2EFC7; font-weight:bold;">
                    <td width="10%">ID</td>
                    <td width="20%">Student</td>
                    <td width="15%">Type</td>
                    <td width="10%">Amount</td>
                    <td width="45%">Comment</td>
				</tr>

                <cfloop query="qGetPlacedStudentList">
					
                    <cfquery name="qCheckPlacedCharges" datasource="MySQL">
                        SELECT                                 
                            rep.paymenttype,
                            rep.date,
                            rep.amount,
                            spt.type,
                            p.programName,
                            u.firstName, 
                            u.lastname
                        FROM 
                            smg_rep_payments rep
                        INNER JOIN 
                            smg_payment_types spt ON rep.paymenttype = spt.id
                        LEFT JOIN 
                            smg_programs p ON rep.programID = p.programID
                        LEFT JOIN 
                            smg_users u ON rep.agentid = u.userid
                        WHERE 
                            rep.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPlacedStudentList.studentID#"> 
                        
                        <!--- 
							These are mutually exclusive. Only one per student
							17 - Fast Track Bonus / 15 - Early Placement / 9 - Paperwork Bonus 
						--->
                        <cfif ListFind(vMutuallyExclusiveBonus, VAL(FORM.placedPaymentType) )>
                            AND 
                                spt.id IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vMutuallyExclusiveBonus#" list="yes"> )
                        <!--- 
							These are mutually exclusive. Only one per student
							18 - Pre-AYP-250 / 19 - Pre-AYP-200 / 20 - Pre-AYP-150 
						--->
                        <cfelseif ListFind(vMutuallyExclusivePreAyp, VAL(FORM.placedPaymentType) )>
                            AND 
                                spt.id IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vMutuallyExclusivePreAyp#" list="yes"> )
                        <cfelse>
                            AND 
                                spt.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.placedPaymentType)#">
                        </cfif>                         

                        <!--- Do Not Include Club Leadership / It's not exclusive --->
                        AND 
                            spt.id != <cfqueryparam cfsqltype="cf_sql_integer" value="10"> 	
                        ORDER BY
                        	rep.date DESC	
                    </cfquery>

                    <cfscript>
						// Check if paperwork was received for Fast Start, Early Placement, Paperwork Bonus
						vCheckPlacementPaperwork = APPLICATION.CFC.STUDENT.checkPlacementPaperwork(studentID=qGetPlacedStudentList.studentID, paymentTypeID=qGetPlacementPaymentType.id);
					
						// Check if payment is allowed
						vAllowPlacePayment = 0;
						
						if ( FORM.placedPaymentType EQ 12 AND ListFind(vAYP5ProgramType, qGetPlacedStudentList.type) ) {
							// Departure Payment Type - AYP 5 Month Not Allowed
							vAllowPlacePayment = 0;
						} else if ( VAL(FORM.isSplitPayment) ) {
							// Split Payment - Allow
							vAllowPlacePayment = 1;
						} else if ( NOT VAL(qCheckPlacedCharges.recordcount) ) {
							// Charge not paid - Allow
							vAllowPlacePayment = 1;
						}

						// Split Payments - No Default value
						if ( FORM.isSplitPayment ) {
							vPlaceAmoutToBePaid = '';
							// vPlaceAmoutToBePaid = VAL(qGetPlacementPaymentType.amount) / 2;	
						} else { 
							vPlaceAmoutToBePaid = qGetPlacementPaymentType.amount;
						}
					</cfscript>
                    
                    <tr bgcolor="###iif(qGetPlacedStudentList.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                        <input type="hidden" name="#qGetPlacedStudentList.studentID#placeProgramID" value="#qGetPlacedStudentList.programID#">
                        <Td valign="top">
                            <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetPlacedStudentList.studentID#', 700, 500);" class="nav_bar">
                                #qGetPlacedStudentList.studentID#
                            </a>
                        </Td>
                        <td valign="top">
                            <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetPlacedStudentList.studentID#', 700, 500);" class="nav_bar">
                                #qGetPlacedStudentList.firstName# #qGetPlacedStudentList.familyLastName#
                            </a>
                        </td>
                        
                        <cfif vAllowPlacePayment>
                        
                            <td valign="top">
                                <select name="#qGetPlacedStudentList.studentID#placePaymentTypeID" class="xLargeField">
                                    <option value="#qGetPlacementPaymentType.id#">#qGetPlacementPaymentType.type#</option>
                                </select>
                            </td>
                            <td valign="top">
                                <cfinput type="text" name="#qGetPlacedStudentList.studentID#placeAmount" class="smallField" value="#vPlaceAmoutToBePaid#" required="yes" message="Oops! You forgot to enter the amount for student #qGetPlacedStudentList.studentID#.">
                            </td>
                            <td valign="top" style="color:##F00">
                                <input type="text" name="#qGetPlacedStudentList.studentID#placeComment" class="xLargeField">
								
                                <!--- Placement Paperwork Alert --->
                                <cfif LEN(vCheckPlacementPaperwork)>
                                    <p style="color:##F00; margin:5px 0px 5px 0px;">
                                        Placement Paperwork needing attention: <br />
                                    </p>
                                    #vCheckPlacementPaperwork#
                                </cfif>
                                
                                <!--- Display Previous Payment Information --->
                                <cfloop query="qCheckPlacedCharges">
                                    <p>
                                        #qCheckPlacedCharges.type# paid on #DateFormat(qCheckPlacedCharges.date, 'mm/dd/yyyy')# <br />
                                        - Program #qCheckPlacedCharges.programName# <br />
                                        - Rep: #qCheckPlacedCharges.firstName# #qCheckPlacedCharges.lastname# <br />
                                        - Total Paid: #DollarFormat(qCheckPlacedCharges.amount)#
                                    </p>
								</cfloop>                               
                            </td>
                            
                        <cfelse>
                        
                            <!--- Block Payment --->
                            <td valign="top">
                                <cfinput type="hidden" name="#qGetPlacedStudentList.studentID#placePaymentTypeID" value="">
                                n/a
                            </td>
                            <td valign="top">n/a</td>
                            <td valign="top" style="color:##F00">
                                <cfif FORM.placedPaymentType EQ 12 AND ListFind(vAYP5ProgramType, qGetPlacedStudentList.type)>
                                    AYP 5 month programs are not eligible for #qGetsupervisedPaymentType.type# payment.
                                <cfelse>
                                    <cfloop query="qCheckPlacedCharges">
                                        <p>
                                            #qCheckPlacedCharges.type# paid on #DateFormat(qCheckPlacedCharges.date, 'mm/dd/yyyy')# <br />
                                            - Program #qCheckPlacedCharges.programName# <br />
                                            - Rep: #qCheckPlacedCharges.firstName# #qCheckPlacedCharges.lastname# <br />
                                            - Total Paid: #DollarFormat(qCheckPlacedCharges.amount)#
                                        </p>
                                    </cfloop>                               
                                </cfif>
                            </td>
                            
                        </cfif>
                    </tr>
                        
                </cfloop>

				<cfif NOT VAL(qGetPlacedStudentList.recordCount)>
                    <tr><td colspan="5" align="center">No students selected.</td></tr>
                </cfif>
            </table>

            <!--- SECOND VISIT --->
            <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
                <tr>
                    <td colspan="4" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">
                    	Second Visit Students 
                        &nbsp; - &nbsp; 
                        Payment Type: <cfif LEN(qGetSecondVisitPaymentType.type)>#qGetSecondVisitPaymentType.type#<cfelse>n/a</cfif>
                    </td>
                    <td style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                    	Total of #qGetSecondVisitStudentList.recordCount# student(s)
                    </td>                
                </tr>
                <tr style="background-color:##E2EFC7; font-weight:bold;">
                    <td width="10%">ID</td>
                    <td width="20%">Student</td>
                    <td width="15%">Type</td>
                    <td width="10%">Amount</td>
                    <td width="45%">Comment</td>
				</tr>

                <cfloop query="qGetSecondVisitStudentList">
					
                    <cfquery name="qCheckSecondVisitCharges" datasource="MySQL">
                        SELECT                                 
                            rep.paymenttype,
                            rep.date,
                            rep.amount,
                            spt.type,
                            p.programName,
                            u.firstName, 
                            u.lastname
                        FROM 
                            smg_rep_payments rep
                        INNER JOIN 
                            smg_payment_types spt ON rep.paymenttype = spt.id
                        LEFT JOIN 
                            smg_programs p ON rep.programID = p.programID
                        LEFT JOIN 
                            smg_users u ON rep.agentid = u.userid
                        WHERE 
                            rep.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetSecondVisitStudentList.studentID#"> 
                        AND 
                            spt.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.secondVisitPaymentType)#">
                        ORDER BY
                        	rep.date DESC	
                    </cfquery>

                    <cfscript>
						// Check if payment is allowed
						vAllowSecondVisitPayment = 0;
						
						if ( VAL(FORM.isSplitPayment) ) {
							// Split Payment - Allow
							vAllowSecondVisitPayment = 1;
						} else if ( NOT VAL(qCheckSecondVisitCharges.recordcount) ) {
							// Charge not paid - Allow
							vAllowSecondVisitPayment = 1;
						}

						// Split Payments - No Default value
						if ( FORM.isSplitPayment ) {
							vSecondVisitAmoutToBePaid = '';
							// vSecondVisitAmoutToBePaid = VAL(qGetSecondVisitPaymentType.amount) / 2;	
						} else { 
							vSecondVisitAmoutToBePaid = qGetSecondVisitPaymentType.amount;
						}
					</cfscript>
                    
                    <tr bgcolor="###iif(qGetSecondVisitStudentList.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                        <input type="hidden" name="#qGetSecondVisitStudentList.studentID#SecondVisitProgramID" value="#qGetSecondVisitStudentList.programID#">
                        <Td valign="top">
                            <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetSecondVisitStudentList.studentID#', 700, 500);" class="nav_bar">
                                #qGetSecondVisitStudentList.studentID#
                            </a>
                        </Td>
                        <td valign="top">
                            <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#qGetSecondVisitStudentList.studentID#', 700, 500);" class="nav_bar">
                                #qGetSecondVisitStudentList.firstName# #qGetSecondVisitStudentList.familyLastName#
                            </a>
                        </td>
                        
                        <cfif vAllowSecondVisitPayment>
                        
                            <td valign="top">
                                <select name="#qGetSecondVisitStudentList.studentID#SecondVisitPaymentTypeID" class="xLargeField">
                                    <option value="#qGetSecondVisitPaymentType.id#">#qGetSecondVisitPaymentType.type#</option>
                                </select>
                            </td>
                            <td valign="top">
                                <cfinput type="text" name="#qGetSecondVisitStudentList.studentID#SecondVisitAmount" class="smallField" value="#vSecondVisitAmoutToBePaid#" required="yes" message="Oops! You forgot to enter the amount for student #qGetSecondVisitStudentList.studentID#.">
                            </td>
                            <td valign="top" style="color:##F00">
                                <input type="text" name="#qGetSecondVisitStudentList.studentID#SecondVisitComment" class="xLargeField">
								
                                <!--- Display Previous Payment Information --->
                                <cfloop query="qCheckSecondVisitCharges">
                                    <p>
                                        #qCheckSecondVisitCharges.type# paid on #DateFormat(qCheckSecondVisitCharges.date, 'mm/dd/yyyy')# <br />
                                        - Program #qCheckSecondVisitCharges.programName# <br />
                                        - Rep: #qCheckSecondVisitCharges.firstName# #qCheckSecondVisitCharges.lastname# <br />
                                        - Total Paid: #DollarFormat(qCheckSecondVisitCharges.amount)#
                                    </p>
								</cfloop>                               
                            </td>
                            
                        <cfelse>
                        
                            <!--- Block Payment --->
                            <td valign="top">
                                <cfinput type="hidden" name="#qGetSecondVisitStudentList.studentID#SecondVisitPaymentTypeID" value="">
                                n/a
                            </td>
                            <td valign="top">n/a</td>
                            <td valign="top" style="color:##F00">
                                <cfif FORM.secondVisitPaymentType EQ 12 AND ListFind(vAYP5ProgramType, qGetSecondVisitStudentList.type)>
                                    AYP 5 month programs are not eligible for #qGetsupervisedPaymentType.type# payment.
                                <cfelse>
                                    <cfloop query="qCheckSecondVisitCharges">
                                        <p>
                                            #qCheckSecondVisitCharges.type# paid on #DateFormat(qCheckSecondVisitCharges.date, 'mm/dd/yyyy')# <br />
                                            - Program #qCheckSecondVisitCharges.programName# <br />
                                            - Rep: #qCheckSecondVisitCharges.firstName# #qCheckSecondVisitCharges.lastname# <br />
                                            - Total Paid: #DollarFormat(qCheckSecondVisitCharges.amount)#
                                        </p>
                                    </cfloop>                               
                                </cfif>
                            </td>
                            
                        </cfif>
                    </tr>
                        
                </cfloop>

				<cfif NOT VAL(qGetSecondVisitStudentList.recordCount)>
                    <tr><td colspan="5" align="center">No students selected.</td></tr>
                </cfif>
            </table>

			<!--- Submit Button --->
            <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
                <tr style="background-color:##E2EFC7;">
                    <td colspan="5" align="center"> <input name="submit" type="image" src="pics/submit.gif" border="0" alt="submit"></td>
                </tr>
			</table>
   		</cfform>

	</cfif>

</cfoutput>