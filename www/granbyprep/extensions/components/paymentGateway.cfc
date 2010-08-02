<!--- ------------------------------------------------------------------------- ----
	
	File:		paymentGateway.cfc
	Author:		Marcus Melo
	Date:		July 21, 2010
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
				// The merchant's unique API login ID
				VARIABLES.loginID = '2E3jsfH7L5F'; 
				// The merchant's unique transaction key
				VARIABLES.transactionKey = '979cxZC5g8dDRf9b';
			} else {
				// Production Environment	
				VARIABLES.processingURL = 'https://secure.authorize.net/gateway/transact.dll';
				// The merchant's unique API login ID
				VARIABLES.loginID = '7F9y6gHP'; 
				// The merchant's unique transaction key
				VARIABLES.transactionKey = '4359fXD8z58SDvrm';
			}

			// Return this initialized instance
			return(this);
		</cfscript>
        
	</cffunction>


	<!--- Insert Payment Information --->
	<cffunction name="insertApplicationPayment" access="public" returntype="numeric" output="false" hint="Inserts a new payment information. Returns paymentID.">
        <cfargument name="applicationID" required="yes" hint="applicationID is required" />		
        <cfargument name="sessionInformationID" required="yes" hint="SESSION.informationID is required" />		
		<cfargument name="foreignTable" required="yes" hint="foreignTable is required" />
		<cfargument name="foreignID" required="yes" hint="foreignID is required" />
		<cfargument name="amount" required="yes" hint="foreignID is required" />
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
			datasource="#APPLICATION.DSN.Source#">
				INSERT INTO
					applicationPayment
				(                    
					applicationID,
					sessionInformationID,
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
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationID#">,	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.sessionInformationID#">,                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">,                    
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.foreignID#">,  
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
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.billingCountryID#">,
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
        <cfargument name="authIsSuccess" default="0" hint="authIsSuccess is not required" />

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	applicationPayment
                SET  
                    authTransactionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.authTransactionID#">,
                    authApprovalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.authApprovalCode#">,
                    authResponseCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.authResponseCode#">,
                    authResponseReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.authResponseReason#">,
                    authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.authIsSuccess)#">
                WHERE
                	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
	</cffunction>


	<!--- Get Payment Information --->
	<cffunction name="getApplicationPaymentByID" access="public" returntype="query" output="false" hint="Gets a payment information.">
        <cfargument name="ID" required="yes" hint="ID is required" />		

		<cfquery 
            name="qGetApplicationPaymentByID"
			datasource="#APPLICATION.DSN.Source#">
				SELECT  
                	ID,             
					applicationID,
					sessionInformationID,
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
                	applicationPayment
                WHERE
                	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
		<cfreturn qGetApplicationPaymentByID />
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
			<cfhttpparam name="x_header_email_receipt" type="formfield" value="#APPLICATION.SCHOOL.NAME#">
			<cfhttpparam name="x_footer_email_receipt" type="formfield" value="#APPLICATION.CFC.UDF.getschooladdress()#">
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


    <!--- Parse Response --->
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