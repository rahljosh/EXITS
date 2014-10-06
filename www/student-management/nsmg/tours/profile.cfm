<!--- ------------------------------------------------------------------------- ----
	
	File:		profile.cfm
	Author:		Marcus Melo
	Date:		October 10, 2011
	Desc:		Profile
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output
<cfsilent>
---->
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
    <cfparam name="FORM.studentEmail" default="">
    <cfparam name="FORM.hostEmail" default="">
    <cfparam name="FORM.otherEmail" default="">
    <cfparam name="FORM.emailAddress" default="">
    <!--- Cancelation --->
	<cfparam name="FORM.dateCanceled" default="">
	<cfparam name="FORM.refundAmount" default="">
	<cfparam name="FORM.refundNotes" default="">
    <!--- Payment --->
	<cfparam name="FORM.datePaid" default="">
    <cfparam name="FORM.referencePaid" default="">
	<!--- Credit Card Processing --->
    <cfparam name="FORM.authorizeNetPaymentID" default="">
    <cfparam name="FORM.creditCardTypeID" default="">
    <cfparam name="FORM.creditCardType" default="">
    <cfparam name="FORM.balanceDue" default="0">
    <cfparam name="FORM.nameOnCard" default="">
    <cfparam name="FORM.cardNumber" default="">
    <cfparam name="FORM.lastDigits" default="">
    <cfparam name="FORM.expirationMonth" default="">
    <cfparam name="FORM.expirationYear" default="">
    <cfparam name="FORM.cardCode" default="">
    <cfparam name="FORM.billingFirstName" default="">
    <cfparam name="FORM.billingFirstName" default="">
    <cfparam name="FORM.billingLastName" default="">
    <cfparam name="FORM.billingCompany" default="">
    <cfparam name="FORM.billingAddress" default="">
    <cfparam name="FORM.billingCity" default="">
    <cfparam name="FORM.billingState" default="">
    <cfparam name="FORM.billingZipCode" default="">
    <cfparam name="FORM.billingCountryID" default="232">
    
    <cfscript>
		if ( VAL(URL.studentID) ) {
			FORM.studentID = URL.studentID;	
		}
		
		if ( VAL(URL.tripID) ) {
			FORM.tripID = URL.tripID;	
		}	
		
		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
		
		// Get Country List
		qGetCountryList = APPLICATION.CFC.LOOKUPTABLES.getCountry();
		
		//Set up constant for credit card types
		arCreditCardType = ArrayNew(1);		
		arCreditCardType[1] = "American Express";
		arCreditCardType[2] = "Discover";
		arCreditCardType[3] = "MasterCard";
		arCreditCardType[4] = "Visa";
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
            st.emergencyContactName,
            st.emergencyContactPhone,
            td.tour_name,
            ap.ID AS applicationPaymentID,
            ap.amount,            
            s.studentID,
            s.companyID, 
            s.firstname, 
            s.familylastname, 
            s.dob,
            s.cell_phone,
            s.sex,
            s.areaRepID,
            h.local_air_code,
            h.major_air_code, 
            h.familylastname as hostLast,
            h.phone as hostPhone,
            h.email as hostEmail, 
            h.city as hostCity, 
            h.state as hostState,
            h.address as hostAddress,
            h.zip as hostZip,
            rm.userID AS rmID,
            c.pm_email,
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
        	smg_students s on s.studentID = st.studentID
        LEFT OUTER JOIN
        	smg_tours td on td.tour_id = st.tripID
        LEFT OUTER JOIN 
        	smg_hosts h on h.hostid = s.hostid
      	LEFT OUTER JOIN
        	smg_companies c ON c.companyID = s.companyID
      	LEFT OUTER JOIN
        	smg_users rm ON rm.userID = (SELECT userID FROM user_access_rights WHERE userType = 5 AND regionID = s.regionAssigned LIMIT 1)
            AND rm.active = 1
        WHERE 
            st.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
        AND	
            st.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
    </cfquery>
    
    <cfquery name="paymentHistory" datasource="#APPLICATION.dsn#">
    SELECT st.id as paymentID, st.studentid,st.tripid, tours.tour_name, ap.amount, ap.authResponseCode, ap.lastdigits, ap.creditcardtype, s.firstname, s.familylastname, st.paid, st.dateDepositPaid, st.dateFullyPaid, st.active
                FROM student_tours st
                LEFT JOIN smg_tours tours on tours.tour_id = st.tripid
                LEFT JOIN applicationpayment ap on ap.foreignid = st.id
                LEFT JOIN smg_students s on s.studentid = st.studentid 
                WHERE st.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                ORDER BY authResponseCode
    </cfquery>
    
    
    <!--- PHP needs to get this information from another table --->
    <cfif qGetRegistrationInfo.companyID EQ 6>
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
                st.emergencyContactName,
                st.emergencyContactPhone,
                td.tour_name,
                ap.ID AS applicationPaymentID,
                ap.amount,            
                s.studentID,
                s.companyID, 
                s.firstname, 
                s.familylastname, 
                s.dob,
                s.cell_phone,
                s.sex,
                php.areaRepID,
                h.local_air_code,
                h.major_air_code, 
                h.familylastname as hostLast,
                h.phone as hostPhone,
                h.email as hostEmail, 
                h.city as hostCity, 
                h.state as hostState,
                h.address as hostAddress,
                h.zip as hostZip,
            	rm.userID AS rmID,
            	c.pm_email,
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
	 		FROM student_tours st
        	INNER JOIN applicationPayment ap ON ap.foreignID = st.ID
     			AND foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
          		AND	authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        	LEFT OUTER JOIN smg_students s on s.studentID = st.studentID
            LEFT OUTER JOIN php_students_in_program php ON php.studentID = st.studentID
        	LEFT OUTER JOIN smg_tours td on td.tour_id = st.tripID
        	LEFT OUTER JOIN smg_hosts h on h.hostid = php.hostid
      		LEFT OUTER JOIN smg_companies c ON c.companyID = s.companyID
      		LEFT OUTER JOIN smg_users rm ON rm.userID = 7630 <!--- The RM for PHP is always Luke Davis --->
        	WHERE st.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
        	AND st.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tripID)#">
    	</cfquery>
    </cfif>
    
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

    <cfquery name="qGetAuthorizeRecordedPayment" datasource="#APPLICATION.DSN#">
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
		AND
        	ap. authorizeNetPaymentID != <cfqueryparam cfsqltype="cf_sql_varchar" value="0">           
        GROUP BY
        	authorizeNetPaymentID
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
		
		// Set Balance Due 
		FORM.balanceDue = qGetRegistrationInfo.totalCost - qGetRegistrationInfo.totalReceived;
		
		qGetAreaRepInfo = APPLICATION.CFC.USER.getUsers(userID=qGetRegistrationInfo.areaRepID);
		qGetRegionalManagerInfo = APPLICATION.CFC.USER.getUsers(userID=qGetRegistrationInfo.rmID);
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
    
    <!--- This is to change the email headers based on the student's company --->
    <cfquery name="qGetCompany" datasource="#APPLICATION.DSN#">
        SELECT *
        FROM smg_companies
        WHERE companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetRegistrationInfo.companyID)#">
    </cfquery>
	
    <!--- Check what action --->
    <cfswitch expression="#FORM.action#">
    	
        <!--- Resend Email --->
    	<cfcase value="resendEmail">
    
			<!--- Resend Email --->
            <cfif ( IsValid("email", FORM.emailAddress) OR IsValid("email", FORM.hostEmail) OR IsValid("email", FORM.studentEmail) )>
                    
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
                            <!----
                        <font color="red">* * Your spot will not be confirmed until permission form has been received by MPD Tours America.Please work on getting this completed as soon as possible * *</font> 
						---->
                    </p>
                    
                    <p>
                        Attached is a Student Packet with hotel, airport arrival instructions, emergency numbers, etc.  
                        Please keep this handy for your trip and leave a copy with your host family while you are on the trip.
                    </p>
                    
                    <p>
                        It is your responsibility as the student to make sure that this permission form is filled out in its entirety. Once the form is complete, you MUST forward a copy of the completed form to BOTH MPD Tours <cfif qGetRegistrationInfo.companyID EQ 6>the Program Director, Luke Davis: luke@phpusa.com<cfelse>and your Regional Manager</cfif>.
                    </p>
                    
                    <p>
                        Please return the permission form by:<br />
                        <ul>
                            <li>email: mpdtours@exitsapplication.com</li>
                            <li>fax:   +1 718 439 8565</li>
                            <li>mail:  9101 Shore Road, ##203 - Brooklyn, NY 11209</li>
                        </ul>
                    </p>
                
                    <p>
                        Please visit our website for additional questions. 
                        <a href="http://trips.exitsapplication.com/frequently-asked-questions.cfm">http://trips.exitsapplication.com/frequently-asked-questions.cfm</a>
                    </p>
                    
                    <p>If you have any questions that are not answered please don't hesitate to contact us at mpdtours@exitsapplication.com. </p>
                    
                    <p>See you soon!</p>
                    
                    <p>
                        MPD Tour America, Inc.<br />
                        9101 Shore Road ##203- Brooklyn, NY 11209<br />
                        Email: mpdtours@exitsapplication.com<br />
                        TOLL FREE: 1-800-983-7780<br />
                        Fax: 1-(718)-439-8565
                    </p>
                    </cfoutput>
                </cfsavecontent>
                
                <cfscript>
					vEmailTo = "";
					if (IsValid("email",FORM.studentEmail)) {
						vEmailTo = vEmailTo & FORM.studentEmail;	
					}
					if (IsValid("email",FORM.hostEmail)) {
						if (LEN(vEmailTo)) {
							vEmailTo = vEmailTo & ",";	
						}
						vEmailTo = vEmailTo & FORM.hostEmail;
					}
					if (LEN(FORM.otherEmail) AND isValid("email",FORM.emailAddress)) {
						if (LEN(vEmailTo)) {
							vEmailTo = vEmailTo & ",";	
						}
						vEmailTo = vEmailTo & FORM.emailAddress;
					}
				</cfscript>
                
                <!--- To get the right headers --->
                <cfset currentCompanyID = CLIENT.companyID>
				<cfset currentCompanyName = CLIENT.companyName>
                <cfset CLIENT.companyID = qGetCompany.companyID>
                <cfset CLIENT.companyName = qGetCompany.companyName>
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_from" value="<mpdtours@exitsapplication.com> (Trip Support)">
                    <cfinvokeargument name="email_to" value="#vEmailTo#">
                    <cfinvokeargument name="email_bcc" value="trips@iseusa.com">
                    <cfinvokeargument name="email_subject" value="Your #qGetRegistrationInfo.tour_name# trip Details">
                    <cfinvokeargument name="email_message" value="#stuEmailMessage#">
                    <cfinvokeargument name="email_file" value="#APPLICATION.PATH.temp#permissionForm_#VAL(qGetRegistrationInfo.studentID)#.pdf">
                    <cfinvokeargument name="email_file2" value="#APPLICATION.PATH.uploadedFiles#tours/#qGetRegistrationInfo.packetfile#">
                </cfinvoke>
                
                <cfset CLIENT.companyID = currentCompanyID>
                <cfset CLIENT.companyName = currentCompanyName>
            	
                <cfscript>
					SESSION.pageMessages.Add("Forms have been resent to #vEmailTo#");
					
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
			
				if ( FORM.authorizeNetPaymentID EQ 0 ) {
				
					if ( NOT LEN(FORM.nameOnCard) ) {
						SESSION.formErrors.Add("Please enter name on credit card");
					}
		
					if ( NOT LEN(FORM.creditCardTypeID) ) {
						SESSION.formErrors.Add("Please select a credit card type");
					}
		
					if ( NOT LEN(FORM.cardNumber) ) {
						SESSION.formErrors.Add("Please enter a valid credit card number");
					}
		
					if ( NOT LEN(FORM.expirationMonth) ) {
						SESSION.formErrors.Add("Please select an expiration month");
					}
		
					if ( NOT LEN(FORM.expirationYear) ) {
						SESSION.formErrors.Add("Please select an expiration year");
					}
		
					if ( LEN(FORM.expirationMonth) AND LEN(FORM.expirationYear) AND FORM.expirationMonth & '/' & FORM.expirationYear LT DateAdd('m', -1, now()) ) {
						SESSION.formErrors.Add("Credit card has expired");
					}
					
					if ( NOT LEN(FORM.cardCode) ) {
						SESSION.formErrors.Add("Please enter a CCV code");
					}
					
					if ( NOT LEN(FORM.billingFirstName) ) {
						SESSION.formErrors.Add("Please enter a first name");
					}
		
					if ( NOT LEN(FORM.billingLastName) ) {
						SESSION.formErrors.Add("Please enter a last name");
					}
		
					if ( NOT LEN(FORM.billingAddress) ) {
						SESSION.formErrors.Add("Please enter an address");
					}
		
					if ( NOT LEN(FORM.billingCity) ) {
						SESSION.formErrors.Add("Please enter a city");
					}
		
					if ( NOT LEN(FORM.billingState) ) {
						SESSION.formErrors.Add("Please enter a state");
					}
		
					if ( NOT LEN(FORM.billingZipCode) ) {
						SESSION.formErrors.Add("Please enter a zip/postal code");
					}
		
					if ( NOT LEN(FORM.billingCountryID) ) {
						SESSION.formErrors.Add("Please select a country");
					}			
			
				} else {
					
					// Using Existing Payment Information = Set FORM Values
					qGetPaymentInfoByID = cfcPaymentGateway.getApplicationPaymentByID(authorizeNetPaymentID=FORM.authorizeNetPaymentID);
					
					// Set Form Values According to Previous Payment Method
					FORM.creditCardTypeID=qGetPaymentInfoByID.creditCardTypeID;
					FORM.creditCardType=qGetPaymentInfoByID.creditCardType;
					FORM.nameOnCard=qGetPaymentInfoByID.nameOnCard;
					FORM.cardNumber = '';
					FORM.lastDigits=qGetPaymentInfoByID.lastDigits;
					FORM.cardCode = '';
					FORM.expirationMonth=qGetPaymentInfoByID.expirationMonth;
					FORM.expirationYear=qGetPaymentInfoByID.expirationYear;
					FORM.billingFirstName=qGetPaymentInfoByID.billingFirstName;
					FORM.billingLastName=qGetPaymentInfoByID.billingLastName;
					FORM.billingCompany=qGetPaymentInfoByID.billingCompany;
					FORM.billingAddress=qGetPaymentInfoByID.billingAddress;
					FORM.billingCity=qGetPaymentInfoByID.billingCity;
					FORM.billingState=qGetPaymentInfoByID.billingState;
					FORM.billingZipCode=qGetPaymentInfoByID.billingZipCode;
					FORM.billingCountryID=qGetPaymentInfoByID.billingCountryID;
					
				}
			</cfscript>
            
            <!--- // Check if there are no errors  --->
            <cfif NOT SESSION.formErrors.length()>
           
				<cfscript>
					// Try to process payment
					try {
						
						// New Credit Card - Set Variables
						if ( FORM.authorizeNetPaymentID EQ 0 ) {
							vSetCreditCardType = arCreditCardType[FORM.creditCardTypeID];	
							vSetLastDigits = Right(FORM.cardNumber, 4);
						// Existing Credit Card - Keep values from query above
						} else {
							vSetCreditCardType = FORM.creditCardType;	
							vSetLastDigits = FORM.lastDigits;
						}
						
						// credit card authorization and capture
						stProcessPayment = cfcPaymentGateway.CIMauthorizeAndCapture (
							studentID=FORM.studentID,
							description="MPD Tours - #qGetRegistrationInfo.tour_name# - Balance Payment",
							customerPaymentProfileId = TRIM(FORM.authorizeNetPaymentID),														   
							orderNumber = '##' & Year(now()) & '-' & qGetRegistrationInfo.ID,	
							invoiceNumber = '##' & Year(now()) & '-' & qGetRegistrationInfo.ID,	 
							amount = TRIM(FORM.amount),
							// ApplicationPayment Table					
							foreignID=qGetRegistrationInfo.ID,
							paymentMethodID=1,
							paymentMethodType="Credit Card",
							creditCardTypeID=FORM.creditCardTypeID,
							creditCardType=vSetCreditCardType,
							nameOnCard=FORM.nameOnCard,
							cardNumber=FORM.cardNumber,
							lastDigits=vSetLastDigits,
							cardCode=FORM.cardCode,
							expirationMonth=FORM.expirationMonth,
							expirationYear=FORM.expirationYear,
							billingFirstName=FORM.billingFirstName,
							billingLastName=FORM.billingLastName,
							billingCompany=FORM.billingCompany,
							billingAddress=FORM.billingAddress,
							billingCity=FORM.billingCity,
							billingState=FORM.billingState,
							billingZipCode=FORM.billingZipCode,
							billingCountryID=FORM.billingCountryID
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
					// No Errors - Refresh Page
                    if ( NOT SESSION.formErrors.length() ) {
						// Refresh Page
						Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");
					}
                </cfscript>
            
            </cfif>
            				
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
                    	Please email the tour company at <a href="mailto:mpdtours@exitsapplication.com">mpdtours@exitsapplication.com</a> explaining you have returned all of 
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
                    
                    <p>If you have any questions that are not answered please don't hesitate to contact us at mpdtours@exitsapplication.com </p>
                    
                    <p>See you soon!</p>
                    
                    <p>
                        MPD Tour America, Inc.<br />
                        9101 Shore Road ##203- Brooklyn, NY 11209<br />
                        Email: mpdtours@exitsapplication.com<br />
                        TOLL FREE: 1-800-983-7780<br />
                        Fax: 1-(718)-439-8565
                    </p>
                    </cfoutput>
                </cfsavecontent>
                
                <!--- To get the right headers --->
                <cfset currentCompanyID = CLIENT.companyID>
				<cfset currentCompanyName = CLIENT.companyName>
                <cfset CLIENT.companyID = qGetCompany.companyID>
                <cfset CLIENT.companyName = qGetCompany.companyName> 
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_from" value="<mpdtours@exitsapplication.com> (Trip Support)">
                    <cfinvokeargument name="email_to" value="#FORM.emailAddress#">
                    <cfinvokeargument name="email_cc" value="#qGetRegistrationInfo.hostEmail#">
                    <cfinvokeargument name="email_bcc" value="trips@iseusa.com">
                    <cfinvokeargument name="email_subject" value="Your #qGetRegistrationInfo.tour_name# trip - Payment Received">
                    <cfinvokeargument name="email_message" value="#stuEmailMessage#">
                </cfinvoke>
                
                <cfset CLIENT.companyID = currentCompanyID>
                <cfset CLIENT.companyName = currentCompanyName>

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
                        
                        <p>If you have any questions that are not answered please don't hesitate to contact us at mpdtours@exitsapplication.com </p>
                        
                        <p>
                            MPD Tour America, Inc.<br />
                            9101 Shore Road ##203- Brooklyn, NY 11209<br />
                            Email: mpdtours@exitsapplication.com<br />
                            TOLL FREE: 1-800-983-7780<br />
                            Fax: 1-(718)-439-8565
                        </p>
                   	</cfoutput>
                </cfsavecontent>
                
                <!--- To get the right headers --->
                <cfset currentCompanyID = CLIENT.companyID>
				<cfset currentCompanyName = CLIENT.companyName>
                <cfset CLIENT.companyID = qGetCompany.companyID>
                <cfset CLIENT.companyName = qGetCompany.companyName>
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_from" value="<mpdtours@exitsapplication.com> (Trip Support)">
                    <cfinvokeargument name="email_to" value="#FORM.emailAddress#">
                    <cfinvokeargument name="email_cc" value="mpdtours@exitsapplication.com,tom@iseusa.com,#qGetRegistrationInfo.pm_email#,#qGetRegistrationInfo.hostEmail#">
                    <cfinvokeargument name="email_bcc" value="trips@iseusa.com">
                    <cfinvokeargument name="email_subject" value="#qGetRegistrationInfo.tour_name# Trip - Notice of Cancellation">
                    <cfinvokeargument name="email_message" value="#cancellationMessage#">
                </cfinvoke>
                
                <cfset CLIENT.companyID = currentCompanyID>
                <cfset CLIENT.companyName = currentCompanyName>
    
                <cfscript>
                    SESSION.pageMessages.Add("Trip has been canceled");
    
                    Location("#CGI.SCRIPT_NAME#?curdoc=tours/profile&studentID=#FORM.studentID#&tripID=#FORM.tripID#", "no");					
                </cfscript>       
        	
            </cfif>
            
        </cfcase>
        
    </cfswitch>
        <!----
</cfsilent>
---->
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
		
		// Display Credit Card Information	
		displayCreditCardForm();
				
		$("#authorizeNetPaymentID").click(function() {
			// Display Credit Card Information	
			displayCreditCardForm();												   
		});
		
	});
	
	// Display Credit Card Information when New is selected
	var displayCreditCardForm = function() { 
		vSelectedItem = $("#authorizeNetPaymentID").val();
		if ( vSelectedItem == 0 ) {
			$(".newCreditCardForm").fadeIn("fast");
			// Display Correct State Field	
			displayStateField();
		} else {
			$(".newCreditCardForm").fadeOut("fast");
		}

	}

	// Slide down steateform field div
	var displayStateField = function(usFieldClass, nonUsFieldClass) { 
		
		// Get Current Country Value
		getCountrySelected = $("#billingCountryID").val();
	
		if ( getCountrySelected == 232 ) {
			// US Selected	
			$("#nonUsStateField").slideUp("fast");
			$("#usStateField").slideDown("slow");
			// clear the other value
			$(".nonUsBillingState").val("");
		} else {
			// Non Us Selected
			$("#usStateField").slideUp("fast");
			$("#nonUsStateField").slideDown("slow");	
			// clear the other value
			$(".usBillingState").val("");
		}
	
	}

	// Display Cancel Form
	var displayCancelForm = function() { 
		$("#cancelForm").fadeIn();	
	}
	
	// Display Payment Form
	var displayAuthorizePaymentForm = function() { 
		$("#processPaymentForm").fadeIn();	
	}
	
	// Display Payment Form
	var displayPaymentForm = function() { 
		$("#paymentForm").fadeIn();	
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
        	Credit Card on file will be charged a total of <strong>#LSCurrencyFormat(FORM.balanceDue)#</strong> for this trip
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
                        	<span style="color:##F00; font-weight:bold;">#LSCurrencyFormat(FORM.balanceDue)#</span>
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
            <!--- Regional Manager --->
            <td valign="top" <cfif IsDate(qGetRegistrationInfo.dateCanceled)>background="pics/canceled.jpg"</cfif>>
                <span class="greyTextBlock">Regional Manager</span>
                <span class="bigLabelBlock">#qGetRegionalManagerInfo.firstName# #qGetRegionalManagerInfo.lastName#</span>
                
                <span class="greyTextBlock">Regional Manager Phone</span>
                <span class="bigLabelBlock">#qGetRegionalManagerInfo.phone#</span>

                <span class="greyTextBlock">Regional Manager Address</span>
                <span class="bigLabelBlock">#qGetRegionalManagerInfo.address#<br /> #qGetRegionalManagerInfo.city#, #qGetRegionalManagerInfo.state# #qGetRegionalManagerInfo.zip#</span>
                
                <span class="greyTextBlock">Regional Manager Email Address</span>
                <span class="bigLabelBlock">#qGetRegionalManagerInfo.email#</span>
            </td>
            <!--- Area Rep --->
            <td valign="top" <cfif IsDate(qGetRegistrationInfo.dateCanceled)>background="pics/canceled.jpg"</cfif>>
                <span class="greyTextBlock">Area Rep</span>
                <span class="bigLabelBlock">#qGetAreaRepInfo.firstName# #qGetAreaRepInfo.lastName#</span>
                
                <span class="greyTextBlock">Area Rep Phone</span>
                <span class="bigLabelBlock">#qGetAreaRepInfo.phone#</span>

                <span class="greyTextBlock">Area Rep Address</span>
                <span class="bigLabelBlock">#qGetAreaRepInfo.address#<br /> #qGetAreaRepInfo.city#, #qGetAreaRepInfo.state# #qGetAreaRepInfo.zip#</span>
                
                <span class="greyTextBlock">Area Rep Email Address</span>
                <span class="bigLabelBlock">#qGetAreaRepInfo.email#</span>
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

                <span class="greyTextBlock">Preferred Airport &nbsp; / &nbsp; Alt. Airport</span>
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
        <input type="hidden" name="amount" value="#FORM.balanceDue#" />      

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
                            <td class="greyTextRight">Payment Method</td>
                            <td>
                            	<select name="authorizeNetPaymentID" id="authorizeNetPaymentID" class="xLargeField">
                                	<cfloop query="qGetAuthorizeRecordedPayment">
                                    	<option value="#qGetAuthorizeRecordedPayment.authorizeNetPaymentID#" <cfif FORM.authorizeNetPaymentID EQ qGetAuthorizeRecordedPayment.authorizeNetPaymentID>selected="selected"</cfif> >
                                        	#qGetAuthorizeRecordedPayment.creditCardType# - #qGetAuthorizeRecordedPayment.lastDigits# - Exp. #qGetAuthorizeRecordedPayment.expirationMonth#/#qGetAuthorizeRecordedPayment.expirationYear#
                                        </option>
                                    </cfloop>
                                    <option value="0" <cfif FORM.authorizeNetPaymentID EQ '0'>selected="selected"</cfif> >*** New Credit Card ***</option>
                                </select>
                            </td>
                        </tr>
                        
						<!--- New Credit Card --->
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">Name on Credit Card <span class="required">*</span></td>
                            <td><input type="text" name="nameOnCard" id="nameOnCard" value="#FORM.nameOnCard#" class="largeField" maxlength="100" /></td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">Credit Card Type <span class="required">*</span></td>
                            <td>
                                <select name="creditCardTypeID" id="creditCardTypeID" class="mediumField">
                                    <option value=""></option>
                                    <cfloop index="i" from="1" to="#ArrayLen(arCreditCardType)#">
                                        <option value="#i#" <cfif i EQ FORM.creditCardTypeID> selected="selected" </cfif> >#arCreditCardType[i]#</option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">Credit Card Number <span class="required">*</span></td>
                            <td>
                                <input type="text" name="cardNumber" id="cardNumber" value="#FORM.cardNumber#" class="mediumField" maxlength="16" />
                                <em class="tripNotesRight">This will be a 15 or 16 digit number on the front of the card. No spaces or dashes</em>
                            </td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">Expiration Date <span class="required">*</span></td>
                            <td>
                                <select name="expirationMonth" id="expirationMonth" class="mediumField">
                                    <option value=""></option>
                                    <cfloop from="1" to="12" index="i">
                                        <option value="#i#" <cfif FORM.expirationMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                                    </cfloop>
                                </select>
                                /
                                <select name="expirationYear" id="expirationYear" class="smallField">
                                    <option value=""></option>
                                    <cfloop from="#Year(now())#" to="#Year(now()) + 8#" index="i">
                                        <option value="#i#" <cfif FORM.expirationYear EQ i> selected="selected" </cfif> >#i#</option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">CCV/CID Code <span class="required">*</span></td>
                            <td>
                                <input type="text" name="cardCode" id="cardCode" value="#FORM.cardCode#" class="xSmallField" maxlength="4" />
                                <div class="creditCardImageDiv">
                                    <div id="displayCardImage" class="card1"></div>
                                </div>
                                <em class="tripNotesRight">3 or 4 digit code</em>
                            </td>
                        </tr>
                        <tr class="newCreditCardForm displayNone" style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <th colspan="2">Billing Address</th>
                        </tr> 
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight" width="30%">First Name <span class="required">*</span></td>
                            <td width="70%"><input type="text" name="billingFirstName" id="billingFirstName" value="#FORM.billingFirstName#" class="largeField" maxlength="100" /></td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">Last Name <span class="required">*</span></td>
                            <td><input type="text" name="billingLastName" id="billingLastName" value="#FORM.billingLastName#" class="largeField" maxlength="100" /></td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">Company Name</td>
                            <td><input type="text" name="billingCompany" id="billingCompany" value="#FORM.billingCompany#" class="largeField" maxlength="100" /></td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">Country <span class="required">*</span></td>
                            <td>
                                <select name="billingCountryID" id="billingCountryID" class="largeField" onchange="displayStateField();">
                                    <option value=""></option>
                                    <cfloop query="qGetCountryList">
                                        <option value="#qGetCountryList.countryID#" <cfif FORM.billingCountryID EQ qGetCountryList.countryID> selected="selected" </cfif> >#qGetCountryList.countryName#</option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">Address <span class="required">*</span></td>
                            <td><input type="text" name="billingAddress" id="billingAddress" value="#FORM.billingAddress#" class="largeField" maxlength="100" /></td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">City <span class="required">*</span></td>
                            <td><input type="text" name="billingCity" id="billingCity" value="#FORM.billingCity#" class="largeField" maxlength="100" /></td>
                        </tr>
                        <!--- US State --->
                        <tr id="usStateField" class="field newCreditCardForm displayNone">
                            <td class="greyTextRight">State/Province <span class="required">*</span></td>
                            <td>
                                <select name="billingState" id="billingState" class="mediumField usBillingState">
                                    <option value=""></option>
                                    <cfloop query="qGetStateList">
                                        <option value="#qGetStateList.state#" <cfif FORM.billingState EQ qGetStateList.state> selected="selected" </cfif> >#qGetStateList.stateName#</option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                        <!--- Non US State --->
                        <tr id="nonUsStateField" class="field newCreditCardForm displayNone">
                            <td class="greyTextRight">State/Province <span class="required">*</span></td>
                            <td><input type="text" name="billingState" id="billingState" value="#FORM.billingState#" class="largeField nonUsBillingState" maxlength="100" /></td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td class="greyTextRight">Zip/Postal Code <span class="required">*</span></td>
                            <td><input type="text" name="billingZipCode" id="billingZipCode" value="#FORM.billingZipCode#" class="smallField" maxlength="20" /></td>
                        </tr>
                        <tr class="newCreditCardForm displayNone">
                            <td>&nbsp;</td>
                            <td><span class="required">* Required Fields</span></td>
                        </tr>          
                    
						<!--- Submit Button --->
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
                                <a href="javascript:displayAuthorizePaymentForm();"><img src="pics/buttons/Notreceived_21.png" border="0" /></a>
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
    
    
    
    
    <Table width=100% style="padding-top:10px; padding-bottom:10px;" class="section">
    	<tr>
        	<Td valign="top" width=60%>
    			<table border="0" cellpadding="4" cellspacing="0" width="100%" >
                        <tr>
                            <td>
            
                                <table cellpadding="4" cellspacing="0" border="0" align="center" width=100% >
                                    <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                                        <th colspan="9">Payment History</th>
                                    </tr> 
                                    <tr style="font-weight:bold;">
                                        <td>Tour</td>
                                        <td>Amount</td>
                                        <td>Status</td>
                                        <td>Card Type</td>
                                        <td>Last 4</td>
                                        <td>Date</td>
                                        <td>Deposit</td>
                                        <td>Full</td>
                                        <td>ISE Tran ID</td>
                                    </tr>
                                    <cfloop query="paymentHistory">
                                    <tr class="#iif(paymentHistory.currentRow MOD 2 ,DE("off") ,DE("on") )#"  <cfif active eq 0 and authResponseCode eq 'Approved'>bgcolor="##FFCCCC"</cfif>>
                                        <td>#tour_name#</td>
                                        <td>#amount#</td>
                                        <td>#authResponseCode#</td>
                                        <td>#creditCardType#</td>
                                        <td>#lastdigits#</td>
                                        <td><cfif len(paid)>  #DateFormat(paid, 'mm/dd/yyyy')#<cfelse> -- </cfif></td>
                                        <td><cfif len(dateDepositPaid)>  #DateFormat(dateDepositPaid, 'mm/dd/yyyy')#<cfelse> -- </cfif></td>
                                        <td><cfif len(dateFullyPaid)>  #DateFormat(dateFullyPaid, 'mm/dd/yyyy')#<cfelse> -- </cfif></td>
                                        <td>#paymentid#</td>
                                    </tr>
                                    </cfloop>
                                </table> 
            
                            </td>
                        </tr>
                    </table>
    
    		</Td>
            <td valign="top" width=40%>
    
    
				<!--- Resend Profile --->      
                <form action="#CGI.SCRIPT_NAME#?curdoc=tours/profile" method="post"> 
                    <input type="hidden" name="studentID" value="#FORM.studentID#" />
                    <input type="hidden" name="tripID" value="#FORM.tripID#" />
                    <input type="hidden" name="action" value="resendEmail" />
                               
                    <table border="0" cellpadding="4" cellspacing="0"  width="100%" >
                        <tr>
                            <td>
            
                                <table cellpadding="4" cellspacing="0" border="0" align="center" width="100%" >
                                    <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                                        <th colspan="2">Resend Forms To</th>
                                    </tr> 
                                    <tr>
                                        <td width="30%" class="greyTextRight">Email</td>
                                        <td width="70%">
                                            <input type="checkbox" name="studentEmail" value="#FORM.emailAddress#" checked="checked" />Email Student: #FORM.emailAddress#<br/>
                                            <input type="checkbox" name="hostEmail" value="#qGetRegistrationInfo.hostEmail#" checked="checked" />Email Host: #qGetRegistrationInfo.hostEmail#<br/>
                                            <input type="checkbox" name="otherEmail" value="1" />Other Email(s): 
                                            <input type="text" name="emailAddress" value="" class="largeField"/>
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td colspan="2" align="center" valign="top"><input type="submit" value="Resend Email" /></td>
                                    </tr>
                                </table> 
            
                            </td>
                        </tr>
                    </table>
                                
                </form>      
     	</td>
      </tr>
    </Table>
    <!--- Table Footer --->
    <gui:tableFooter />

</cfoutput>