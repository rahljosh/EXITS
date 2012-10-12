<!--- ------------------------------------------------------------------------- ----
	
	File:		profile.cfm
	Author:		Marcus Melo
	Date:		October 10, 2011
	Desc:		Profile
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.action" default="">
    <cfparam name="URL.studentID" default="0">
    <cfparam name="URL.tripID" default="0">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.action" default="">
    <cfparam name="FORM.studentID" default="">
    <cfparam name="FORM.tripID" default="">
    <cfparam name="FORM.newtripID" default="">
    <cfparam name="FORM.emailAddress" default="">
    <!--- Cancelation --->
	<cfparam name="FORM.dateCanceled" default="">
	<cfparam name="FORM.refundAmount" default="">
	<cfparam name="FORM.refundNotes" default="">
    <!--- Payment --->
	<cfparam name="FORM.datePaid" default="">
    <cfparam name="FORM.referencePaid" default="">
    
    <cfscript>
		if ( VAL(URL.studentID) ) {
			FORM.studentID = URL.studentID;	
		}
		
		if ( VAL(URL.tripID) ) {
			FORM.tripID = URL.tripID;	
		}	
	</cfscript>
    
    <cfquery name="qGetRegistrationInfo" datasource="#APPLICATION.DSN#">
        SELECT 
        	td.*,
        	st.id, 
            st.tripID,
            st.totalCost,
            st.dateDepositPaid,
            st.dateFullyPaid,
            st.med,
            st.date, 
            st.paid, 
            st.permissionForm,
            st.stuNationality, 
            st.email, 
        	st.person1, 
            st.person2, 
            st.person3, 
            st.nationality, 
            st.dateOnHold,
            st.holdReason, 
            st.dateCanceled,
            st.refundAmount,
            st.refundNotes,
            ap.ID AS applicationPaymentID,
            ap.amount,            
            s.studentID,
            s.companyID, 
            s.firstname, 
            s.familylastname, 
            s.dob,
            s.cell_phone,
            s.sex, 
            h.local_air_code, 
            h.major_air_code, 
            h.familylastname as hostLast,
            h.phone as hostPhone,
            h.email as hostEmail, 
            h.city as hostCity, 
            h.state as hostState,
            h.address as hostAddress,
            h.zip as hostZip,
			<!--- Get a sum of multiple payments (deposit + balance) --->
            ( 
                SELECT 
                    sum(amount)
                FROM
                    applicationPayment ap
                WHERE
                    ap.foreignID = st.ID
                AND
                    ap.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
                AND	
                    authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            ) AS totalReceived	
        FROM 
        	student_tours st
        INNER JOIN
            applicationPayment ap ON ap.foreignID = st.ID
                AND
                    foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
                AND	
                    authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        LEFT OUTER JOIN 
        	smg_students s on s.studentID = st. studentID
        LEFT OUTER JOIN
        	smg_tours td on td.tour_id = st.tripID
        LEFT OUTER JOIN 
        	smg_hosts h on h.hostid = s.hostid
        WHERE 
            st.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
        AND	
            st.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
    </cfquery>
    
    <cfquery name="qGetPaymentHistory" datasource="#APPLICATION.DSN#">
    	SELECT
            ap.*     
        FROM
	        applicationPayment ap
        WHERE
            ap.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
        AND	
            ap.authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND
        	ap.foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegistrationInfo.ID#">
	</cfquery>   
    
    <cfquery name="qGetDepartureFlightInformation" datasource="#APPLICATION.DSN#">
    	SELECT
        	*
       	FROM
        	student_tours_flight_information
       	WHERE 
            studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
        AND	
            tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
       	AND
        	flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
    </cfquery>
    
    <cfquery name="qGetArrivalFlightInformation" datasource="#APPLICATION.DSN#">
    	SELECT
        	*
       	FROM
        	student_tours_flight_information
       	WHERE 
            studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
        AND	
            tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
       	AND
        	flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
    </cfquery>
    
    <cfscript>
		if ( FORM.action NEQ 'resendEmail' ) {
			// Form Email Address
			FORM.emailAddress = qGetRegistrationInfo.email;
		}
	</cfscript>
    
    <!----Get Siblings on tours---->
    <cfquery name="qGetSiblingsRegistered" datasource="#APPLICATION.DSN#">
        SELECT 
            sibs.id,
            sibs.siblingid, 
            shc.name, 
            shc.lastname, 
            shc.birthdate, 
            shc.sex, 
            sibs.paid
        FROM 
            student_tours_siblings sibs
        LEFT OUTER JOIN
            smg_host_children shc on shc.childid = sibs.siblingid
        WHERE
            fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
        AND
            tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
        
        <cfif IsDate(qGetRegistrationInfo.paid)>
            AND 
                sibs.PAID IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
        </cfif>
        
        AND 
            sibs.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
    </cfquery>
    
    <!----Get available Tours so tours can be changed if needed---->
    <cfquery name="qGetAvailableTours" datasource="#APPLICATION.DSN#">
    	SELECT
        	tour_id, 
            tour_name
    	FROM
        	smg_tours
        WHERE
	        tour_status != <cfqueryparam cfsqltype="cf_sql_varchar" value="inactive">
    </cfquery>
	
    <!--- Check what action --->
    <cfswitch expression="#FORM.action#">
    	
        <!--- Resend Email --->
    	<cfcase value="resendEmail">
    
			<!--- Resend Email --->
            <cfif IsValid("email", FORM.emailAddress)>
                    
                <!--- trip Permission --->
                <cfdocument format="PDF" filename="#APPLICATION.PATH.temp#permissionForm_#VAL(qGetRegistrationInfo.studentID)#.pdf" overwrite="yes" margintop="0.2" marginbottom="0.2">
                    
                    <cfinclude template="tripPermission.cfm">
                    
                </cfdocument>
            
                <!--- Email to Student --->    
                <cfsavecontent variable="stuEmailMessage">		
                    <cfoutput>
                    <p>****This email was resent per your request.*****</p>
                    
                    <p>		
                        <h3>
                            A spot has been reserved for you <cfif VAL(qGetSiblingsRegistered.recordCount)> and #ValueList(qGetSiblingsRegistered.name)# </cfif> on the <strong>#qGetRegistrationInfo.tour_name#</strong> tour.
                        </h3>
                            
                        <font color="red">* * Your spot will not be confirmed until permission form has been received by MPD Tours America.Please work on getting this completed as soon as possible * *</font> 
                    </p>
                    
                    <p>
                        Attached is a Student Packet with hotel, airport arrival instructions, emergency numbers, etc.  
                        Please keep this handy for your trip and leave a copy with your host family while you are on the trip.
                    </p>
                    
                    <p>
                        Please return the permission form by:<br />
                        <ul>
                            <li>email: info@mpdtoursamerica.com</li>
                            <li>fax:   +1 718 439 8565</li>
                            <li>mail:  9101 Shore Road, ##203 - Brooklyn, NY 11209</li>
                        </ul>
                    </p>
                
                    <p>
                        Please visit our website for additional questions. 
                        <a href="http://trips.exitsapplication.com/frequently-asked-questions.cfm">http://trips.exitsapplication.com/frequently-asked-questions.cfm</a>
                    </p>
                    
                    <p>If you have any questions that are not answerd please don't hesitate to contact us at info@mpdtoursamerica.com. </p>
                    
                    <p>See you soon!</p>
                    
                    <p>
                        MPD Tour America, Inc.<br />
                        9101 Shore Road ##203- Brooklyn, NY 11209<br />
                        Email: info@mpdtoursamerica.com<br />
                        TOLL FREE: 1-800-983-7780<br />
                        Fax: 1-(718)-439-8565
                    </p>
                    </cfoutput>
                </cfsavecontent>   
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_from" value="<info@mpdtoursamerica.com> (Trip Support)">
                    <cfinvokeargument name="email_to" value="#FORM.emailAddress#">
                    <cfinvokeargument name="email_bcc" value="trips@iseusa.com">
                    <cfinvokeargument name="email_subject" value="Your #qGetRegistrationInfo.tour_name# trip Details">
                    <cfinvokeargument name="email_message" value="#stuEmailMessage#">
                    <cfinvokeargument name="email_file" value="#APPLICATION.PATH.temp#permissionForm_#VAL(qGetRegistrationInfo.studentID)#.pdf">
                    <cfinvokeargument name="email_file2" value="#APPLICATION.PATH.uploadedFiles#tours/#qGetRegistrationInfo.packetfile#">
                </cfinvoke>	
            	
                <cfscript>
					SESSION.pageMessages.Add("Forms have been resent to #FORM.emailAddress#");
					
					Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
				</cfscript>
            
            <cfelse>
            
                <cfscript>
					// Error Message
					SESSION.formErrors.Add("Please provide a valid email address");
				</cfscript>
                
            </cfif> 
            <!--- End of Resend Email --->	
        
        </cfcase>
        
        <!--- Update Trip --->
        <cfcase value="updateTripInfo">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET 
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.newtripID#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                AND	
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Trip information has been updated");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.newtripID#", "no");
            </cfscript>
        
        </cfcase>
		
        <!--- Remove Hold --->
        <cfcase value="removeHold">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET
                    dateOnHold = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    holdReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                AND	
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Hold has been removed");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
            </cfscript>
        
        </cfcase>

		<!--- Permission Received --->
        <cfcase value="permissionReceived">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET 
                    permissionForm = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                AND	
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Permission form has been set as RECEIVED");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
            </cfscript>
        
        </cfcase>

		<!--- Permission Not Received --->
        <cfcase value="permissionNOTReceived">

            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    student_tours
                SET 
                    permissionForm = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                AND	
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
            </cfquery>

			<cfscript>
                SESSION.pageMessages.Add("Permission form has been set as NOT RECEIVED");

				Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
            </cfscript>
        
        </cfcase>
        
        <!--- Authorize.net Submit Payment --->
        <cfcase value="authorizeNetPayment">
        
			<cfscript> 
				// Create Component Object
				cfcPaymentGateway = CreateCFC("paymentGateway").Init();
				
				// Try to process payment
				try {

					// credit card authorization and capture
					stProcessPayment = cfcPaymentGateway.CIMauthorizeAndCapture (
						customerProfileId = cfcPaymentGateway.getCustomerProfileID(customerID=VAL(FORM.studentID),companyID=CLIENT.companyID),
						customerPaymentProfileId = TRIM(FORM.authorizeNetPaymentID),														   
						orderNumber = '##' & Year(now()) & '-' & qGetRegistrationInfo.ID,	
						invoiceNumber = '##' & Year(now()) & '-' & qGetRegistrationInfo.ID,	 
						amount = TRIM(FORM.amount),
						// ApplicationPayment Table					
						foreignID=qGetRegistrationInfo.ID,
						paymentMethodID=qGetPaymentHistory.paymentMethodID,
						paymentMethodType=qGetPaymentHistory.paymentMethodType,
						creditCardTypeID=qGetPaymentHistory.creditCardTypeID,
						creditCardType=qGetPaymentHistory.creditCardType,
						nameOnCard=qGetPaymentHistory.nameOnCard,
						lastDigits=qGetPaymentHistory.lastDigits,
						expirationMonth=qGetPaymentHistory.expirationMonth,
						expirationYear=qGetPaymentHistory.expirationYear,
						billingFirstName=qGetPaymentHistory.billingFirstName,
						billingLastName=qGetPaymentHistory.billingLastName,
						billingCompany=qGetPaymentHistory.billingCompany,
						billingAddress=qGetPaymentHistory.billingAddress,
						billingCity=qGetPaymentHistory.billingCity,
						billingState=qGetPaymentHistory.billingState,
						billingZipCode=qGetPaymentHistory.billingZipCode,
						billingCountryID=qGetPaymentHistory.billingCountryID
					);															
					
					// Transaction Approved
					if ( stProcessPayment.authIsSuccess ) {
						// Successfull Message
						SESSION.pageMessages.Add(stProcessPayment.resultMessage);
					// Transaction Denied
					} else {
						// Error Message
						SESSION.formErrors.Add(stProcessPayment.resultMessage);
					}
					
				} catch(Any excpt) {
					// Could Not Process the Transaction
					SESSION.formErrors.Add(excpt.Message);
				}
            </cfscript>
			
            <!--- Get Total Paid --->
            <cfquery name="qGetTotalPaid" datasource="#APPLICATION.DSN#">
                SELECT
                    SUM(Amount) AS totalReceived     
                FROM
                    applicationPayment ap
                WHERE
                    ap.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
                AND	
                    ap.authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                    ap.foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegistrationInfo.ID#">
            </cfquery>   

			<!--- Set Trip as Fully Paid --->
            <cfif NOT isDate(qGetRegistrationInfo.dateFullyPaid) AND qGetRegistrationInfo.totalCost EQ qGetTotalPaid.totalReceived>

                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE
                        student_tours
                    SET
                        dateFullyPaid = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegistrationInfo.ID#">		
                </cfquery>
                
                <cfscript>
                    SESSION.pageMessages.Add("Trip Fully Paid");
                </cfscript>
        
            </cfif>
            
			<cfscript>
				// Refresh Page
                Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
            </cfscript>
        
        </cfcase>
        
        
		<!--- Payment Trip --->
        <cfcase value="manualPayment">

			<cfscript>
                if ( NOT IsDate(FORM.datePaid) ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("Please enter a valid payment date");
					FORM.datePaid = '';
                }

				if ( NOT LEN(FORM.referencePaid) ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("Please enter a reference for this payment (check/money order number)");
                }
            </cfscript>

			<!--- // Check if there are no errors --->
            <cfif NOT SESSION.formErrors.length()>

				<!--- Insert Payment --->
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE 
                        student_tours
                    SET 
                        paid = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE 
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                    AND	
                        tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
                </cfquery>
    			
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE
                        applicationPayment
                    SET  
                        authTransactionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.referencePaid#">
                    WHERE
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetRegistrationInfo.applicationPaymentID)#">
                </cfquery>
                
                <cfquery datasource="#APPLICATION.DSN#">
                	UPDATE
                    	student_tours_siblings
                   	SET
                    	paid = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                   	WHERE
                        fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                    AND
                        tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
                </cfquery>

                <!--- Email to Student --->    
                <cfsavecontent variable="stuEmailMessage">		
                    <cfoutput>
                    <p>Dear #qGetRegistrationInfo.firstName# #qGetRegistrationInfo.familyLastName# (###qGetRegistrationInfo.studentID#),</p>
                    
                    <p>This email is just to let you know your payment has been received for trip #qGetRegistrationInfo.tour_name#.</p>
                    
					<p><strong>To Book Your Airfare</strong></p>

                    <p>
                    	Please email the tour company at <a href="mailto:info@mpdtoursamerica.com">info@mpdtoursamerica.com</a> explaining you have returned all of 
                        your material (payment and permission forms) and include your full name, student ID number, and a phone number to best reach you.
                    </p>

                    <p>
                    	A representative from MPD will call you soon after to book your flight information.
                    </p>

                    <p>
                    	Please understand a working credit card is required at the time of the call to pay for your airfare trip.
                    </p>
                
                    <p>
                        Please visit our website for additional questions. 
                        <a href="http://trips.exitsapplication.com/frequently-asked-questions.cfm">http://trips.exitsapplication.com/frequently-asked-questions.cfm</a>
                    </p>
                    
                    <p>If you have any questions that are not answerd please don't hesitate to contact us at info@mpdtoursamerica.com </p>
                    
                    <p>See you soon!</p>
                    
                    <p>
                        MPD Tour America, Inc.<br />
                        9101 Shore Road ##203- Brooklyn, NY 11209<br />
                        Email: info@mpdtoursamerica.com<br />
                        TOLL FREE: 1-800-983-7780<br />
                        Fax: 1-(718)-439-8565
                    </p>
                    </cfoutput>
                </cfsavecontent>   
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_from" value="<info@mpdtoursamerica.com> (Trip Support)">
                    <cfinvokeargument name="email_to" value="#FORM.emailAddress#">
                    <cfinvokeargument name="email_bcc" value="trips@iseusa.com">
                    <cfinvokeargument name="email_subject" value="Your #qGetRegistrationInfo.tour_name# trip - Payment Received">
                    <cfinvokeargument name="email_message" value="#stuEmailMessage#">
                </cfinvoke>	

                <cfscript>
                    SESSION.pageMessages.Add("Payment has successfully been recorded");
    
                    Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
                </cfscript>
        	
            </cfif>
            
        </cfcase>
        
		<!--- Cancel Trip --->
        <cfcase value="cancelTrip">

			<cfscript>
                if ( NOT IsDate(FORM.dateCanceled) ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("Please enter a valid cancelation date");
					FORM.dateCanceled = '';
                }

                if ( NOT IsNumeric(FORM.refundAmount) ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("Please enter a valid refund amount (numbers only)");
					FORM.refundAmount = '';
                }

				if ( NOT LEN(FORM.refundNotes) ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("Please enter notes");
                }
            </cfscript>

			<!--- // Check if there are no errors --->
            <cfif NOT SESSION.formErrors.length()>

                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE 
                        student_tours
                    SET 
                        active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                        dateCanceled = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FORM.dateCanceled#">,
                        refundAmount = <cfqueryparam cfsqltype="cf_sql_float" value="#FORM.refundAmount#">,
                        refundNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.refundNotes#">       
                    WHERE 
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                    AND	
                        tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
                </cfquery>
                
                <cfsavecontent variable="cancellationMessage">
                	<cfoutput>
                        <p>Dear #qGetRegistrationInfo.firstName# #qGetRegistrationInfo.familyLastName# (###qGetRegistrationInfo.studentID#),</p>
                        
                        <p>This email is to notify you that your trip #qGetRegistrationInfo.tour_name# has been cancelled.</p>
                    
                    	<p>The reason given for this cancellation is: #FORM.refundNotes#</p>
                        
                        <p>You have been refunded #NumberFormat(FORM.refundAmount,"$999.99")#</p>
                        
                        <p>If you have any questions that are not answerd please don't hesitate to contact us at info@mpdtoursamerica.com </p>
                        
                        <p>
                            MPD Tour America, Inc.<br />
                            9101 Shore Road ##203- Brooklyn, NY 11209<br />
                            Email: info@mpdtoursamerica.com<br />
                            TOLL FREE: 1-800-983-7780<br />
                            Fax: 1-(718)-439-8565
                        </p>
                   	</cfoutput>
                </cfsavecontent>
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_from" value="<info@mpdtoursamerica.com> (Trip Support)">
                    <cfinvokeargument name="email_to" value="#FORM.emailAddress#">
                    <cfinvokeargument name="email_cc" value="info@mpdtoursamerica.com,tal@iseusa.com,#qGetRegistrationInfo.hostEmail#">
                    <cfinvokeargument name="email_bcc" value="trips@iseusa.com">
                    <cfinvokeargument name="email_subject" value="#qGetRegistrationInfo.tour_name# Trip - Notice of Cancellation">
                    <cfinvokeargument name="email_message" value="#cancellationMessage#">
                </cfinvoke> 
    
                <cfscript>
                    SESSION.pageMessages.Add("Trip has been canceled");
    
                    Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");					
                </cfscript>       
        	
            </cfif>
            
        </cfcase>
        
    </cfswitch>
        
</cfsilent>

<link rel="stylesheet" href="tours/trips.css" type="text/css"> <!-- trips -->

<script type="text/javascript" src="../nsmg/student_info.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
							   
		$(".jQueryModalPL").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false, 
			onClosed:function(){ window.location.reload(); }
		});
		
	});
	
	
	// Display Cancel Form
	var displayCancelForm = function() { 
		$("#cancelForm").fadeIn();	
	}
	
	// Display Payment Form
	var displayPaymentForm = function() { 
		$("#processPaymentForm").fadeIn();	
		//$("#paymentForm").fadeIn();	
	}
	
	var openFlights = function(studentID, tripID, viewType) {
		window.open("tours/flightInfo.cfm?studentID=" + studentID + "&tripID=" + tripID + "&viewType=" + viewType, "Flight Information", "height=700, width=1100");
	}
	
	// JQuery Modal
	var confirmPayment = function() { 
			
		// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
		$( "#dialog:ui-dialog" ).dialog( "destroy" );
	
		$( "#dialog-paymentConfirmation-confirm" ).dialog({
			resizable: false,
			height:200,
			width:400,
			modal: true,
			buttons: {
				"Submit Payment": function() {
					$( this ).dialog( "close" );
					// Submit Form
					$("#processPaymentForm").submit();
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			}
		});
			
	}
</script>	
		
<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="plane.png"
        tableTitle="Trip Details"
        tableRightTitle='<a href="index.cfm?curdoc=tours/mpdtours&tour_id=#FORM.tripID#&submitted=1">Back to List</a>'
    />

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />

	<!--- Modal Dialogs --->
    
    <!--- Payment Confirmation - Modal Dialog Box --->
    <div id="dialog-paymentConfirmation-confirm" title="Authorize.net - Submit Payment" class="displayNone" style="font-size:1em;"> 
        <p>
        	<span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 0 0;"></span>
        	Credit Card on file will be charged a total of <strong>#LSCurrencyFormat(qGetRegistrationInfo.totalCost - qGetRegistrationInfo.totalReceived)#</strong> for this trip
        </p> 
        <p>
        	<strong>Processing a credit card payment might take up to a minute, please DO NOT resubmit this page.</strong>
		</p>
    </div> 
    
	<!--- End of Modal Dialogs --->


    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" style="padding-top:10px; padding-bottom:10px;">
		<tr>            
        	<td width="170px" valign="top" <cfif IsDate(qGetRegistrationInfo.dateCanceled)>background="pics/canceled.jpg"</cfif>>
            	<img src="https://ise.exitsapplication.com/nsmg/uploadedfiles/web-students/#qGetRegistrationInfo.studentID#.jpg" height="150" style="margin-bottom:10px;"/> 
                
                <span class="greyTextBlock">DOB</span> 
				<span class="bigLabelBlock">#DateFormat(qGetRegistrationInfo.dob, 'mm/dd/yyyy')#</span>

                <span class="greyTextBlock">Gender</span> 
				<span class="bigLabelBlock">#qGetRegistrationInfo.sex#</span>
            </td>
            <!--- Student Information --->
            <td valign="top" <cfif IsDate(qGetRegistrationInfo.dateCanceled)>background="pics/canceled.jpg"</cfif>>
            	<span class="greyTextBlock">Name</span>
                <span class="bigLabelBlock">#qGetRegistrationInfo.firstname# #qGetRegistrationInfo.familylastname# (###qGetRegistrationInfo.studentID#)</span>
                
                <span class="greyTextBlock">Email Address</span>
                <span class="bigLabelBlock">#qGetRegistrationInfo.email#</span>
                
                <!--- Trip Information --->
                <span class="greyTextBlock">
                	Tour Information 
                	<cfif NOT IsDate(qGetRegistrationInfo.dateCanceled)>
                    	<a href="javascript:displayCancelForm();" style="padding-left:140px;">[ Cancel Trip ]</a>
                    </cfif>
                </span>
                <cfif NOT IsDate(qGetRegistrationInfo.dateCanceled)>
                    <form action="#CGI.SCRIPT_NAME#?curdoc=tours/profile" method="post" style="margin-bottom:5px;">
                        <input type="hidden" name="action" value="updateTripInfo" />
                        <input type="hidden" name="studentID" value="#FORM.studentID#" />
                        <input type="hidden" name="tripID" value="#FORM.tripID#" />
      
                        <select name="newtripID">
                            <cfloop query="qGetAvailableTours">
                                <option value="#qGetAvailableTours.tour_id#" <cfif qGetRegistrationInfo.tripID EQ qGetAvailableTours.tour_id>selected</cfif>>#qGetAvailableTours.tour_name#</option>
                            </cfloop>
                        </select>
                        
                        <input type="submit" value="Update trip" />
                    </form>
                <cfelse>                
                	<span class="bigLabelBlock">#qGetRegistrationInfo.tour_name#</span>
                </cfif>
				
                <span class="greyTextBlock">
                	<div style="width:100px; display:inline-block;">Registered On</div>
                    <div style="width:100px; display:inline-block;">Total Cost</div> 
                    <div style="width:100px; display:inline-block;">Total Paid</div> 
                    <div style="width:100px; display:inline-block;">Balance Due</div> 
                </span>
                
                <span class="bigLabelBlock">
                	<div style="width:100px; display:inline-block;">#DateFormat(qGetRegistrationInfo.date)#</div> 
                    <div style="width:100px; display:inline-block;">#LSCurrencyFormat(qGetRegistrationInfo.totalCost)#</div>
                    <div style="width:100px; display:inline-block;">#LSCurrencyFormat(qGetRegistrationInfo.totalReceived)#</div>
                    <div style="width:100px; display:inline-block;">
                    	<cfif qGetRegistrationInfo.totalCost EQ qGetRegistrationInfo.totalReceived>
                        	Fully Paid
                        <cfelse>
                        	<span style="color:##F00; font-weight:bold;">#LSCurrencyFormat(qGetRegistrationInfo.totalCost - qGetRegistrationInfo.totalReceived)#</span>
                        </cfif>
                    </div>
                </span>

                <span class="greyTextBlock">
                	<div style="width:130px; display:inline-block;">Credit Card</div>
                    <div style="width:80px; display:inline-block;">Last Digits</div>
                    <div style="width:90px; display:inline-block;">Payment Date</div>
                    <div style="width:60px; display:inline-block;">Amount</div>
                    <div style="width:160px; display:inline-block;">Transaction ID / Reference</div>                    
                </span>
                
                <!--- List All Payments --->
                <cfloop query="qGetPaymentHistory">
                    <span class="bigLabelBlock">
                        <div style="width:130px; display:inline-block;">#qGetPaymentHistory.creditCardType#</div>
                        <div style="width:80px; display:inline-block;">#qGetPaymentHistory.lastDigits#</div>
                        <div style="width:90px; display:inline-block;">
                            <cfif IsDate(qGetPaymentHistory.dateCreated)>
                                #dateFormat(qGetPaymentHistory.dateCreated, 'mm/dd/yy')#
                            <cfelse>
                                n/a
                            </cfif>
                        </div> 
                        <div style="width:60px; display:inline-block;">#LSCurrencyFormat(qGetPaymentHistory.amount)#</div> 
                        <div style="width:160px; display:inline-block;">
                            <cfif LEN(qGetPaymentHistory.authTransactionID)>
                                #qGetPaymentHistory.authTransactionID#
                            <cfelse>
                                n/a
                            </cfif>
                        </div>
                    </span>
                </cfloop>
                
                <cfif IsDate(qGetRegistrationInfo.dateCanceled)>
                    <span class="greyTextBlock">Cancelation Date &nbsp; / &nbsp; Refund Amount</span>
                    <span class="bigLabelBlock">#DateFormat(qGetRegistrationInfo.dateCanceled, 'mm/dd/yyyy')# &nbsp; / &nbsp; #LSCurrencyFormat(qGetRegistrationInfo.refundAmount)#</span>
                    
                    <span class="greyTextBlock">Notes</span>
                    <span class="bigLabelBlock">#qGetRegistrationInfo.refundNotes#</span>
                </cfif>
            </td>
            <!--- Host Family --->
            <td valign="top" <cfif IsDate(qGetRegistrationInfo.dateCanceled)>background="pics/canceled.jpg"</cfif>>
                <span class="greyTextBlock">Host Family </span>
                <span class="bigLabelBlock">#qGetRegistrationInfo.hostLast#</span>
                
                <span class="greyTextBlock">Host Phone</span>
                <span class="bigLabelBlock">#qGetRegistrationInfo.hostPhone#</span>

                <span class="greyTextBlock">Host Address</span>
                <span class="bigLabelBlock">#qGetRegistrationInfo.hostAddress#<br /> #qGetRegistrationInfo.hostCity#, #qGetRegistrationInfo.hostState# #qGetRegistrationInfo.hostZip#</span>
                
                <span class="greyTextBlock">Host Email Address</span>
                <span class="bigLabelBlock">#qGetRegistrationInfo.hostEmail#</span>

                <span class="greyTextBlock">Prefered Airport &nbsp; / &nbsp; Alt. Airport</span>
                <span class="bigLabelBlock">
                    <cfif NOT LEN(qGetRegistrationInfo.local_air_code)>
                        none
                    <cfelse>
                        #qGetRegistrationInfo.local_air_code#
                    </cfif> 
                    &nbsp; / &nbsp; 
                    <cfif NOT LEN(qGetRegistrationInfo.major_air_code)>
                        none
                    <cfelse>
                        #qGetRegistrationInfo.major_air_code#
                    </cfif> 
                </span>
            </td>
            <!--- Trip Preferences --->
        	<td valign="top" <cfif IsDate(qGetRegistrationInfo.dateCanceled)>background="pics/canceled.jpg"</cfif>>
                <span class="greyTextBlock">#qGetRegistrationInfo.firstname# Nationality </span>
                <span class="bigLabelBlock">#qGetRegistrationInfo.stunationality#</span>
                
                <span class="greyTextBlock">Roomate Nationality</span>
                <span class="bigLabelBlock">#qGetRegistrationInfo.nationality#</span>
                
                <span class="greyTextBlock">Roommate Requests</span>
                <span class="bigLabelBlock">
                    <cfif NOT LEN(qGetRegistrationInfo.person1) AND NOT LEN(qGetRegistrationInfo.person2) AND NOT LEN(qGetRegistrationInfo.person3)>
                        None
                    <cfelse>
                        <cfif LEN(qGetRegistrationInfo.person1)>#qGetRegistrationInfo.person1#<br /></cfif> 
                        <cfif LEN(qGetRegistrationInfo.person2)>#qGetRegistrationInfo.person2#<br /></cfif> 
                        <cfif LEN(qGetRegistrationInfo.person3)>#qGetRegistrationInfo.person3#<br /></cfif> 
                    </cfif>
                </span>       
                
                <span class="greyTextBlock">Medical / Allergy Info</span>
                <span class="bigLabelBlock">#qGetRegistrationInfo.med#</span>
            </td>            
		</tr>
	</table>


    <!--- Charge Credit Card ---> 
	<form name="processPaymentForm" id="processPaymentForm" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile" method="post" <cfif FORM.action NEQ "authorizeNetPayment"> class="displayNone" </cfif> > 
        <input type="hidden" name="action" value="authorizeNetPayment" />
        <input type="hidden" name="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="tripID" value="#FORM.tripID#" />
        <input type="hidden" name="authorizeNetPaymentID" value="#qGetPaymentHistory.authorizeNetPaymentID#" />
        <input type="hidden" name="amount" value="#qGetRegistrationInfo.totalCost - qGetRegistrationInfo.totalReceived#" />       

        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" style="padding-top:10px; padding-bottom:10px;">
            <tr>
                <td>
                
                    <table cellpadding="4" cellspacing="0" border="0" align="center" width="50%" style="border:1px solid ##3b5998;">
                        <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <th colspan="2">Authorize.Net - Charge Remaining Balance</th>
                        </tr> 
                        <tr>
                            <td width="30%" class="greyTextRight">Amount</td>
                            <td width="70%">#LSCurrencyFormat(qGetRegistrationInfo.totalCost - qGetRegistrationInfo.totalReceived)#</td>
                        </tr>
                        <tr>
                            <td class="greyTextRight">Credit Card Type</td>
                            <td>#qGetPaymentHistory.creditCardType#</td>
                        </tr>
                        <tr>
                            <td class="greyTextRight">Last 4 Digits of Credit Card</td>
                            <td>#qGetPaymentHistory.lastDigits#</td>
                        </tr>
                        <tr>
                        	<td>&nbsp;</td>
                        	<td>
                            	Credit Card on file is going to be used to process this transaction.
                            </td>
                        </tr>                        
                        <tr>
                        	<td colspan="2" align="center"><a href="javascript:confirmPayment();"><img src="pics/submitBlue.png" border="0" /></a></td>
                        </tr>
                    </table> 
                
                </td>            
            </tr>                               
        </table>                 
	
    </form>   


    <!--- Payment --->
	<form name="paymentForm" id="paymentForm" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile" method="post" <cfif FORM.action NEQ "manualPayment"> class="displayNone" </cfif> > 
        <input type="hidden" name="action" value="manualPayment" />
        <input type="hidden" name="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="tripID" value="#FORM.tripID#" />        
     
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" style="padding-top:10px; padding-bottom:10px;">
            <tr>
                <td>
                
                    <table cellpadding="4" cellspacing="0" border="0" align="center" width="50%" style="border:1px solid ##3b5998;">
                        <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <th colspan="2">Receive Payment</th>
                        </tr> 
                        <tr>
                            <td width="30%" class="greyTextRight">Amount</td>
                            <td width="70%">#LSCurrencyFormat(qGetRegistrationInfo.amount)#</td>
                        </tr> 
                        <tr>
                            <td class="greyTextRight">Payment Date</td>
                            <td><input type="text" name="datePaid" id="datePaid" value="#FORM.datePaid#" class="datePicker" /></td>
                        </tr> 
                        <tr>
                            <td class="greyTextRight">Reference (Check Number)</td>
                            <td><input type="text" name="referencePaid" id="referencePaid" value="#FORM.referencePaid#" class="mediumField" /></td>
                        </tr> 
                        <tr>
                            <td colspan="2" align="center" valign="top"><input type="image" src="pics/submitBlue.png" /></td>
                        </tr>
                    </table> 
                
                </td>            
            </tr>                               
        </table>                 
	
    </form>   


    <!--- Cancelation --->
	<form name="cancelForm" id="cancelForm" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile" method="post" <cfif FORM.action NEQ "cancelTrip"> class="displayNone" </cfif> > 
        <input type="hidden" name="action" value="cancelTrip" />
        <input type="hidden" name="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="tripID" value="#FORM.tripID#" />
     
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" style="padding-top:10px; padding-bottom:10px;">
            <tr>
                <td>
                
                    <table cellpadding="4" cellspacing="0" border="0" align="center" width="50%" style="border:1px solid ##3b5998;">
                        <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <th colspan="2">Cancel Trip</th>
                        </tr> 
                        <tr>
                            <td width="30%" class="greyTextRight">Cancelation Date</td>
                            <td width="70%"><input type="text" name="dateCanceled" id="dateCanceled" value="#FORM.dateCanceled#" class="datePicker" /></td>
                        </tr> 
                        <tr>
                            <td class="greyTextRight">Amout Refunded</td>
                            <td><input type="text" name="refundAmount" id="refundAmount" value="#FORM.refundAmount#" class="smallField" /></td>
                        </tr> 
                        <tr>
                            <td class="greyTextRight">Notes</td>
                            <td><textarea name="refundNotes" id="refundNotes" class="largeTextArea">#FORM.refundNotes#</textarea></td>
                        </tr>  
                        <tr>
                            <td colspan="2" align="center" valign="top"><input type="image" src="pics/submitBlue.png" /></td>
                        </tr>
                    </table> 
                
                </td>            
            </tr>                               
        </table>                 
	
    </form>   
	
    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" style="padding-top:10px; padding-bottom:10px;">
        <tr>
            <td>
            
                <table cellpadding="4" cellspacing="0" border="0" align="center">
                    <tr style="text-align:center;">
                        <td><h2>Hold</h2></td>
                        <td><h2>Full Payment</h2></td>
                        <td><h2>Permission</h2></td>
                        <td><h2>Arrival Flight</h2></td>
                        <td><h2>Departure Flight</h2></td>
                    </tr>
                    <tr style="text-align:center;">
                        <td>#dateFormat(qGetRegistrationInfo.dateOnHold, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(qGetRegistrationInfo.dateFullyPaid, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(qGetRegistrationInfo.permissionForm, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(qGetArrivalFlightInformation.departDate, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(qGetDepartureFlightInformation.departDate, 'mm/dd/yyyy')#</td>
                	</tr>
                    <tr style="text-align:center;">
                        <!--- On Hold --->
                        <td>
                            <cfif NOT isDate(qGetRegistrationInfo.dateOnHold)>
                                
                                <form method="post" action="index.cfm?curdoc=tours/hold&studentID=#FORM.studentID#&tripID=#FORM.tripID#">
                                    <input type="hidden" name="putHold" value="#FORM.studentID#" />
                                    
                                    <cfif listFind("1,2,3,4", CLIENT.userType)>                        
                                        <input name="submit" type="image" src="pics/buttons/putHold_25.png" />
                                    <cfelse>
                                        <img src="pics/buttons/putHold_25.png" border="0" />
                                    </cfif>
                                
                                </form>
                                    
                            <cfelse>
            
                                <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile">
                                    <input type="hidden" name="action" value="removeHold">
                                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                                    <input type="hidden" name="tripID" value="#FORM.tripID#" />                                    
            
                                    <cfif listFind("1,2,3,4", CLIENT.userType)>                        
                                        <input name="submit" type="image" src="pics/buttons/removeHold_29.png" />
                                    <cfelse>
                                        <img src="pics/buttons/removeHold_29.png" border="0" />
                                    </cfif>
            
                                </form>
                            
                            </cfif>
                        </td>
                        
                        <!--- Payment --->
                        <td>
                        	<cfif isDate(qGetRegistrationInfo.dateFullyPaid)>
                                <img src="pics/buttons/received_17.png" border="0" />
                            <cfelse>
                                <a href="javascript:displayPaymentForm();"><img src="pics/buttons/Notreceived_21.png" border="0" /></a>
                            </cfif>
                        </td>
                        
                        <!--- Permission --->
                        <td>
                            <cfif NOT LEN(qGetRegistrationInfo.permissionForm)>
                            
                                <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile">
                                    <input type="hidden" name="action" value="permissionReceived">
                                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                                    <input type="hidden" name="tripID" value="#FORM.tripID#" />                                    
                                    <input type="image" src="pics/buttons/Notreceived_21.png" >
                                </form>
                                
                            <cfelse>
                            
                                <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=tours/profile">
                                    <input type="hidden" name="action" value="permissionNOTReceived">
                                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                                    <input type="hidden" name="tripID" value="#FORM.tripID#" />                                    
                                    <input type="image" src="pics/buttons/received_17.png" >
                                </form>
                                
                            </cfif>
                        </td>
                        <!--- Flights --->
                        <td>
                            <cfif NOT LEN(qGetArrivalFlightInformation.departDate)>
                            	<a href="tours/flightInfo.cfm?studentID=#studentID#&tripID=#tripID#&viewType=arrival" class="jQueryModalPL">
                                	<img src="pics/buttons/notbooked_35.png" style="border:none;" />
                              	</a>                      
                            <cfelse>
                            	<a href="tours/flightInfo.cfm?studentID=#studentID#&tripID=#tripID#&viewType=arrival" class="jQueryModalPL">
                                	<img src="pics/buttons/booked_32.png" style="border:none;" />
                              	</a>                               
                            </cfif>
                        </td>
                        <td>
                            <cfif NOT LEN(qGetDepartureFlightInformation.departDate)>
                            	<a href="tours/flightInfo.cfm?studentID=#studentID#&tripID=#tripID#&viewType=departure" class="jQueryModalPL">
                                	<img src="pics/buttons/notbooked_35.png" style="border:none;" />
                              	</a>                                 
                            <cfelse>
                            	<a href="tours/flightInfo.cfm?studentID=#studentID#&tripID=#tripID#&viewType=departure" class="jQueryModalPL">
                                	<img src="pics/buttons/booked_32.png" style="border:none;" />
                              	</a>                               
                            </cfif>
                        </td>
                    </tr>
            
					<cfif isDate(qGetRegistrationInfo.dateOnHold)>
                        <tr>
                            <td colspan="4"><h2>Hold Reason</h2></td>
                        </tr>
                        <tr>
                            <td colspan="4">#qGetRegistrationInfo.holdReason#</td>
                        </tr>
                    </cfif>
                                        
        		</table>
	
			</td>
		</tr>
	</table>                    

	<!--- Siblings Information --->
    <cfif qGetSiblingsRegistered.recordcount>
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" style="padding-top:10px; padding-bottom:10px;">
            <tr>
                <td>
                
                    <table border="0" cellpadding="4" cellspacing="0" width="750px" align="center" style="border:1px solid ##3b5998; margin-top:25px; margin-bottom:25px;">
                        <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <th colspan="4" style="border-bottom:1px solid ##FFF;">SIBLINGS GOING ALONG</th>
                        </tr>
                        <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <td>Name</td>
                            <td>Age</td>
                            <td>Gender</td>
                            <td>Paid</td>
                        </tr>
                        <cfloop query="qGetSiblingsRegistered">
                            <tr bgcolor="#iif(qGetSiblingsRegistered.currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                                <td>#name# #lastname#</td>
                                <td>#DateDiff('yyyy', '#birthdate#', '#now()#')#</td>
                                <td>#sex#</td>
                                <td>#DateFormat(paid, 'mm/dd/yyyy')#</td>
                            </tr>	
                        </cfloop>
                    </table>
    
                </td>
            </tr>
        </table>
    </cfif>   
    
    <!--- Resend Profile --->      
	<form action="#CGI.SCRIPT_NAME#?curdoc=tours/profile" method="post"> 
        <input type="hidden" name="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="tripID" value="#FORM.tripID#" />
        <input type="hidden" name="action" value="resendEmail" />
                   
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" style="padding-top:10px; padding-bottom:10px;">
            <tr>
                <td>

                    <table cellpadding="4" cellspacing="0" border="0" align="center" width="50%" style="border:1px solid ##3b5998;">
                        <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <th colspan="2">Resend Forms To</th>
                        </tr> 
                        <tr>
                            <td width="30%" class="greyTextRight">Email</td>
                            <td width="70%"><input type="text" name="emailAddress" value="#FORM.emailAddress#" class="largeField"/></td>
                        </tr> 
                        <tr>
                            <td colspan="2" align="center" valign="top"><input type="submit" value="Resend Email" /></td>
                        </tr>
                    </table> 

                </td>
            </tr>
        </table>
                    
  	</form>      
     
    <!--- Table Footer --->
    <gui:tableFooter />

</cfoutput>