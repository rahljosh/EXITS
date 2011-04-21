<!--- ------------------------------------------------------------------------- ----
	
	File:		_processStudentPayment.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Process Payment By Student
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param FORM variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="studentID" default="0">
    <!--- Param URL variables --->
    <cfparam name="URL.placeid" default="0">
    <cfparam name="URL.superid" default="0">

    <cfparam name="placingPaymentID" default="">
    <cfparam name="supervisingPaymentID" default="">

    <cfquery name="qGetSupervisingPaymentType" datasource="MySQL">
        SELECT 
        	type, 
            id
        FROM 
        	smg_payment_types 
        WHERE 
        	active = '1' 
        AND 
        	(paymenttype = 'Supervision' or paymenttype = '')
    </cfquery>
    
    <cfquery name="qGetPlacementPaymentType" datasource="MySQL">
        SELECT 
        	type, 
            id
        FROM 
        	smg_payment_types 
        WHERE 
        	active = '1' 
		AND 
        	(paymenttype = 'Placement' or paymenttype = '')
    </cfquery>
    
    <cfquery name="qGetStudentInfo" datasource="MySql">
        SELECT 
        	s.studentid, 
            s.firstname, 
            s.familylastname, 
            s.arearepid, 
            s.placerepid, 
            s.programid
        FROM 
        	smg_students s
        WHERE 
        	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">
    </cfquery>
    
    <cfquery name="qGetPreviousPlaceRep" datasource="MySql">
        SELECT 
        	u.userid, 
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        WHERE 
        	u.userid = '#qGetStudentInfo.placerepid#'
        UNION
        SELECT 
        	host.placerepid, u.firstname, u.lastname
        FROM 
        	smg_hosthistory host
        INNER JOIN 
        	smg_users u ON u.userid = host.placerepid
        WHERE 
        	host.studentid = '#qGetStudentInfo.studentid#' 
        AND 
        	host.placerepid != '0'
        GROUP BY 
        	host.placerepid
    </cfquery>
    
    <cfquery name="qGetPreviousAreaRep" datasource="MySql">
        SELECT 
        	u.userid, 
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        WHERE 
        	u.userid = '#qGetStudentInfo.arearepid#'
        UNION
        SELECT 
        	host.arearepid, u.firstname, u.lastname
        FROM 
        	smg_hosthistory host
        INNER JOIN 
        	smg_users u ON u.userid = host.arearepid
        WHERE 
        	host.studentid = '#qGetStudentInfo.studentid#' 
        AND 
        	host.arearepid != '0'
        GROUP BY 
        	host.arearepid
    </cfquery>
    
    <cfif NOT VAL(URL.placeid)>
		<cfset URL.placeid = qGetPreviousPlaceRep.userid>
	</cfif>
    
	<cfif NOT VAL(URL.superid)>
		<cfset URL.superid = qGetPreviousAreaRep.userid>
	</cfif>

	<!--- Confirmation Page --->
	<cfif LEN(placingPaymentID) OR LEN(supervisingPaymentID)>    	
		
        <cfquery name="qGetPlacingConfirmation" datasource="MySql">
            SELECT 
                u.firstname, 
                u.lastname, 
                u.userid,
                s.studentid, 
                s.firstname as stufirstname, 
                s.familylastname,
                p.amount, 
                p.comment, 
                p.id,
                t.type
            FROM 
                smg_rep_payments p
            INNER JOIN 
                smg_users u ON p.agentid = u.userid
            INNER JOIN 
                smg_students s ON s.studentid = p.studentid
            INNER JOIN 
                smg_payment_types t ON t.id = p.paymenttype
            WHERE 
                p.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#placingPaymentID#">
        </cfquery>
        
        <cfquery name="qGetSupervisingConfirmation" datasource="MySql"> 
            SELECT 
                u.firstname, 
                u.lastname, 
                u.userid,
                s.studentid, 
                s.firstname as stufirstname, 
                s.familylastname,
                p.amount, 
                p.comment, 
                p.id,
                t.type
            FROM 
                smg_rep_payments p
            INNER JOIN 
                smg_users u ON p.agentid = u.userid
            INNER JOIN 
                smg_students s ON s.studentid = p.studentid
            INNER JOIN 
                smg_payment_types t ON t.id = p.paymenttype
            WHERE 
                p.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#supervisingPaymentID#">
        </cfquery>

	</cfif>

    <!--- FORM submitted --->
    <cfif FORM.submitted>

        <!--- supervising --->
        <cfif LEN(FORM.supervising_type)>
        
            <cfif NOT VAL(FORM.supervising_amount)>
                <h2>Supervising Amount is required and cannot be left blank.</h2>
                <br />Please go back and enter the information required.<br />
                <center><input name="back" alt="go back" type="image" src="pics/back.gif" border="0" onClick="javascript:history.back()"></center>
                <cfabort>	
            </cfif>
            
            <cftransaction action="begin" isolation="serializable">
                
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
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.superid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">,  
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.programid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.supervising_type#">, 
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,   
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="supervision">,   
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,   
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervising_amount#">,  
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">,   
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.supervising_comment#">
					)
                </cfquery>
                
                <cfset supervisingPaymentID = newRecord.GENERATED_KEY>	
                	
            </cftransaction>
        
        </cfif>
        
        <!--- placing --->
        <cfif LEN(FORM.placing_type)>
        
            <cfif NOT VAL(FORM.placing_amount)>
                <h2>Placing Amount is required and cannot be left blank.</h2>
                <br />Please go back and enter the information required.<br />
                <center><input name="back" alt="go back" type="image" src="pics/back.gif" border="0" onClick="javascript:history.back()"></center>
                <cfabort>	
            </cfif>
            
            <cftransaction action="begin" isolation="serializable">
                
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
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.placeid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">,  
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.programid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.placing_type#">, 
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,   
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="placement">,   
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,   
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.placing_amount#">,  
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">,   
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.placing_comment#">
					)
                </Cfquery>
                
                <cfset placingPaymentID = newRecord.GENERATED_KEY>	
                
            </cftransaction>

        </cfif>
		
        <!--- Location --->
		<cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processStudentPayment&studentid=#form.studentid#&placingPaymentID=#placingPaymentID#&supervisingPaymentID=#supervisingPaymentID#" addtoken="no">

	</cfif> <!--- End of Submitted --->

</cfsilent>

<SCRIPT LANGUAGE="JavaScript"> 
	<!-- Begin
	function formHandler(form){
	var URL = document.FORM.get_placeid.options[document.FORM.get_placeid.selectedIndex].value;
	window.location.href = URL;
	}
	function formHandler2(form){
	var URL = document.FORM.get_superid.options[document.FORM.get_superid.selectedIndex].value;
	window.location.href = URL;
	}
	// End -->
</SCRIPT>

<cfoutput>

    <h2>
        Student: #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# ##(#qGetStudentInfo.studentid#) 
        <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#qGetStudentInfo.studentid#', 700, 500);" class="nav_bar">
            &nbsp; <span class="get_attention"><b>::</b></span> [ Payment History ]
        </a>
    </h2>
    
    <br />

	<!--- Display Payment Confirmation --->
    <cfif LEN(placingPaymentID) OR LEN(supervisingPaymentID)>

        Below is a summary of the payments recorded.<br /><br />
	
        <table width=90% cellpadding=4 cellspacing=0>
            <tr>
                <td bgcolor="##010066" colspan="5">
                	<font color="white">
                    	<strong>
                        	Supervised by &nbsp; #qGetSupervisingConfirmation.firstname# #qGetSupervisingConfirmation.lastname# (#qGetSupervisingConfirmation.userid#)  &nbsp; <span class="get_attention"><b>::</b></span>
                            <a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetSupervisingConfirmation.userid#', 700, 500);" class="nav_bar">
                                Payment History
                            </a>
	                 	</strong>
					</font>
				</td>
            </tr>		
            <tr bgcolor="##CCCCCC">
                <Td>ID</Td><td>Student</td><td>Type</td><td>Amount</td><td>Comment</td>
            </tr>
            <Cfif qGetSupervisingConfirmation.recordcount is '0'>
            <tr>
                <td colspan="5" align="center">No supervision payments submitted.</td>
            </tr>
            <cfelse>
            <tr>
                <Td>#qGetSupervisingConfirmation.id#</Td><td>#qGetSupervisingConfirmation.stufirstname# #qGetSupervisingConfirmation.familylastname# (#qGetSupervisingConfirmation.studentid#)</td>
                <Td>#qGetSupervisingConfirmation.type#</Td>  
                <td>#LSCurrencyFormat(qGetSupervisingConfirmation.amount, 'local')#</td>
                <td>#qGetSupervisingConfirmation.comment#</td>
            </tr>
            </cfif>
            
            <tr><td>&nbsp;</td></tr>	
            
            <tr>
                <td bgcolor="##010066" colspan="5">
                	<font color="white">
                    	<strong>Placed by &nbsp; #qGetPlacingConfirmation.firstname# #qGetPlacingConfirmation.lastname# (#qGetPlacingConfirmation.userid#) &nbsp; 
                        	<span class="get_attention"><b>::</b></span>
                            <a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetPlacingConfirmation.userid#', 700, 500);" class="nav_bar">
                                Payment History
                            </a>
                        </strong>
					</font>
				</td>
            </tr>
            <tr bgcolor="##CCCCCC">
                <Td>ID</Td><td>Student</td><td>Type</td><td>Amount</td><td>Comment</td>
            </tr>
            <Cfif qGetPlacingConfirmation.recordcount is '0'>
            <tr>
                <td colspan="5" align="center">No placement payments submitted.</td>
            </tr>
            <cfelse>
            <tr>
                <Td>#qGetPlacingConfirmation.id#</Td><td>#qGetPlacingConfirmation.stufirstname# #qGetPlacingConfirmation.familylastname# (#qGetPlacingConfirmation.studentid#)</td>
                <Td>#qGetPlacingConfirmation.type#</Td>  
                <td>#LSCurrencyFormat(qGetPlacingConfirmation.amount, 'local')#</td>
                <td>#qGetPlacingConfirmation.comment#</td>
            </tr>
            </cfif>
        </table>
        
        <br />
        
        <div align="center"><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index"><img src="pics/newpayment.gif" border="0" align="bottom"></a></div>
    
    <!--- Display FORM --->
	<cfelse>

        Current Representative(s) assigned to this student:<br />
        
        <cfform name="form" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processStudentPayment" method="post">
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="studentid" value="#qGetStudentInfo.studentid#">
        <table width=90% cellpadding=4 cellspacing=0>
            <tr><td bgcolor="##010066" colspan="5"><font color="white"><strong>Supervised by</strong></font></td></tr>	
            <tr bgcolor="##CCCCCC"><td>Rep</td><td>Type</td><td>Amount</td><td>Comment</td></tr>
            <Cfif qGetStudentInfo.arearepid is 0>
            <tr><td colspan="5" align="center">No supervising representative was found.</td></tr>
            <tr><td colspan="5" align="right"><img src="pics/back.gif" border="0" onClick="javascript:history.back()"></td></tr>
            <cfelse>
            <tr>
                <td>
                    <select name="get_superid" onChange="javascript:formHandler2()">
                        <cfloop query="qGetPreviousAreaRep">
                            <option value="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processStudentPayment&studentid=#studentID#&superid=#userid#&placeid=#URL.placeid#" <cfif URL.superid is userid>selected</cfif>>#firstname# #lastname# (#userid#)</option>
                        </cfloop></select>
                    <input type="hidden" name="superid" value="#URL.superid#">
                    &nbsp; <span class="get_attention"><b>::</b></span>
                    <a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#URL.superID#', 700, 500);" class="nav_bar">Payment History</a>			
                    <!--- check what have already been paid for the selected rep and student --->
                    <Cfquery name="check_super_charges" datasource="MySQL">
                        SELECT spt.type, spt.id, rep.agentid, rep.studentid, rep.transtype
                        FROM smg_rep_payments rep
                        INNER JOIN smg_payment_types spt ON rep.paymenttype = spt.id
                        WHERE rep.studentid = '#qGetStudentInfo.studentid#' 
                            AND rep.paymenttype != '10' 
                            AND programid = '#qGetStudentInfo.programid#' 
                    </Cfquery>
                    <cfset super_charges = ''>
                    <cfset super_charges = ValueList(check_super_charges.id)>
                </td>
                <Td><cfselect name="supervising_type">
                    <option value=""></option>
                    <Cfloop query="qGetSupervisingPaymentType">
                        <cfif NOT ListFind(super_charges, id)>
                            <option value="#id#">#type#</option>
                        </cfif>	
                    </Cfloop>
                    </cfselect></Td> 
                <td><input type="text" name="supervising_amount" size="6"></td>
                <td><input type="text" name="supervising_comment" size="20"></td>
            </tr>
            <tr>
                <td colspan="5" align="right"><input name="submit" type="image" src="pics/submit.gif" align="right" border="0" alt="submit"></td>
            </tr>
            </cfif>
            
            <tr><td>&nbsp;</td></tr>
        
            <tr>
                <td bgcolor="##010066" colspan="5"><font color="white"><strong>Placed by</strong></font></td>
            </tr>
            <tr bgcolor="##CCCCCC">
                <td>Rep</td><td>Type</td><td>Amount</td><td>Comment</td>
            </tr>
            <Cfif qGetStudentInfo.placerepid is 0>
            <tr><td colspan="5" align="center">No placing representative was found.</td></tr>
            <tr><td colspan="5" align="right"><img src="pics/back.gif" border="0" onClick="javascript:history.back()"></td></tr>
            <cfelse>
            <tr><Td><select name="get_placeid" onChange="javascript:formHandler()">
                        <cfloop query="qGetPreviousPlaceRep">
                        <option value="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processStudentPayment&studentid=#studentID#&placeid=#userid#&superid=#URL.superid#" <cfif URL.placeid is userid>selected</cfif>>#firstname# #lastname# (#userid#)</option>
                        </cfloop></select> 
                    <input type="hidden" name="placeid" value="#URL.placeid#">
                    &nbsp; <span class="get_attention"><b>::</b></span>
                    <a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#URL.placeID#', 700, 500);" class="nav_bar">Payment History</a>			
					<!--- check what have already been paid for the selected rep and student --->
                    <Cfquery name="check_place_charges" datasource="MySQL">
                        SELECT spt.type, spt.id, rep.agentid, rep.studentid, rep.transtype
                        FROM smg_rep_payments rep
                        INNER JOIN smg_payment_types spt ON rep.paymenttype = spt.id
                        WHERE rep.studentid = '#qGetStudentInfo.studentid#'
                            AND rep.paymenttype != '10'  
                            AND programid = '#qGetStudentInfo.programid#'
                    </Cfquery>
                    <cfset place_charges = ''>
                    <cfset place_charges = ValueList(check_place_charges.id)>
                </td>
                <Td><cfselect name="placing_type">
                    <option value=""></option>
                    <Cfloop query="qGetPlacementPaymentType">
                        <cfif NOT ListFind(place_charges, id)>
                            <option value="#id#">#type#</option>
                        </cfif>	
                    </Cfloop>
                    </cfselect></Td>  
                <td><cfinput type="text" name="placing_amount" size="6"></td>
                <td><cfinput type="text" name="placing_comment" size="20"></td>
            </tr>
            <tr>
                <td colspan="5" align="right"><cfinput name="submit" type="image" src="pics/submit.gif" align="right" border="0" alt="submit"></td>
            </tr>
            </cfif>
        </table><br />
        </cfform>
    
    </cfif>

</cfoutput>