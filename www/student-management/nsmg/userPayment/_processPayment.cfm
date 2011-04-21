<!--- ------------------------------------------------------------------------- ----
	
	File:		_processPayment.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Process Payment
	
	Update:		04/21/2011 - Mutually Exclusive	Bonus
				17 - Fast Track Bonus - $1500 by April 15th
				15 - Early Placement  - #1000 April 16th to June 1st
				 9 - Paperwork Bonus  - $500 June 2nd to August 1st			
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param FORM variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.user" default="0">
    <cfparam name="FORM.payment_type_super" default="0">
    <cfparam name="FORM.payment_type_place" default="0">
    <cfparam name="FORM.supervisedStudentIDList" default="">
    <cfparam name="FORM.placedStudentIDList" default="">

	<!--- Stores a list of payments recently made --->
    <cfparam name="supervisedPaymentList" default="">
    <cfparam name="placedPaymentList" default="">

    <cfscript>
		// Mutually Exclusive Bonus
		mutuallyExclusiveBonus = "9,15,17";

		// Get Rep Information
		qGetRepInfo = APPCFC.USER.getUserByID(userID=VAL(user));
		
		// Stores All Students Selected
		studentIDList = 0;
		if ( LEN(supervisedStudentIDList) ) {
			studentIDList = ListAppend(studentIDList, supervisedStudentIDList);
		}
		if ( LEN(placedStudentIDList) ) {
			studentIDList = ListAppend(studentIDList, placedStudentIDList);
		}
	</cfscript>
    
    <cfquery name="qGetSupervisingPaymentType" datasource="MySQL">
        SELECT 
            smg_payment_types.type, smg_payment_types.id, amount
        FROM 
            smg_payment_types
        INNER JOIN 
            smg_payment_amount ON smg_payment_types.id = smg_payment_amount.paymentid
        WHERE 
            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.payment_type_super)#">
        AND 
            smg_payment_types.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>
    
    <cfquery name="qGetPlacementPaymentType" datasource="MySQL">
        SELECT 
            smg_payment_types.type, smg_payment_types.id, amount
        FROM 
            smg_payment_types 
        INNER JOIN 
            smg_payment_amount ON smg_payment_types.id = smg_payment_amount.paymentid
        WHERE 
            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.payment_type_place)#"> 
        AND 
            smg_payment_types.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>
	
    <!--- Gets All Selected Students --->
    <cfquery name="qGetAllStudents" datasource="MySQL">
        SELECT 
            studentid, 
            firstname, 
            familylastname, 
            programid
        FROM 
            smg_students
        WHERE 
            studentid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#studentIDList#" list="yes"> )
    </cfquery>

    <!--- FORM submitted --->
    <cfif FORM.submitted>
    	
		<cfscript>
            // These are used in the Insert
            supervisedPaymentList = '';
            placedPaymentList = '';
        </cfscript>
        
        <!--- Supervised --->
        <cfif LEN(FORM.supervisedStudentIDList)>
        
            <cfloop list="#FORM.supervisedStudentIDList#" index="x">
            
                <cfif LEN(Evaluate("FORM." & x & "super_type"))>
                
                    <cftransaction action="begin" isolation="serializable">
                        
                        <cfquery name="qGetStudentProgram" datasource="MySQL">
                            SELECT
                                 programid
                            FROM
                            	smg_students
                            WHERE 
                            	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                        </cfquery>
                        
                        <cfquery datasource="MySQL" result="newRecord">
                            INSERT INTO 
                            	smg_rep_payments
                            (
                            	agentid, 
                                studentid, 
                                programid, 
                                paymenttype, 
                                date, 
                                transtype, 
                                inputby, 
                                amount, 
                                companyid, 
                                comment
                            )
                            VALUES 
                            (
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.user#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentProgram.programid#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & 'super_type')#">, 
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & x & 'super_transtype')#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & x & 'super_amount')#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & x & 'super_comment')#">
							)
                        </cfquery>
                        
                    </cftransaction>
                    
                    <cfset supervisedPaymentList = ListAppend(supervisedPaymentList, newRecord.GENERATED_KEY)>
                
				</cfif>	
                
            </cfloop>
            
        </cfif>
        
        <!--- Placed --->
        <cfif LEN(FORM.placedStudentIDList)>
           
            <cfloop list="#FORM.placedStudentIDList#" index="x">
            
                <cfif #Evaluate("FORM." & x & "place_type")# NEQ ''>
                
                    <cftransaction action="begin" isolation="serializable">
                    
                        <cfquery name="qGetStudentProgram" datasource="MySQL">
                            SELECT
                                 programid
                            FROM
                            	smg_students
                            WHERE 
                            	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                        </cfquery>
                        
                        <cfquery datasource="MySQL" result="newRecord">
                            INSERT INTO 
                            	smg_rep_payments
                            (
                            	agentid, 
                                studentid, 
                                programid, 
                                paymenttype, 
                                date, 
                                transtype, 
                                inputby, 
                                amount, 
                                companyid, 
                                comment
                            )
                            VALUES 
                            (
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.user#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentProgram.programid#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & 'place_type')#">, 
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & x & 'place_transtype')#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & x & 'place_amount')#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.' & x & 'place_comment')#">
							)
                        </cfquery>
                        
                    </cftransaction>
                    
                    <cfset placedPaymentList = ListAppend(placedPaymentList, newRecord.GENERATED_KEY)>
                    
                </cfif>
                
            </cfloop>
            
        </cfif>
		
        <!--- Location --->
        <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment&user=#FORM.user#&placedPaymentList=#placedPaymentList#&supervisedPaymentList=#supervisedPaymentList#" addtoken="no">

    </cfif>
    
</cfsilent>

<cfoutput>

    <h2>
    	Representative: #qGetRepInfo.firstname# #qGetRepInfo.lastname# (#qGetRepInfo.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
        <a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetRepInfo.userid#', 700, 500);" class="nav_bar">Payment History</a>
	</h2> <br />
    
	<!--- Display Payment Confirmation --->
    <cfif LEN(supervisedPaymentList) OR LEN(placedPaymentList)>

        Below is a summary of the payments recorded. <br />
        
        <table width="90%" cellpadding="4" cellspacing="0">
            <!--- Supervised Payments --->
            <tr>
                <td bgcolor="##010066" colspan="5"><font color="white"><strong>Supervised Students </strong></font></td>
            </tr>
            <tr bgcolor="##CCCCCC">
                <Td>ID</Td>
                <td>Student</td>
                <td>Type</td>
                <td>Amount</td>
                <td>Comment</td>
            </tr>

            <cfloop list="#URL.supervisedPaymentList#" index = "x">
            
                <Cfquery name="qGetPaymentDetail" datasource="MySQL">
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
                        srp.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                </Cfquery>

                <tr>
                    <Td>#qGetPaymentDetail.ID#</Td>
                    <td>#qGetPaymentDetail.firstname# #qGetPaymentDetail.familylastname# (###qGetPaymentDetail.studentid#)</td>
                    <Td>#qGetPaymentDetail.type#</Td>  
                    <td>#LSCurrencyFormat(qGetPaymentDetail.amount, 'local')#</td>
                    <td>#qGetPaymentDetail.comment#</td>
                </tr>
         
            </cfloop>
    
            <Cfif NOT LEN(form.supervisedStudentIDList)>
                <tr><td colspan="5" align="center">No supervision payments submitted.</td></tr>
            </cfif>
        
            <tr><td>&nbsp;</td></tr>
        	
            <!--- Placed Payments --->
            <tr>
                <td bgcolor="##010066" colspan="5"><font color="white"><strong>Placed Students</strong></font></td>
            </tr>
            <tr bgcolor="##CCCCCC">
                <Td>Payment ID</Td><td>Student</td><td>Type</td><td>Amount</td><td>Comment</td>
            </tr>

            <cfloop list="#URL.placedPaymentList#" index = "x">
            
                <Cfquery name="qGetPaymentDetail" datasource="MySQL">
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
                        srp.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                </Cfquery>
                
                <tr>
                    <Td>#qGetPaymentDetail.ID#</Td>
                    <td>#qGetPaymentDetail.firstname# #qGetPaymentDetail.familylastname# (###qGetPaymentDetail.studentid#)</td>
                    <Td>#qGetPaymentDetail.type#</Td>  
                    <td>#LSCurrencyFormat(qGetPaymentDetail.amount, 'local')#</td>
                    <td>#qGetPaymentDetail.comment#</td>
                </tr>
                
            </cfloop>
            
            <Cfif NOT LEN(URL.placedPaymentList)>
                <tr><td colspan="5" align="center">No placement payments submitted.</td></tr>
            </cfif>

        </table>

        <br />

        <div align="center"><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index"><img src="pics/newpayment.gif" border="0" align="bottom"></a></div>

    <!--- Display FORM --->
    <cfelse>

        <p> Fill in the details for each student, all fields are optional. </p> <br /> 
        
        <cfform name="payments" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment" method="post">
            <input type="hidden" name="submitted" value="1" />
            <input type="hidden" name="user" value="#FORM.user#">
            <input type="hidden" name="supervisedStudentIDList" value="#FORM.supervisedStudentIDList#">
            <input type="hidden" name="placedStudentIDList" value="#FORM.placedStudentIDList#">
        
            <table width="90%" cellpadding="4" cellspacing="0">
                <!---- SUPERVISED STUDENTS ---->
                <tr><td bgcolor="##010066" colspan="5"><font color="white"><strong>Supervised Students </strong></font></td></tr>
                <tr bgcolor="##CCCCCC">
                	<td>ID</td>
                    <td>Student</td>
                    <td>Type</td>
                    <td>Amount</td>
                    <td>Comment</td>
				</tr>

                <cfloop list="#FORM.supervisedStudentIDList#" index="x">
                    
                    <cfquery name="qGetStudentInfo" dbtype="query">
                        SELECT 
                        	studentid, 
                            firstname, 
                            familylastname, 
                            programid
                        FROM 
                        	qGetAllStudents
                        WHERE 
                        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                    </cfquery>
                    
                    <!--- Check if there is a valid student --->
                    <cfif qGetStudentInfo.recordCount>
                    
                        <cfquery name="qCheckSupervisedCharges" datasource="MySQL">
                            SELECT 
                                rep.date,
                                rep.amount,
                                spt.type,
                                p.programname,
                                u.firstname, 
                                u.lastname
                            FROM 
                                smg_rep_payments rep
                            INNER JOIN 
                                smg_payment_types spt ON rep.paymenttype = spt.id
                            LEFT JOIN 
                                smg_programs p ON rep.programid = p.programid
                            LEFT JOIN 
                                smg_users u ON rep.agentid = u.userid
                            WHERE 
                                rep.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
                            AND 
                                spt.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.payment_type_super)#"> 
                            <!--- Do Not Include Club Leadership / It's not exclusive --->
                            AND 
                                spt.id != <cfqueryparam cfsqltype="cf_sql_integer" value="10"> 		
                        </cfquery>
                        
                        <tr>
                            <input type="hidden" value="supervision" name="#x#super_transtype">
                            <Td valign="top">
                                <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#x#', 700, 500);" class="nav_bar">
                                    #x#
                                </a>
                            </Td>
                            <td valign="top">
                                <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#x#', 700, 500);" class="nav_bar">
                                    #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#
                                </a>
                            </td>
                            <cfif qCheckSupervisedCharges.recordcount EQ 0 OR IsDefined('URL.split')>
                                <td valign="top">
                                    <cfselect name="#x#super_type">
                                        <option value="#qGetSupervisingPaymentType.id#">#qGetSupervisingPaymentType.type#</option>
                                    </cfselect>
                                    
                                    <cfif qCheckSupervisedCharges.recordcount>
                                        <br />
                                        #qCheckSupervisedCharges.type# was paid on #DateFormat(qCheckSupervisedCharges.date, 'mm/dd/yyyy')# - Program #qCheckSupervisedCharges.programname# - Rep: #qCheckSupervisedCharges.firstname# #qCheckSupervisedCharges.lastname# - Total Paid: #DollarFormat(qCheckSupervisedCharges.amount)#.
                                    </cfif>
                                </td>
                                <td valign="top"><cfinput type="text" name="#x#super_amount" value="#qGetSupervisingPaymentType.amount#" size="6" required="yes" message="Oops! You forgot to enter the amount for student #x#."></td>
                                <td valign="top"><cfinput type="text" name="#x#super_comment" size="20"></td>
                            <cfelse>
                                <td>
                                    <cfinput type="hidden" name="#x#super_type" value="">
                                    #qCheckSupervisedCharges.type# was paid on #DateFormat(qCheckSupervisedCharges.date, 'mm/dd/yyyy')# - Program #qCheckSupervisedCharges.programname# - Rep: #qCheckSupervisedCharges.firstname# #qCheckSupervisedCharges.lastname# - Total Paid: #DollarFormat(qCheckSupervisedCharges.amount)#.
                                </td>
                                <td>n/a</td>
                                <td>n/a</td>
                            </cfif>
                        </tr>
					
                    </cfif>  <!--- Check if there is a valid student --->                    
                       
                </cfloop>

				<cfif LEN(FORM.supervisedStudentIDList)>
                    <tr><td colspan="5" align="right"><input name="submit" type="image" src="pics/submit.gif" align="right" border="0" alt="submit"></td></Tr>
                <cfelse>
                    <tr><td colspan="5" align="center">No students selected.</td></tr>
                </cfif>
                               
                <tr><td>&nbsp;</td></tr>
            	
                <!---- PLACED STUDENTS ---->
                <tr><td bgcolor="##010066" colspan="5"><font color="white"><strong>Placed Students</strong></font></td></tr>
                <tr bgcolor="##CCCCCC">
                	<Td>ID</Td>
                    <td>Student</td>
                    <td>Type</td>
                    <td>Amount</td>
                    <td>Comment</td>
				</tr>

                <cfloop list="#FORM.placedStudentIDList#" index="x">

                    <cfquery name="qGetStudentInfo" dbtype="query">
                        SELECT 
                            studentid, 
                            firstname, 
                            familylastname, 
                            programid
                        FROM 
                            qGetAllStudents
                        WHERE 
                            studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                    </cfquery>
                    
                    <!--- Check if there is a valid student --->
                    <cfif qGetStudentInfo.recordCount>
                    	                       
                        <cfquery name="qCheckPlacedCharges" datasource="MySQL">
                            SELECT                                 
                                rep.paymenttype,
                                rep.date,
                                rep.amount,
                                spt.type,
                                p.programname,
                                u.firstname, 
                                u.lastname
                            FROM 
                                smg_rep_payments rep
                            INNER JOIN 
                                smg_payment_types spt ON rep.paymenttype = spt.id
                            LEFT JOIN 
                                smg_programs p ON rep.programid = p.programid
                            LEFT JOIN 
                                smg_users u ON rep.agentid = u.userid
                            WHERE 
                                rep.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#"> 
                        	
                            <!--- 
								These are mutually exclusive. Only one per student
								17 - Fast Track Bonus / 15 - Early Placement / 9 - Paperwork Bonus 
							--->
							<cfif ListFind(mutuallyExclusiveBonus, VAL(FORM.payment_type_place) )>
                                AND 
                                    spt.id IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#mutuallyExclusiveBonus#" list="yes"> )
							<cfelse>
                                AND 
                                    spt.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.payment_type_place)#">
							</cfif>                         

                            <!--- Do Not Include Club Leadership / It's not exclusive --->
                            AND 
                                spt.id != <cfqueryparam cfsqltype="cf_sql_integer" value="10"> 	
                        </cfquery>
                        
                        <tr>
                            <input type="hidden" value="placement" name="#x#place_transtype">
                            <Td valign="top">
                                <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#x#', 700, 500);" class="nav_bar">
                                    #x#
                                </a>
                            </Td>
                            <td valign="top">
                                <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#x#', 700, 500);" class="nav_bar">
                                    #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#
                                </a>
                            </td>
                            <cfif qCheckPlacedCharges.recordcount EQ 0 OR IsDefined('URL.split')>
                                <td valign="top">
                                    <cfselect name="#x#place_type">
                                        <option value="#qGetPlacementPaymentType.id#">#qGetPlacementPaymentType.type#</option>
                                    </cfselect>
                                    
                                    <cfif qCheckPlacedCharges.recordcount>
                                        <br />
                                        #qCheckPlacedCharges.type# was paid on #DateFormat(qCheckPlacedCharges.date, 'mm/dd/yyyy')# - Program #qCheckPlacedCharges.programname# - Rep: #qCheckPlacedCharges.firstname# #qCheckPlacedCharges.lastname# - Total Paid: #DollarFormat(qCheckPlacedCharges.amount)#.
                                    </cfif>
                                </td>
                                <td valign="top"><cfinput type="text" name="#x#place_amount" size="6" value="#qGetPlacementPaymentType.amount#" required="yes" message="Oops! You forgot to enter the amount for student #x#."></td>
                                <td valign="top"><cfinput type="text" name="#x#place_comment" size="20"></td>
                            <cfelse>
                                <td>
                                    <cfinput type="hidden" name="#x#place_type" value="">
                                    #qCheckPlacedCharges.type# was paid on #DateFormat(qCheckPlacedCharges.date, 'mm/dd/yyyy')# - Program #qCheckPlacedCharges.programname# - Rep: #qCheckPlacedCharges.firstname# #qCheckPlacedCharges.lastname# - Total Paid: #DollarFormat(qCheckPlacedCharges.amount)#.
                                </td>
                                <td>n/a</td>
                                <td>n/a</td>
                            </cfif>
                        </tr>
                        
                    </cfif> <!--- Check if there is a valid student --->
                        
                </cfloop>
                
                <cfif LEN(FORM.placedStudentIDList)>
                    <tr><td colspan="5" align="right"> <input name="submit" type="image" src="pics/submit.gif" align="right" border="0" alt="submit"></td></Tr>
                <cfelse>
					<tr><td colspan="5" align="center">No students selected.</td></tr>                	
                </cfif>

            </table>
	
   		</cfform>

	</cfif>

</cfoutput>

<!--- ASSIGN A PROGRAM TO A PAYMENT --->
<!----
<cfif CLIENT.userid EQ 510>
	<cfquery name="get_students" datasource="MySql">
		SELECT DISTINCT smg_students.studentid, smg_students.programid
		FROM smg_students
		INNER JOIN smg_rep_payments ON smg_rep_payments.studentid = smg_students.studentid
		AND smg_rep_payments.programid = '0'
		ORDER BY smg_students.studentid
	</cfquery>
	
	<cfloop query="get_students">
		<cfquery name="update" datasource="MySql">
			UPDATE smg_rep_payments
			SET programid = '#get_students.programid#'
			WHERE studentid = '#get_students.studentid#'
		</cfquery>
		
		<cfoutput>
		#get_students.studentid# <br />
		</cfoutput>
	</cfloop>
</cfif>
--->