<!--- ------------------------------------------------------------------------- ----
	
	File:		paymentGateway.cfc
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		This holds the functions needed for processing application fee

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="Payment Gateway"
	output="false" 
	hint="A collection of functions for the payment gateway module">

	<!--- Return the initialized Student object --->
	<cffunction name="Init" access="public" returntype="paymentGateway" output="false" hint="Sets up variables">
		
		<cfscript>
			if ( APPLICATION.isServerLocal ) {
				// Local Environment
				VARIABLES.processingURL = 'https://test.authorize.net/gateway/transact.dll';	
				// CIM URL
				VARIABLES.CIMprocessingURL = 'https://apitest.authorize.net/xml/v1/request.api';
				// The merchant's unique API login ID
				VARIABLES.loginID = '7MWuj9w95d4'; 
				// The merchant's unique transaction key
				VARIABLES.transactionKey = '2f773dtL2d6Wf9QV';
			} else {
				// Production Environment - MPD TOURS	
				VARIABLES.processingURL = 'https://secure.authorize.net/gateway/transact.dll';
				// CIM URL
				VARIABLES.CIMprocessingURL = 'https://api.authorize.net/xml/v1/request.api';
				// The merchant's unique API login ID
				VARIABLES.loginID = '8W7ks48D3rr'; 
				// The merchant's unique transaction key
				VARIABLES.transactionKey = '73FUxR52v3HRH9ug';
			}

		    /*	
				*** Developer Account | CIM Enabled ***
				Login ID: devMpdTours12
				Password: Ise2012Usa
				API Login ID: 7MWuj9w95d4
				Transaction Key: 2f773dtL2d6Wf9QV
				Payment Gateway ID: 376470
			
				*** Shared Developer Account ***
				Login ID: cnptest7192010
				Password: Authnet001
				API Login ID: 2E3jsfH7L5F
				Transaction Key: 979cxZC5g8dDRf9b
				Payment Gateway ID:
			
				Developer URL
					https://test.authorize.net/gateway/transact.dll
					https://certification.authorize.net/gateway/transact.dll
					
				Web Service URL in Developer Test 
					https://apitest.authorize.net/xml/v1/request.api				
				
				Web Service URL in Production 
					https://api.authorize.net/xml/v1/request.api
					https://secure.authorize.net/gateway/transact.dll

				WSDL https://api.authorize.net/xml/v1/schema/AnetApiSchema.xsd
				
				American Express Test Card 370000000000002
				Discover Test Card 6011000000000012
				Visa Test Card 4007000000027
				Second Visa Test Card 4012888818888
				JCB 3088000000000017
				Diners Club/ Carte Blanche 38000000000006				
			*/

			// Return this initialized instance
			return(this);
		</cfscript>
        
	</cffunction>


	<!--- Insert Payment Information --->
	<cffunction name="insertApplicationPayment" access="public" returntype="numeric" output="false" hint="Inserts a new payment information. Returns paymentID.">
        <cfargument name="applicationID" required="yes" hint="applicationID is required" />		
        <cfargument name="sessionInformationID" required="yes" hint="SESSION.informationID is required" />
        <cfargument name="authorizeNetPaymentID" default="0" required="no" hint="authorizeNetPaymentID is not defined" />		
		<cfargument name="foreignTable" required="yes" hint="foreignTable is required" />
		<cfargument name="foreignID" required="yes" hint="foreignID is required" />
		<cfargument name="amount" required="yes" hint="amount is required" />
        <cfargument name="paymentMethodID" required="yes" hint="paymentMethodID is required" />
		<cfargument name="paymentMethodType" required="yes" hint="paymentMethod is required" />
		<cfargument name="creditCardTypeID" required="yes" hint="creditCardTypeID is required" />
		<cfargument name="creditCardType" required="yes" hint="creditCardType is required" />
		<cfargument name="nameOnCard" required="yes" hint="nameOnCard is required" />
		<cfargument name="lastDigits" required="yes" hint="lastDigits is required" />
		<cfargument name="expirationMonth" required="yes" hint="expirationMonth is required" />
		<cfargument name="expirationYear" required="yes" hint="expirationYear is required" />
		<cfargument name="billingFirstName" required="yes" hint="billingFirstName is required" />
		<cfargument name="billingLastName" required="yes" hint="billingLastName is required" />
		<cfargument name="billingCompany" default="" hint="billingCompany is not required" />
		<cfargument name="billingAddress" required="yes" hint="billingAddress is not required" />
		<cfargument name="billingCity" required="yes" hint="billingCity is not required" />
		<cfargument name="billingState" required="yes" hint="billingState is not required" />
		<cfargument name="billingZipCode" required="yes" hint="billingZipCode is not required" />
		<cfargument name="billingCountryID" required="yes" hint="billingCountryID is not required" />
        
        <cfquery 
            result="newRecord"
            datasource="#APPLICATION.DSN#">
                INSERT INTO
                    applicationpayment
                (                    
                    applicationID,
                    sessionInformationID,
                    authorizeNetPaymentID,
                    foreignTable,
                    foreignID,
                    amount,
                    paymentMethodID,
                    paymentMethodType,
                    creditCardTypeID,
                    creditCardType,
                    nameOnCard,
                    lastDigits,
                    expirationMonth,
                    expirationYear,
                    billingFirstName,
                    billingLastName,
                    billingCompany,
                    billingAddress,
                    billingCity,
                    billingState,
                    billingZipCode,
                    billingCountryID,
                    dateCreated
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationID)#">,	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.sessionInformationID)#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.authorizeNetPaymentID)#">,	                   
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">,                    
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">,  
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.amount#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.paymentMethodID#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.paymentMethodType#">,                    
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.creditCardTypeID#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.creditCardType#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.nameOnCard#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.lastDigits#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.expirationMonth#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.expirationYear#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.billingFirstName#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.billingLastName#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.billingCompany#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.billingAddress#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.billingCity#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.billingState#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.billingZipCode#">,                    
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.billingCountryID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">                
                )                    
        </cfquery>
			
		<cfreturn newRecord.GENERATED_KEY />
	</cffunction>


	<!--- Update Authorize.Net Payment Information --->
	<cffunction name="updateApplicationPayment" access="public" returntype="void" output="false" hint="Updates Authorize.net Payment Information.">
        <cfargument name="ID" required="yes" hint="ID is required" />
        <cfargument name="authTransactionID" default="" hint="authTransactionID is not required" />
        <cfargument name="authApprovalCode" default="" hint="authApprovalCode is not required" />
        <cfargument name="authResponseCode" default="" hint="authResponseCode is not required" />
        <cfargument name="authResponseReason" default="" hint="authResponseReason is not required" />
        <cfargument name="authIsSuccess" default="false" hint="authIsSuccess is not required (true/false)" />
        
		<cfquery 
			datasource="#APPLICATION.DSN#">
				UPDATE
                	applicationpayment
                SET  
                    authTransactionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.authTransactionID#">,
                    authApprovalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.authApprovalCode#">,
                    authResponseCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.authResponseCode#">,
                    authResponseReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.authResponseReason#">,
                    authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.authIsSuccess#">
                WHERE
                	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
	</cffunction>


	<!--- Get Payment Information --->
	<cffunction name="getApplicationPaymentByID" access="public" returntype="query" output="false" hint="Gets a payment information.">
        <cfargument name="ID" default="" hint="ID is NOT required" />		
        <cfargument name="authorizeNetPaymentID" default="" hint="authorizeNetPaymentID is NOT required" />		

		<cfquery 
            name="qGetApplicationPaymentByID"
			datasource="#APPLICATION.DSN#">
				SELECT  
                	ID,             
					applicationID,
					sessionInformationID,
                    authorizeNetPaymentID,
					foreignTable,
					foreignID,
                    authTransactionID,
                    authApprovalCode,
                    authResponseCode,
                    authResponseReason,
                    authIsSuccess,
                    amount,
					paymentMethodID,
					paymentMethodType,
					creditCardTypeID,
					creditCardType,
					nameOnCard,
					lastDigits,
					expirationMonth,
					expirationYear,
					billingFirstName,
					billingLastName,
					billingCompany,
					billingAddress,
					billingCity,
					billingState,
					billingZipCode,
					billingCountryID,
                    dateUpdated,
                    dateCreated
				FROM
                	applicationpayment
                WHERE
               	
                <cfif LEN(ARGUMENTS.ID)>
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
                <cfelseif LEN(ARGUMENTS.authorizeNetPaymentID)>
                    authorizeNetPaymentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.authorizeNetPaymentID)#">
                <cfelse>
                	1 != 1
				</cfif>
                
		</cfquery>
		
		<cfreturn qGetApplicationPaymentByID />
	</cffunction>


	<!--- Get Payment Information --->
	<cffunction name="getApplicationPaymentInfo" access="public" returntype="query" output="false" hint="Gets application payment, returns a query.">
        <cfargument name="applicationPaymentID" default="" hint="paymentID is required" />		
        <cfargument name="applicationID" required="yes" hint="applicationID is required" />		
		<cfargument name="foreignTable" required="yes" hint="foreignTable is required" />
		<cfargument name="foreignID" required="yes" hint="foreignID is required" />
		<cfargument name="creditCardTypeID" required="yes" hint="creditCardTypeID is required" />
		<cfargument name="nameOnCard" required="yes" hint="nameOnCard is required" />
		<cfargument name="lastDigits" required="yes" hint="lastDigits is required" />
		<cfargument name="expirationMonth" required="yes" hint="expirationMonth is required" />
		<cfargument name="expirationYear" required="yes" hint="expirationYear is required" />
                            
		<cfquery 
            name="qGetApplicationPaymentInfo"
			datasource="#APPLICATION.DSN#">
				SELECT
               		ID,
                    applicationID,
					sessionInformationID,
                    authorizeNetPaymentID,
                    foreignTable,
                    foreignID,
					authTransactionID,
                    authIsSuccess,
                    authApprovalCode,
                    authResponseCode,
                    authResponseReason,
                    amount,
                    paymentMethodID,
                    paymentMethodType,
                    creditCardTypeID,
                    creditCardType,
                    nameOnCard,
                    lastDigits,
                    expirationMonth,
                    expirationYear,
                    billingFirstName,
                    billingLastName,
                    billingCompany,
                    billingAddress,
                    billingCity,
                    billingState,
                    billingZipCode,
                    billingCountryID
               	FROM
                	applicationpayment
                WHERE
                    applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationID)#">
                AND
                    foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
                AND
                    foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">
				AND
                    creditCardTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.creditCardTypeID#">
                AND
                    nameOnCard = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.nameOnCard#">
                AND
                    lastDigits = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.lastDigits#">
                AND
                    expirationMonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.expirationMonth#">
                AND
                    lastDigits = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.expirationYear#">
                AND
                	authorizeNetPaymentID != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
		</cfquery>
		
		<cfreturn qGetApplicationPaymentInfo />
	</cffunction>


	<!--- Authorize and Capture --->
	<cffunction name="authorizeAndCapture" displayname="Authorize and Capture" hint="Bills credit card Immediately" access="public" output="false" returntype="Struct">
		<cfargument name="amount" displayName="Amount" type="string" hint="The amount of the transaction" required="true" />
		<cfargument name="cardNumber" displayName="Card Number" type="string" hint="The customer's credit card number" required="true" />
		<cfargument name="expirationDate" displayName="Expiration Date" type="string" hint="The customer's credit card expiration date" required="true" />
        <cfargument name="invoiceNumber" displayName="Invoice Number" type="string" hint="Invoice Number" required="true" />
        <cfargument name="description" displayName="Description" type="string" hint="Description" required="true" />
        <cfargument name="studentID" displayName="Student ID" type="string" hint="Student ID" required="true" />
        <cfargument name="email" displayName="Email Address" type="string" hint="Email Address" required="true" />
        <cfargument name="billingFirstName" displayName="Billing First Name" type="string" hint="Billing First Name" required="true" />
        <cfargument name="billingLastName" displayName="Billing Last Name" type="string" hint="Billing Last Name" required="true" />
        <cfargument name="billingCompany" displayName="Billing Company" type="string" hint="Billing Company" required="true" />
        <cfargument name="billingAddress" displayName="Billing Address" type="string" hint="Billing Address" required="true" />
        <cfargument name="billingCity" displayName="Billing City" type="string" hint="Billing City" required="true" />
        <cfargument name="billingState" displayName="Billing State" type="string" hint="Billing State" required="true" />
        <cfargument name="billingZip" displayName="Billing Zip" type="string" hint="Billing Zip" required="true" />
        <cfargument name="billingCountry" displayName="Billing Country" type="string" hint="Billing Country" required="true" />
        		
		<cfif find("$",ARGUMENTS.amount) OR find(",",ARGUMENTS.amount)>
			<cfthrow type="payment.authorizeNet.authorizeAndCapture" message="Invalid Amount" detail="The amount to be charged to the credit card can not have dollar signs ($) or Commas (,) in it. Only numbers and a1 decimal place">
		</cfif>
		
        <!--- Submit Payment --->
		<cfhttp method="post" url="#VARIABLES.processingURL#">
			<cfhttpparam name="x_login" type="formfield" value="#TRIM(VARIABLES.loginID)#">
			<cfhttpparam name="x_tran_key" type="formfield" value="#TRIM(VARIABLES.transactionKey)#">
			<cfhttpparam name="x_method" type="formfield" value="CC">
			<cfhttpparam name="x_type" type="formfield" value="AUTH_CAPTURE">
			<cfhttpparam name="x_amount" type="formfield" value="#TRIM(ARGUMENTS.amount)#">
			<cfhttpparam name="x_delim_data" type="formfield" value="TRUE">
			<cfhttpparam name="x_delim_char" type="formfield" value="|">
			<cfhttpparam name="x_relay_response" type="formfield" value="FALSE">
			<cfhttpparam name="x_card_num" type="formfield" value="#TRIM(ARGUMENTS.cardNumber)#">
			<cfhttpparam name="x_exp_date" type="formfield" value="#TRIM(ARGUMENTS.expirationDate)#">
			<cfhttpparam name="x_invoice_num" type="formfield" value="#TRIM(ARGUMENTS.invoiceNumber)#">
            <cfhttpparam name="x_description" type="formfield" value="#TRIM(ARGUMENTS.description)#">
            <cfhttpparam name="x_cust_id" type="formfield" value="#TRIM(ARGUMENTS.studentID)#">
			<cfhttpparam name="x_email" type="formfield" value="#TRIM(ARGUMENTS.email)#">
			<cfhttpparam name="x_email_customer" type="formfield" value="TRUE">           
			<!---
            <cfhttpparam name="x_header_email_receipt" type="formfield" value="MPD TOUR AMERICA, INC.">
			<cfhttpparam name="x_footer_email_receipt" type="formfield" value="9101 SHORE ROAD, ## 203 <br /> BROOKLYN, NY 11209">
			---> 
            <cfhttpparam name="x_first_name" type="formfield" value="#TRIM(ARGUMENTS.billingFirstName)#">
			<cfhttpparam name="x_last_name" type="formfield" value="#TRIM(ARGUMENTS.billingLastName)#">
			<cfhttpparam name="x_company" type="formfield" value="#TRIM(ARGUMENTS.billingCompany)#">
			<cfhttpparam name="x_address" type="formfield" value="#TRIM(ARGUMENTS.billingAddress)#">
			<cfhttpparam name="x_city" type="formfield" value="#TRIM(ARGUMENTS.billingCity)#">
			<cfhttpparam name="x_state" type="formfield" value="#TRIM(ARGUMENTS.billingState)#">
			<cfhttpparam name="x_zip" type="formfield" value="#TRIM(ARGUMENTS.billingZip)#">
			<cfhttpparam name="x_country" type="formfield" value="#TRIM(ARGUMENTS.billingCountry)#">        
		</cfhttp>
		
		<cfreturn parseResponse(cfhttp.filecontent)/>
	</cffunction>


	<!--- Refund --->
	<cffunction name="refund" displayname="Credit" hint="Credits Money to Card" access="public" output="false" returntype="Struct">
		<cfargument name="amount" displayName="Amount" type="string" hint="Transaction Amount" required="true" />
		<cfargument name="trans_id" displayName="Transaction ID" type="string" hint="TRansaction ID of Prior Authorization" required="true" />
		<cfargument name="invoiceNumber" displayName="Order Number" type="string" hint="Order Number" required="true" />
		<cfargument name="card_num" displayName="Card Number (Last 4 digits only)" type="string" hint="Last 4 Digits of Credit Card Number" required="true" />

		<cfif find("$",ARGUMENTS.amount) OR find(",",ARGUMENTS.amount)>
			<cfthrow type="payment.authorize_net.authorize_and_capture" message="Invalid Amount" detail="The amount to be charged to the credit card can not have dollar signs ($) or Commas (,) in it. Only numbers and a1 decimal place">
		</cfif>
		
		<cfhttp method="post" url="#variables.processing_url#">
			<cfhttpparam name="x_login" type="formfield" value="#VARIABLES.loginID#">
			<cfhttpparam name="x_tran_key" type="formfield" value="#VARIABLES.transactionKey#">
			<cfhttpparam name="x_method" type="formfield" value="CC">
			<cfhttpparam name="x_type" type="formfield" value="CREDIT">
			<cfhttpparam name="x_amount" type="formfield" value="#ARGUMENTS.amount#">
			<cfhttpparam name="x_delim_data" type="formfield" value="TRUE">
			<cfhttpparam name="x_delim_char" type="formfield" value="|">
			<cfhttpparam name="x_relay_response" type="formfield" value="FALSE">
			<cfhttpparam name="x_trans_id" type="formfield" value="#ARGUMENTS.trans_id#">
			<cfhttpparam name="x_invoice_num" type="formfield" value="#ARGUMENTS.invoiceNumber#">
			<cfhttpparam name="x_card_num" type="formfield" value="#ARGUMENTS.card_num#">
		</cfhttp>

		<cfreturn parse_response(cfhttp.filecontent)/>
	</cffunction>


	<!--- Void Transaction --->
	<cffunction name="void_transaction" displayname="Void" hint="Cancels a Payment" access="public" output="false" returntype="Struct">
		<cfargument name="amount" displayName="Amount" type="string" hint="Transaction Amount" required="true" />
		<cfargument name="trans_id" displayName="Transaction ID" type="string" hint="TRansaction ID of Prior Authorization" required="true" />
		<cfargument name="invoiceNumber" displayName="Order Number" type="string" hint="Order Number" required="true" />
		<cfargument name="card_num" displayName="Card Number (Last 4 digits only)" type="string" hint="Last 4 Digits of Credit Card Number" required="true" />

		<cfif find("$",ARGUMENTS.amount) OR find(",",ARGUMENTS.amount)>
			<cfthrow type="payment.authorize_net.authorize_and_capture" message="Invalid Amount" detail="The amount to be charged to the credit card can not have dollar signs ($) or Commas (,) in it. Only numbers and a1 decimal place">
		</cfif>
		
		<cfhttp method="post" url="#variables.processing_url#">
			<cfhttpparam name="x_login" type="formfield" value="#VARIABLES.loginID#">
			<cfhttpparam name="x_tran_key" type="formfield" value="#VARIABLES.transactionKey#">
			<cfhttpparam name="x_method" type="formfield" value="CC">
			<cfhttpparam name="x_type" type="formfield" value="VOID">
			<cfhttpparam name="x_amount" type="formfield" value="#ARGUMENTS.amount#">
			<cfhttpparam name="x_delim_data" type="formfield" value="TRUE">
			<cfhttpparam name="x_delim_char" type="formfield" value="|">
			<cfhttpparam name="x_relay_response" type="formfield" value="FALSE">
			<cfhttpparam name="x_trans_id" type="formfield" value="#ARGUMENTS.trans_id#">
			<cfhttpparam name="x_invoice_num" type="formfield" value="#ARGUMENTS.invoiceNumber#">
			<cfhttpparam name="x_card_num" type="formfield" value="#ARGUMENTS.card_num#">
		</cfhttp>

		<cfreturn parse_response(cfhttp.filecontent)/>
	</cffunction>


	<!------------------------------------------------------------------------
		START OF CIM - CUSTOMER INFORMATION MANAGER  
	------------------------------------------------------------------------>
    
	<!--- Get Customer Profile ID --->
	<cffunction name="getCustomerProfileID" displayname="Void" hint="Gets the Authorize.net customer profile ID. Always returns an ID." access="public" output="false" returntype="numeric">
		<cfargument name="customerID" displayName="CustomerID / StudentID" type="numeric" hint="CustomerID / StudentID" required="true" />

		<cfquery 
            name="qGetCustomerProfileID"
			datasource="#APPLICATION.DSN#">
				SELECT
                	authorizeNetProfileID,
                    email,
                    firstName,
                    familyLastName,
                    companyID
                FROM
                	smg_students
                WHERE
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.customerID)#">
		</cfquery>            
            
		<cfscript>
			vGetCustomerProfileID = qGetCustomerProfileID.authorizeNetProfileID;
		
			// customer is not registered with Authorize.net / register customer / update customerProfileID in customer table
			if ( vGetCustomerProfileID EQ 0 ) {
				
				// Register Student/Customer
				vGetCustomerProfileID = createCustomerProfile(
					customerID = ARGUMENTS.customerID, 
					email = qGetCustomerProfileID.email,
					companyID = qGetCustomerProfileID.companyID,
					studentName = "#qGetCustomerProfileID.firstName# #qGetCustomerProfileID.familyLastName#"
				);
				
			}
		</cfscript>

		<cfreturn vGetCustomerProfileID />
	</cffunction>


	<!--- Create Customer Profile --->
	<cffunction name="CreateCustomerProfile" displayname="Void" hint="Create a customer profile along with any customer payment profiles and customer shipping addresses" access="public" output="false" returntype="string">
		<cfargument name="customerID" displayName="CustomerID / StudentID" type="numeric" hint="CustomerID / StudentID" required="true" />
		<cfargument name="email" displayName="Customer Email" type="string" hint="Customer Email" default="" />
		<cfargument name="companyID" displayName="companyID" default="1" type="numeric" hint="companyID" />
        <cfargument name="studentName" displayname="Student Name" default="">
        
        <cfscript>
			var resultCode = '';
			var resultMessage = '';
			var resultMessageCode = '';
			var customerProfileID = 0;
						
			// Set Description
			if ( ARGUMENTS.companyID EQ 10 ) {
				vDescription = "CASE Student";
			} else {
				vDescription = "ISE Student";
			}
			
			// Insert Student Name
			if ( LEN(ARGUMENTS.studentName) ) {
				vDescription = vDescription & " - " & ARGUMENTS.studentName;
			}
		</cfscript>
        
        <cfoutput>	
            <cfxml variable="xmlCreateCustomerProfile">
                <createCustomerProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
                    <merchantAuthentication>
                        <name>#TRIM(VARIABLES.loginID)#</name>
                        <transactionKey>#TRIM(VARIABLES.transactionKey)#</transactionKey>
                    </merchantAuthentication>
                    <profile>
                        <merchantCustomerId>#TRIM(ARGUMENTS.customerID)#</merchantCustomerId>
                        <description>#TRIM(vDescription)#</description>
                        <email>#TRIM(ARGUMENTS.email)#</email>
                    </profile>
                </createCustomerProfileRequest>
            </cfxml>
        </cfoutput>
        
        <cfhttp method="post" url="#VARIABLES.CIMprocessingURL#" result="httpResult">
            <cfhttpparam type="XML" value="#xmlCreateCustomerProfile#"/>
        </cfhttp>
        
		<cfscript>
			// Parse the return value into a ColdFusion XML document. Remove the Byte-Order-Mark (BOM) by stripping all pre-"<" characters. 
			xmlResult = XmlParse(REReplace( httpResult.FileContent, "^[^<]*", "", "all" ));
			
			// get result codes
			try {
				resultCode = xmlResult.createCustomerProfileResponse.messages.resultCode.XmlText;
				resultMessage = xmlResult.createCustomerProfileResponse.messages.message.text.XmlText;
				resultMessageCode = xmlResult.createCustomerProfileResponse.messages.message.code.XmlText;
			} catch(Any excpt) {
				// get errorResponse
				try {
					resultCode = xmlResult.errorResponse.messages.resultCode.XmlText;
					resultMessage = xmlResult.errorResponse.messages.message.text.XmlText;
				} catch(Any excpt) { }
			}
			
			// get customerProfileID (not available when there is an error)
			try {
				customerProfileID = xmlResult.createCustomerProfileResponse.customerProfileId.XmlText;
			} catch(Any excpt) {
				customerProfileID = 0;
			}
			
			// duplicate record - get ID from error message
			if (resultMessageCode EQ 'E00039') {
				getIDPos = refind("\d+", resultMessage, 0, "true");
				if( VAL(getIDPos.pos[1]) AND VAL(getIDPos.len[1]) )  {
					customerProfileID = Mid(resultMessage, getIDPos.pos[1], getIDPos.len[1]);
				}
			}
        </cfscript>
        
        <!--- Update Student Information - Insert authorize.net customerProfileID into student table --->
        <cfif VAL(customerProfileID)>
        
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_students
                    SET
                        authorizeNetProfileID = <cfqueryparam cfsqltype="cf_sql_integer" value="#customerProfileID#">
                    WHERE
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.CustomerID)#">
            </cfquery>            
        
        </cfif>
		
		<cfif resultCode EQ 'error' AND resultMessageCode NEQ 'E00039'> <!--- E00039 --> A duplicate record with id xxx already exists. --->     
			<cfthrow type="CIM.CreateCustomerProfile" message="Create Customer Profile - Error" detail="#resultMessage#">
        </cfif>

		<cfreturn VAL(customerProfileID) />
	</cffunction>   
    
    
	<!--- CIM - Create Customer Payment Profile Request --->
	<cffunction name="createCustomerPaymentProfile" displayname="Void" hint="Create a new customer payment profile for an existing customer profile." access="public" output="false" returntype="xml">
		<cfargument name="customerID" displayName="Customer ID" type="numeric" hint="Customer ID / StudentID" required="true" />
        <cfargument name="customerProfileID" displayName="Customer Profile ID" type="numeric" hint="Authorize.net Customer Profile ID" required="true" />
        <cfargument name="firstName" displayName="Billing First Name" type="string" hint="Billing First Name" default="" />
        <cfargument name="lastName" displayName="Billing Last Name" type="string" hint="Billing Last Name" default="" />
        <cfargument name="company" displayName="Billing Company" type="string" hint="Billing Company" default="" />
        <cfargument name="address" displayName="Billing Address" type="string" hint="Billing Address" default="" />
        <cfargument name="city" displayName="Billing City" type="string" hint="Billing City" default="" />
        <cfargument name="state" displayName="Billing State" type="string" hint="Billing State" default="" />
        <cfargument name="zip" displayName="Billing Zip" type="string" hint="Billing Zip" default="" />
        <cfargument name="country" displayName="Billing Country" type="string" hint="Billing Country" default="" />
        <cfargument name="phoneNumber" displayName="Billing Phone Number" type="string" hint="Billing Phone Number" default="" />        
        <cfargument name="cardNumber" displayName="Card Number" type="string" hint="Card Number" required="yes" />
        <cfargument name="expirationDate" displayName="Expiration Date" type="string" hint="Expiration Date - YYYY-MM" required="yes" />
        <cfargument name="cardCode" displayName="Card Code" type="string" hint="Card Code - Not stored" default="" />
        <cfargument name="validationMode" displayName="validation mode" type="string" hint="Validation Mode / none / testMode / liveMode" default="none" />
        <cfargument name="applicationPaymentID" displayName="ApplicationPaymentID" type="numeric" hint="applicationPaymentID" required="true" />
        <cfargument name="authorizeNetPaymentID" displayName="ApplicationPaymentID" type="numeric" hint="applicationPaymentID" required="true" />
		
		<cfscript>
            var resultCode = '';
            var resultMessage = '';
            var resultMessageCode = '';
            var customerPaymentProfileId = 0;
        </cfscript>
        
        <!--- Payment information has already been registered at authorize.net --->
        <cfif VAL(ARGUMENTS.authorizeNetPaymentID)>
        	
            <cfscript>
            	// Set Payment Profile ID
				customerPaymentProfileId = ARGUMENTS.authorizeNetPaymentID;
            </cfscript>
            
        <cfelse>
        
            <cfoutput>	
                <cfxml variable="xmlcreateCustomerPaymentProfile">
                    <createCustomerPaymentProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
                        <merchantAuthentication>
                            <name>#TRIM(VARIABLES.loginID)#</name>
                            <transactionKey>#TRIM(VARIABLES.transactionKey)#</transactionKey>
                        </merchantAuthentication>
                        <customerProfileId>#TRIM(ARGUMENTS.customerProfileID)#</customerProfileId>
                        <paymentProfile>
                            <billTo>
                                <firstName>#TRIM(ARGUMENTS.firstName)#</firstName>
                                <lastName>#TRIM(ARGUMENTS.lastName)#</lastName>
                                <company>#TRIM(ARGUMENTS.company)#</company>
                                <address>#TRIM(ARGUMENTS.address)#</address>
                                <city>#TRIM(ARGUMENTS.city)#</city>
                                <state>#TRIM(ARGUMENTS.state)#</state>
                                <zip>#TRIM(ARGUMENTS.zip)#</zip>
                                <country>#TRIM(ARGUMENTS.country)#</country>
                                <phoneNumber>#TRIM(ARGUMENTS.phoneNumber)#</phoneNumber>
                                <faxNumber></faxNumber>
                            </billTo>
                            <payment>
                                <creditCard>
                                    <cardNumber>#TRIM(ARGUMENTS.cardNumber)#</cardNumber>
                                    <expirationDate>#TRIM(ARGUMENTS.expirationDate)#</expirationDate>
                                </creditCard>
                            </payment>
                        </paymentProfile>
                        <validationMode>#TRIM(ARGUMENTS.validationMode)#</validationMode>
                    </createCustomerPaymentProfileRequest>
                </cfxml>
            </cfoutput>
    
            <cfhttp method="post" url="#VARIABLES.CIMprocessingURL#" result="httpResult">
                <cfhttpparam type="XML" value="#xmlcreateCustomerPaymentProfile#"/>
            </cfhttp>
            
			<cfscript>					
                // Parse the return value into a ColdFusion XML document. Remove the Byte-Order-Mark (BOM) by stripping all pre-"<" characters. 
                xmlResult = XmlParse(REReplace( httpResult.FileContent, "^[^<]*", "", "all" ));
                
                // get result codes
                try {
                    resultCode = xmlResult.createCustomerPaymentProfileResponse.messages.resultCode.XmlText;
                    resultMessage = xmlResult.createCustomerPaymentProfileResponse.messages.message.text.XmlText;
                    resultMessageCode = xmlResult.createCustomerPaymentProfileResponse.messages.message.code.XmlText;
                } catch(Any excpt) {
                    // get errorResponse
                    try {					
                        resultCode = xmlResult.errorResponse.messages.resultCode.XmlText;
                        resultMessage = xmlResult.errorResponse.messages.message.text.XmlText;
                    } catch(Any excpt) { }
                }
    
                // get customerPaymentProfileId (not available in case there is an error)
                try {
                    customerPaymentProfileId = xmlResult.createCustomerPaymentProfileResponse.customerPaymentProfileId.XmlText;
                } catch(Any excpt) {
                    customerPaymentProfileId = 0;
                }
            </cfscript>
            
			<cfif resultCode EQ 'error'> <!--- AND resultMessageCode NEQ 'E00039' --->
                <cfthrow type="CIM.createCustomerPaymentProfile.authorize_and_capture" message="Create Customer Payment Profile - Error" detail="#resultMessage#">
            </cfif>
        
        </cfif>
        
        <!--- Insert payment profile --->
        <cfif VAL(customerPaymentProfileId)>
        
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        applicationpayment
                    SET
                        authorizeNetPaymentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#customerPaymentProfileId#">
                    WHERE
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationPaymentID)#">
            </cfquery>            
        
        </cfif>

		<cfreturn xmlResult/>
	</cffunction>


	<!--- CIM - Authorize and Capture --->
	<cffunction name="CIMauthorizeAndCapture" displayname="Authorize and Capture" hint="CIM - Authorizes and captures" access="public" output="false" returntype="struct">
        <cfargument name="studentID" displayName="studentID" type="numeric" hint="studentID" required="true" />
        <cfargument name="description" displayName="description" type="string" hint="description" default="" />
        <cfargument name="customerPaymentProfileId" displayName="Customer Profile ID" type="numeric" hint="Authorize.net Customer Payment Profile ID" required="true" />
  		<cfargument name="invoiceNumber" displayName="Invoice Number" type="string" hint="Invoice Number" required="true" />
        <cfargument name="orderNumber" displayName="Order Number" type="string" hint="Order Number" required="true" />
        <cfargument name="amount" displayName="Amount" type="string" hint="Transaction Account" required="true" />	
		<!--- ApplicationPayment Table --->
        <cfargument name="foreignID" displayName="foreignID" type="string" hint="foreignID" required="true" />	
        <cfargument name="paymentMethodID" displayName="paymentMethodID" type="string" hint="paymentMethodID" required="true" />	
        <cfargument name="paymentMethodType" displayName="paymentMethodType" type="string" hint="paymentMethodType" required="true" />	
        <cfargument name="creditCardTypeID" displayName="creditCardTypeID" type="string" hint="creditCardTypeID" required="true" />	
        <cfargument name="creditCardType" displayName="creditCardType" type="string" hint="creditCardType" required="true" />	
        <cfargument name="nameOnCard" displayName="nameOnCard" type="string" hint="nameOnCard" required="true" />	
        <cfargument name="cardNumber" displayName="cardNumber" type="string" hint="cardNumber" required="true" />
        <cfargument name="lastDigits" displayName="lastDigits" type="string" hint="lastDigits" required="true" />	
        <cfargument name="cardCode" displayName="cardCode" type="string" hint="cardCode" required="true" />
        <cfargument name="expirationMonth" displayName="expirationMonth" type="string" hint="expirationMonth" required="true" />	
        <cfargument name="expirationYear" displayName="expirationYear" type="string" hint="expirationYear" required="true" />	
        <cfargument name="billingFirstName" displayName="billingFirstName" type="string" hint="billingFirstName" required="true" />	
        <cfargument name="billingLastName" displayName="billingLastName" type="string" hint="billingLastName" required="true" />	
        <cfargument name="billingCompany" displayName="billingCompany" type="string" hint="billingCompany" required="true" />	
        <cfargument name="billingAddress" displayName="billingAddress" type="string" hint="billingAddress" required="true" />	
        <cfargument name="billingCity" displayName="billingCity" type="string" hint="billingCity" required="true" />	
        <cfargument name="billingState" displayName="billingState" type="string" hint="billingState" required="true" />	
        <cfargument name="billingZipCode" displayName="billingZipCode" type="string" hint="billingZipCode" required="true" />	
        <cfargument name="billingCountryID" displayName="billingCountryID" type="string" hint="billingCountryID" required="true" />	
        
		<cfif find("$",ARGUMENTS.amount) OR find(",",ARGUMENTS.amount)>
			<cfthrow type="payment.authorize_net.CIM_authorize_and_capture" message="Invalid Amount" detail="The amount to be charged to the credit card can not have dollar signs ($) or Commas (,) in it. Only numbers and a1 decimal place">
		</cfif>       
        
        <cfscript>
			// Set Return Struct Struct
			stResult = structNew();
			stResult.resultMessage = "";
			stResult.resultCode = "";
			stResult.ApprovalCode = "";
			stResult.TransactionID = "";
			stResult.isApproved = false;
			
			// Get Authorize.Net Customer Profile ID
			vGetCustomerProfileID = getCustomerProfileID(customerID=ARGUMENTS.studentID);
			
			// Insert New Payment Information (applicationPayment Table) - That's how we track multiple payments
			getApplicationPaymentID = insertApplicationPayment( 
				applicationID=8,
				sessionInformationID=0,
				authorizeNetPaymentID=ARGUMENTS.customerPaymentProfileId,
				foreignTable='student_tours',
				foreignID=ARGUMENTS.foreignID,
				amount=ARGUMENTS.amount,
				paymentMethodID=ARGUMENTS.paymentMethodID,
				paymentMethodType=ARGUMENTS.paymentMethodType,
				creditCardTypeID=ARGUMENTS.creditCardTypeID,
				creditCardType=ARGUMENTS.creditCardType,
				nameOnCard=ARGUMENTS.nameOnCard,
				lastDigits=ARGUMENTS.lastDigits,
				expirationMonth=ARGUMENTS.expirationMonth,
				expirationYear=ARGUMENTS.expirationYear,
				billingFirstName=ARGUMENTS.billingFirstName,
				billingLastName=ARGUMENTS.billingLastName,
				billingCompany=ARGUMENTS.billingCompany,
				billingAddress=ARGUMENTS.billingAddress,
				billingCity=ARGUMENTS.billingCity,
				billingState=ARGUMENTS.billingState,
				billingZipCode=ARGUMENTS.billingZipCode,
				billingCountryID=ARGUMENTS.billingCountryID
			);
			
			// New Credit Card - Register with Authorize.net			
			if ( ARGUMENTS.customerPaymentProfileId EQ 0 ) {

				try {
					
					qGetSelectedCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry(countryID=ARGUMENTS.billingCountryID);

					// expiration month must be in the MM format
					if (LEN(ARGUMENTS.expirationMonth) EQ 1) {
						vExpirationDate = ARGUMENTS.expirationYear&'-0'&ARGUMENTS.expirationMonth;
					} else {
						vExpirationDate = ARGUMENTS.expirationYear&'-'&ARGUMENTS.expirationMonth;
					}

					// Create a Payment Profile for a registered customer
					xmlPaymentProfileID = createCustomerPaymentProfile(
						customerID = ARGUMENTS.studentID, 												   
						customerProfileID = vGetCustomerProfileID,											   
						firstName = ARGUMENTS.billingFirstName,												   
						lastName = ARGUMENTS.billingLastName,	
						company = ARGUMENTS.billingCompany,
						address = ARGUMENTS.billingAddress,
						city = ARGUMENTS.billingCity,
						state = ARGUMENTS.billingState,
						zip = ARGUMENTS.billingZipCode,
						country = qGetSelectedCountry.countryName,
						cardNumber = ARGUMENTS.cardNumber,
						expirationDate = vExpirationDate,
						cardCode = ARGUMENTS.cardCode,
						// ApplicationPayment Table
						applicationPaymentID=getApplicationPaymentID,
						authorizeNetPaymentID=ARGUMENTS.customerPaymentProfileId
					);
					
					// Set New Customer ID
					ARGUMENTS.customerPaymentProfileId = xmlPaymentProfileID.createCustomerPaymentProfileResponse.customerPaymentProfileId.XmlText;;
					
				} catch(Any excpt) {
					// A duplicate customer payment profile already exists.
					Throw(type="AuthorizeNetError",message="A duplicate customer payment profile already exists, please use a different card or select one from the drop down list");
				}

			}
		</cfscript>		
		
        <cfoutput>	
            <cfxml variable="xmlTransAuthCapture">
				<createCustomerProfileTransactionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
                  <merchantAuthentication>
                    <name>#TRIM(VARIABLES.loginID)#</name>
                    <transactionKey>#TRIM(VARIABLES.transactionKey)#</transactionKey>
                  </merchantAuthentication>
                  <transaction>
                    <profileTransAuthCapture>
                      <amount>#TRIM(ARGUMENTS.amount)#</amount>
                      <customerProfileId>#TRIM(vGetCustomerProfileID)#</customerProfileId>
                      <customerPaymentProfileId>#TRIM(ARGUMENTS.customerPaymentProfileId)#</customerPaymentProfileId>
                      <order>
                        <invoiceNumber>#TRIM(ARGUMENTS.invoiceNumber)#</invoiceNumber>
                        <description>#TRIM(ARGUMENTS.description)#</description>
                        <purchaseOrderNumber>#TRIM(ARGUMENTS.orderNumber)#</purchaseOrderNumber>
                      </order>
                    </profileTransAuthCapture>
                  </transaction>
                </createCustomerProfileTransactionRequest>
            </cfxml>
        </cfoutput>
		
        <cfhttp method="post" url="#variables.CIMprocessingURL#" result="objGet">
            <cfhttpparam type="XML" value="#xmlTransAuthCapture#"/>
        </cfhttp>

		<cfscript>
			// Parse the return value into a ColdFusion XML document. Remove the Byte-Order-Mark (BOM) by stripping all pre-"<" characters. 
			xmlResult = XmlParse(REReplace(objGet.FileContent, "^[^<]*", "", "all" ));
			
			// get transaction results
			stResult.resultCode = xmlResult.createCustomerProfileTransactionResponse.messages.resultCode.XmlText;
			
			try {
				stResult.resultMessage = ListGetAt(xmlResult.createCustomerProfileTransactionResponse.directResponse.xmlText, 4, ",");
				stResult.ApprovalCode = ListGetAt(xmlResult.createCustomerProfileTransactionResponse.directResponse.xmlText, 5, ",");			
				stResult.TransactionID = ListGetAt(xmlResult.createCustomerProfileTransactionResponse.directResponse.xmlText, 7, ",");
			} catch(Any excpt) {
				
				try {
					// try to get error message.						
					stResult.resultMessage = xmlResult.createCustomerProfileTransactionResponse.messages.message.text.xmlText;
				}
				catch(Any excpt) {
					// Throw Error
					Throw(type="AuthorizeNetError",message="There was a problem processing this transaction. Please make sure it did not go thru on Authorize.net site before trying again.");
				}	
				
			}
			
			// Payment Successfully Submitted
			if ( stResult.resultCode EQ 'Ok' ) {
				
				// Payment Approved
				stResult.authIsSuccess = true;
			
			// There was a problem processing the payment
			} else {
				
				// Payment Not Approved
				stResult.authIsSuccess = false;
				
			}
			
			// Update Authorize.net fields on the payment table
			updateApplicationPayment(
				ID=getApplicationPaymentID,						   
				authTransactionID=stResult.TransactionID,						   
				authApprovalCode=stResult.ApprovalCode,
				authResponseCode=stResult.resultCode,
				authResponseReason=stResult.resultMessage,
				authIsSuccess=stResult.authIsSuccess
			);
			
			return stResult;
		</cfscript>

	</cffunction>


    <!--- CIM - Refund --->
	<cffunction name="CIMrefund" displayname="CIM - Refund a Transaction" hint="CIM - Refund a Transaction" access="public" output="false" returntype="xml">
        <cfargument name="customerProfileId" displayName="Customer Profile ID" type="numeric" hint="Authorize.net Customer Profile ID" required="true" />
        <cfargument name="customerPaymentProfileId" displayName="Customer Profile ID" type="numeric" hint="Authorize.net Customer Payment Profile ID" required="true" />
		<cfargument name="transactionID" displayName="Transaction ID" type="string" hint="TRansaction ID of Prior Authorization" required="true" />
        <cfargument name="amount" displayName="Amount" type="string" hint="Transaction Account" required="true" />
		
		<cfif find("$",ARGUMENTS.amount) OR find(",",ARGUMENTS.amount)>
			<cfthrow type="payment.authorize_net.CIM_authorize_and_capture" message="Invalid Amount" detail="The amount to be charged to the credit card can not have dollar signs ($) or Commas (,) in it. Only numbers and a1 decimal place">
		</cfif>

        <cfoutput>	
            <cfxml variable="xmlRefund">
                <createCustomerProfileTransactionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
                  <merchantAuthentication>
                    <name>#TRIM(VARIABLES.loginID)#</name>
                    <transactionKey>#TRIM(VARIABLES.transactionKey)#</transactionKey>
                  </merchantAuthentication>
                  <transaction>
                    <profileTransRefund>
                      <amount>#TRIM(ARGUMENTS.amount)#</amount>
                      <customerProfileId>#TRIM(ARGUMENTS.customerProfileId)#</customerProfileId>
                      <customerPaymentProfileId>#TRIM(ARGUMENTS.customerPaymentProfileId)#</customerPaymentProfileId>
                      <transId>#TRIM(ARGUMENTS.transactionID)#</transId>
                    </profileTransRefund>
                  </transaction>
                </createCustomerProfileTransactionRequest>
            </cfxml>
        </cfoutput>

        <cfhttp method="post" url="#variables.CIMprocessingURL#" result="objGet">
            <cfhttpparam type="XML" value="#xmlRefund#"/>
        </cfhttp>

		<cfscript>
			// Parse the return value into a ColdFusion XML document. Remove the Byte-Order-Mark (BOM) by stripping all pre-"<" characters. 
			xmlResult = XmlParse(REReplace( objGet.FileContent, "^[^<]*", "", "all" ));
		</cfscript>
		
		<cfreturn xmlResult />
	</cffunction>

    
    <!--- CIM - Void Transaction --->
	<cffunction name="CIMvoid" displayname="CIM - Void a transaction" hint="CIM - Void a transaction" access="public" output="false" returntype="xml">
        <cfargument name="customerProfileId" displayName="Customer Profile ID" type="numeric" hint="Authorize.net Customer Profile ID" required="true" />
        <cfargument name="customerPaymentProfileId" displayName="Customer Profile ID" type="numeric" hint="Authorize.net Customer Payment Profile ID" required="true" />
		<cfargument name="transactionID" displayName="Transaction ID" type="string" hint="TRansaction ID of Prior Authorization" required="true" />
		
		<cfif find("$",ARGUMENTS.amount) OR find(",",ARGUMENTS.amount)>
			<cfthrow type="payment.authorize_net.CIM_authorize_and_capture" message="Invalid Amount" detail="The amount to be charged to the credit card can not have dollar signs ($) or Commas (,) in it. Only numbers and a1 decimal place">
		</cfif>

        <cfoutput>	
            <cfxml variable="xmlTransVoid">
                <createCustomerProfileTransactionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
                  <merchantAuthentication>
                    <name>#TRIM(VARIABLES.loginID)#</name>
                    <transactionKey>#TRIM(VARIABLES.transactionKey)#</transactionKey>
                  </merchantAuthentication>
                  <transaction>
                    <profileTransVoid>
                      <customerProfileId>#TRIM(ARGUMENTS.customerProfileId)#</customerProfileId>
                      <customerPaymentProfileId>#TRIM(ARGUMENTS.customerPaymentProfileId)#</customerPaymentProfileId>
                      <transId>#TRIM(ARGUMENTS.transactionID)#</transId>
                    </profileTransVoid>
                  </transaction>
                </createCustomerProfileTransactionRequest>
            </cfxml>
        </cfoutput>

        <cfhttp method="post" url="#variables.CIMprocessingURL#" result="objGet">
            <cfhttpparam type="XML" value="#xmlTransVoid#"/>
        </cfhttp>

		<cfscript>
			// Parse the return value into a ColdFusion XML document. Remove the Byte-Order-Mark (BOM) by stripping all pre-"<" characters. 
			xmlResult = XmlParse(REReplace( objGet.FileContent, "^[^<]*", "", "all" ));
		</cfscript>
		
		<cfreturn xmlResult />
	</cffunction>
        
	<!------------------------------------------------------------------------
		END OF CIM - CUSTOMER MANAGER INFORMATION 
	------------------------------------------------------------------------>


	<!------------------------------------------------------------------------
		Parse Response 
	------------------------------------------------------------------------>

	<cffunction name="parseResponse" access="public" output="false" returntype="Struct">
		<cfargument name="response" displayName="Response" type="string" hint="Transaction Response" required="true" />
		
		<cfscript>
			var stResponse = structNew();
			
			// Following code from the sample file
			numOfDelims = ListLen(response, "|");
			numOfDelims = IncrementValue(numOfDelims);
			newText = Replace(response, "|", " |","ALL");
		</cfscript>
		
		<cfloop index="Element" from="1" to="#numOfDelims#">

			<cfswitch expression = "#Element#">
		
			   <cfcase value = "1">
					<cfscript>
						rc = RTrim(ListFirst(newText, "|"));
						stResponse["responseCode"] = structNew();
						stResponse["responseCode"].element = "Response Code";
				  	
						switch(rc){
								case 1:
									stResponse["responseCode"].response = "Approved";
								break;
								
								case 2:
									stResponse["responseCode"].response = 'Declined';
								break;
								
								case 3:
									stResponse["responseCode"].response = 'Error';
								break;
	
								case 4:
									stResponse["responseCode"].response = 'Held for Review';
								break;
	
								default:
									stResponse["responseCode"].response = 'undefined';
								break;
							} 
				  	
						newList = ListDeleteAt(newText, 1, "|");
				  	</cfscript>
			   </cfcase>
		
			   <cfcase value = "2">
				    <cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						if(nextResp eq '' OR nextResp eq ' '){
							stResponse["responseSubCode"] = structNew();
					  		stResponse["responseSubCode"].element = "Response Subcode";
					  		stResponse["responseSubCode"].response = "No Value Returned";
						}else{
							stResponse["responseSubCode"] = structNew();
					  		stResponse["responseSubCode"].element = "Response Subcode";
					  		stResponse["responseSubCode"].response = nextResp;
						}
						newList = ListDeleteAt(newList, 1, "|");
					</cfscript>
				</cfcase>
	
			   	<cfcase value = "3">
				    <cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["responseReasonCode"] = structNew();
					  	stResponse["responseReasonCode"].element = "Response Reason Code";
					  	stResponse["responseReasonCode"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
					</cfscript>
				</cfcase>
				
				<cfcase value = "4">
				   <cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["responseReasonText"] = structNew();
					  	stResponse["responseReasonText"].element = "Response Reason Text";
					  	stResponse["responseReasonText"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
			   	<cfcase value = "5">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["approvalCode"] = structNew();
					  	stResponse["approvalCode"].element = "Approval Code";
					  	stResponse["approvalCode"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				 	</cfscript>
				</cfcase>
		
			   	<cfcase value = "6">
				   <cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["avsResultCode"] = structNew();
					  	stResponse["avsResultCode"].element = "AVS Result Code";
					  	stResponse["avsResultCode"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   	<cfcase value = "7">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["transactionID"] = structNew();
					  	stResponse["transactionID"].element = "Transaction ID";
					  	stResponse["transactionID"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   	<cfcase value = "8">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["invoiceNumber"] = structNew();
					  	stResponse["invoiceNumber"].element = "Invoice Number";
					  	stResponse["invoiceNumber"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "9">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["description"] = structNew();
					  	stResponse["description"].element = "Description";
					  	stResponse["description"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
					</cfscript>
				</cfcase>
		
			   	<cfcase value = "10">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["amount"] = structNew();
					  	stResponse["amount"].element = "Amount";
					  	stResponse["amount"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   	<cfcase value = "11">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["method"] = structNew();
					  	stResponse["method"].element = "Method";
					  	stResponse["method"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   	<cfcase value = "12">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["transactionType"] = structNew();
					  	stResponse["transactionType"].element = "Transaction Type";
					  	stResponse["transactionType"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   	<cfcase value = "13">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["customerID"] = structNew();
					  	stResponse["customerID"].element = "Customer ID";
					  	stResponse["customerID"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   	<cfcase value = "14">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["cardHolderFirstName"] = structNew();
					  	stResponse["cardHolderFirstName"].element = "Cardholder First Name";
					  	stResponse["cardHolderFirstName"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
			   	</cfcase>
		
			   	<cfcase value = "15">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["cardHolderLastName"] = structNew();
					  	stResponse["cardHolderLastName"].element = "Cardholder Last Name";
					  	stResponse["cardHolderLastName"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   	<cfcase value = "16">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["company"] = structNew();
					  	stResponse["company"].element = "Company";
					  	stResponse["company"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "17">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["address"] = structNew();
					  	stResponse["address"].element = "Address";
					  	stResponse["address"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "18">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["city"] = structNew();
					  	stResponse["city"].element = "City";
					  	stResponse["city"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "19">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["state"] = structNew();
					  	stResponse["state"].element = "State";
					  	stResponse["state"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "20">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["zip"] = structNew();
					  	stResponse["zip"].element = "Zip";
					  	stResponse["zip"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "21">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["country"] = structNew();
					  	stResponse["country"].element = "Country";
					  	stResponse["country"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
				<cfcase value = "22">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["phone"] = structNew();
					  	stResponse["phone"].element = "Phone";
					  	stResponse["phone"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "23">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["fax"] = structNew();
					  	stResponse["fax"].element = "Fax";
					  	stResponse["fax"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "24">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["email"] = structNew();
					  	stResponse["email"].element = "Email";
					  	stResponse["email"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "25">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["shipToFirst"] = structNew();
					  	stResponse["shipToFirst"].element = "Ship-to First";
					  	stResponse["shipToFirst"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
			   
			   <cfcase value = "26">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["shipToLast"] = structNew();
					  	stResponse["shipToLast"].element = "Ship-to Last";
					  	stResponse["shipToLast"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "27">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["shipToCompany"] = structNew();
					  	stResponse["shipToCompany"].element = "Ship-to Company";
					  	stResponse["shipToCompany"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "28">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["shipToAddress"] = structNew();
					  	stResponse["shipToAddress"].element = "Ship-to Address";
					  	stResponse["shipToAddress"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "29">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["shipToCity"] = structNew();
					  	stResponse["shipToCity"].element = "Ship-to City";
					  	stResponse["shipToCity"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
		
				<cfcase value = "30">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["shipToState"] = structNew();
					  	stResponse["shipToState"].element = "Ship-to State";
					  	stResponse["shipToState"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "31">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["shipToZip"] = structNew();
					  	stResponse["shipToZip"].element = "Ship-to ZIP";
					  	stResponse["shipToZip"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "32">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["shipToCountry"] = structNew();
					  	stResponse["shipToCountry"].element = "Ship-to Country";
					  	stResponse["shipToCountry"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "33">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["taxAmount"] = structNew();
					  	stResponse["taxAmount"].element = "Tax Amount";
					  	stResponse["taxAmount"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "34">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["dutyAmount"] = structNew();
					  	stResponse["dutyAmount"].element = "Duty Amount";
					  	stResponse["dutyAmount"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "35">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["freightAmount"] = structNew();
					  	stResponse["freightAmount"].element = "Freight Amount";
					  	stResponse["freightAmount"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "36">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["taxExemptFlag"] = structNew();
					  	stResponse["taxExemptFlag"].element = "Tax Exempt Flag";
					  	stResponse["taxExemptFlag"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "37">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["PoNumber"] = structNew();
					  	stResponse["PoNumber"].element = "PO Number";
					  	stResponse["PoNumber"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "38">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["Md5Hash"] = structNew();
					  	stResponse["Md5Hash"].element = "MD5 Hash";
					  	stResponse["Md5Hash"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "39">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["cardCodeResponse"] = structNew();
					  	stResponse["cardCodeResponse"].element = "Card Code Response";
					  	stResponse["cardCodeResponse"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>

				<cfcase value = "40">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["cardHolderAuthentication"] = structNew();
					  	stResponse["cardHolderAuthentication"].element = "Cardholder Authentication Verification Response";
					  	stResponse["cardHolderAuthentication"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>

				<cfcase value = "51">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["accountNumber"] = structNew();
					  	stResponse["accountNumber"].element = "Account Number";
					  	stResponse["accountNumber"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>

				<cfcase value = "52">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["cardType"] = structNew();
					  	stResponse["cardType"].element = "Card Type";
					  	stResponse["cardType"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfcase>

				<cfdefaultcase>
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						stResponse["MerchantDefinedValue"] = structNew();
					  	stResponse["MerchantDefinedValue"].element = "Merchant defined value";
					  	stResponse["MerchantDefinedValue"].response = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	</cfscript>
				</cfdefaultcase>
		
			</cfswitch>
		
		</cfloop>
		
		<cfreturn stResponse />
	</cffunction>

</cfcomponent>