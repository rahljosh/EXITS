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

	<cffunction name="init" displayname="Init" hint="Sets up variables" access="public" output="false" returntype="void">
		<cfargument name="tranKeyTesting" displayName="Transact key (testing)" type="string" hint="Transaction Key (testing)" required="true" />
		<cfargument name="loginTesting" displayName="Login (testing)" type="string" hint="API Login (testing)" required="true" />
		<cfargument name="tranKey" displayName="Transact key" type="string" hint="Transaction Key" required="true" />
		<cfargument name="login" displayName="Login" type="string" hint="API Login" required="true" />
		
		<cfif ARGUMENTS.environment neq "testing" and ARGUMENTS.environment neq "live">
			<cfthrow type="payment.authorizeNet.initialize" message="Invalid Environment Assignment" detail="Valid environment variables are Testing or Live">
		</cfif>
		
		<cfif len(ARGUMENTS.login) gt 20>
			<cfthrow type="payment.authorizeNet.authorizeAndCapture" message="Invalid Login ID" detail="Login ids can be up to 20 character in length.  Provided login is #len(ARGUMENTS.login)# characters">
		</cfif>
		
		<cfif len(ARGUMENTS.tran_key) gt 16>
			<cfthrow type="payment.authorizeNet.authorizeAndCapture" message="Invalid Transaction Key" detail="Transaction keys can be up to 16 character in length.  Provided key is #len(ARGUMENTS.login)# characters">
		</cfif>
		
		<cfscript>
			if ( APPLICATION.isServerLocal ) {
				// Local Environment
				VARIABLES.processing_url = 'https://test.authorize.net/gateway/transact.dll';				
				VARIABLES.tran_key = ARGUMENTS.tranKeyTesting;
				VARIABLES.login = ARGUMENTS.loginTesting;
			} else {
				// Production Environment	
				VARIABLES.processing_url = 'https://secure.authorize.net/gateway/transact.dll';	
				VARIABLES.tran_key = ARGUMENTS.tranKey;
				VARIABLES.login = ARGUMENTS.login;
			}
		</cfscript>
	</cffunction>


	<!--- Authorize and Capture --->
	<cffunction name="authorizeAndCapture" displayname="Authorize and Capture" hint="Bills credit card Immediately" access="public" output="false" returntype="Struct">
		<cfargument name="amount" displayName="Amount" type="string" hint="Transaction Amount" required="true" />
		<cfargument name="cardNum" displayName="Card Number" type="string" hint="Customers Credit Card Number" required="true" />
		<cfargument name="expDate" displayName="Expiration Date" type="string" hint="Customers Credit Card Expiration Date" required="true" />
		<cfargument name="studentID" displayName="Student ID" type="string" hint="Student ID" required="true" />
        		
		<cfif find("$",ARGUMENTS.amount) OR find(",",ARGUMENTS.amount)>
			<cfthrow type="payment.authorizeNet.authorizeAndCapture" message="Invalid Amount" detail="The amount to be charged to the credit card can not have dollar signs ($) or Commas (,) in it. Only numbers and a1 decimal place">
		</cfif>
		
		<cfhttp method="post" url="#variables.processing_url#">
	
			<cfhttpparam name="x_login" type="formfield" value="#ARGUMENTS.login#">
			<cfhttpparam name="x_tran_key" type="formfield" value="#ARGUMENTS.tran_key#">
			<cfhttpparam name="x_method" type="formfield" value="CC">
			<cfhttpparam name="x_type" type="formfield" value="AUTH_CAPTURE">
			<cfhttpparam name="x_amount" type="formfield" value="#ARGUMENTS.amount#">
			<cfhttpparam name="x_delim_data" type="formfield" value="TRUE">
			<cfhttpparam name="x_delim_char" type="formfield" value="|">
			<cfhttpparam name="x_relay_response" type="formfield" value="FALSE">
			<cfhttpparam name="x_card_num" type="formfield" value="#ARGUMENTS.card_num#">
			<cfhttpparam name="x_exp_date" type="formfield" value="#ARGUMENTS.exp_date#">
			<cfhttpparam name="x_invoice_num" type="formfield" value="#ARGUMENTS.order_number#">
                        
		</cfhttp>

		<cfreturn parseResponse(cfhttp.filecontent)/>
	</cffunction>


    <!--- Parse Response --->
	<cffunction name="parseResponse" access="public" output="false" returntype="Struct">
		<cfargument name="response" displayName="Response" type="string" hint="Transaction Response" required="true" />
		
		<cfscript>
			var stResponse = structNew();
		</cfscript>
		
		<!--- Following code from the sample file--->
		<cfset numOfDelims = ListLen(response, "|")>
		<cfset numOfDelims = IncrementValue(numOfDelims)>
		<cfset newText = Replace(response, "|", " |","ALL")>

		<cfloop index="Element" from="1" to="#numOfDelims#">

			<cfswitch expression = "#Element#">
		
			   <cfcase value = "1">
				  <cfscript>
					rc = RTrim(ListFirst(newText, "|"));
				  	stResponse["Response_Code"] = structNew();
				  	stResponse["Response_Code"].element = "Response Code";
				  	
				  	
				  	switch(rc){
					  		case 1:
					  			stResponse["Response_Code"].response = "Approved";
					  		break;
					  		
					  		case 2:
					  			stResponse["Response_Code"].response = 'Declined';
					  		break;
					  		
					  		case 3:
					  			stResponse["Response_Code"].response = 'Error';
					  		break;
					  		
					  		default:
					  			stResponse["Response_Code"].response = 'undefined';
					  		break;
					  	} 
				  	
				  	newList = ListDeleteAt(newText, 1, "|");
				  	
				  </cfscript>
			   </cfcase>
		
			   <cfcase value = "2">
				    <cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						if(nextResp eq '' OR nextResp eq ' '){
							stResponse["Response_SubCode"] = structNew();
					  		stResponse["Response_SubCode"].element = "Response Subcode";
					  		stResponse["Response_SubCode"].response = "No Value Returned";
						}else{
							stResponse["Response_SubCode"] = structNew();
					  		stResponse["Response_SubCode"].element = "Response Subcode";
					  		stResponse["Response_SubCode"].response = nextResp;
						}
						
						newList = ListDeleteAt(newList, 1, "|");
					  	
					  </cfscript>
				</cfcase>
	
			   <cfcase value = "3">
				    <cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["Response_Reason_code"] = structNew();
					  	stResponse["Response_Reason_code"].element = "Response Reason Code";
					  	stResponse["Response_Reason_code"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
					  	
					  </cfscript>
				</cfcase>
				
				<cfcase value = "4">
				   <cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["response_reason_text"] = structNew();
					  	stResponse["response_reason_text"].element = "Response Reason Text";
					  	stResponse["response_reason_text"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  </cfscript>
				</cfcase>
				
			   <cfcase value = "5">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["approval_code"] = structNew();
					  	stResponse["approval_code"].element = "Approval Code";
					  	stResponse["approval_code"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  </cfscript>
				</cfcase>
		
			   <cfcase value = "6">
				   <cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["avs_result_code"] = structNew();
					  	stResponse["avs_result_code"].element = "AVS Result Code";
					  	stResponse["avs_result_code"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  </cfscript>
				</cfcase>
		
		
		
			   <cfcase value = "7">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["transaction_id"] = structNew();
					  	stResponse["transaction_id"].element = "Transaction ID";
					  	stResponse["transaction_id"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  </cfscript>
				</cfcase>
		
			   <cfcase value = "8">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["invoice_number"] = structNew();
					  	stResponse["invoice_number"].element = "Invoice Number";
					  	stResponse["invoice_number"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  </cfscript>
				</cfcase>
		
			   <cfcase value = "9">
				<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["description"] = structNew();
					  	stResponse["description"].element = "Description";
					  	stResponse["description"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  </cfscript>
				</cfcase>
		
			   <cfcase value = "10">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["amount"] = structNew();
					  	stResponse["amount"].element = "Amount";
					  	stResponse["amount"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "11">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["method"] = structNew();
					  	stResponse["method"].element = "Method";
					  	stResponse["method"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "12">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["transaction_type"] = structNew();
					  	stResponse["transaction_type"].element = "Transaction Type";
					  	stResponse["transaction_type"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "13">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["Customer_id"] = structNew();
					  	stResponse["Customer_id"].element = "Customer ID";
					  	stResponse["Customer_id"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "14">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["cardholder_firstname"] = structNew();
					  	stResponse["cardholder_firstname"].element = "Cardholder Firstname";
					  	stResponse["cardholder_firstname"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
			   </cfcase>
		
			   <cfcase value = "15">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["cardholder_lastname"] = structNew();
					  	stResponse["cardholder_lastname"].element = "Cardholder Lastname";
					  	stResponse["cardholder_lastname"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "16">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["company"] = structNew();
					  	stResponse["company"].element = "Company";
					  	stResponse["company"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "17">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["company"] = structNew();
					  	stResponse["company"].element = "Company";
					  	stResponse["company"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "18">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["city"] = structNew();
					  	stResponse["city"].element = "City";
					  	stResponse["city"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "19">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["state"] = structNew();
					  	stResponse["state"].element = "State";
					  	stResponse["state"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "20">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["zip"] = structNew();
					  	stResponse["zip"].element = "Zip";
					  	stResponse["zip"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "21">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["country"] = structNew();
					  	stResponse["country"].element = "Country";
					  	stResponse["country"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
		
				<cfcase value = "22">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["phone"] = structNew();
					  	stResponse["phone"].element = "Phone";
					  	stResponse["phone"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "23">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["fax"] = structNew();
					  	stResponse["fax"].element = "Fax";
					  	stResponse["fax"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "24">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["email"] = structNew();
					  	stResponse["email"].element = "Email";
					  	stResponse["email"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "25">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["ship_to_first_name"] = structNew();
					  	stResponse["ship_to_first_name"].element = "Ship-to First Name";
					  	stResponse["ship_to_first_name"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
			   
			   <cfcase value = "26">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["ship_to_last_name"] = structNew();
					  	stResponse["ship_to_last_name"].element = "Ship-to Last Name";
					  	stResponse["ship_to_last_name"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "27">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["ship_to_Company_name"] = structNew();
					  	stResponse["ship_to_Company_name"].element = "Ship-to Company Name";
					  	stResponse["ship_to_Company_name"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
		
			   <cfcase value = "28">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["ship_to_Address_name"] = structNew();
					  	stResponse["ship_to_Address_name"].element = "Ship-to Address Name";
					  	stResponse["ship_to_Address_name"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "29">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["ship_to_City_name"] = structNew();
					  	stResponse["ship_to_City_name"].element = "Ship-to City Name";
					  	stResponse["ship_to_City_name"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
		
		
				<cfcase value = "30">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["ship_to_State_name"] = structNew();
					  	stResponse["ship_to_State_name"].element = "Ship-to State Name";
					  	stResponse["ship_to_State_name"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "31">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["ship_to_ZIP_name"] = structNew();
					  	stResponse["ship_to_ZIP_name"].element = "Ship-to ZIP Name";
					  	stResponse["ship_to_ZIP_name"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "32">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["ship_to_Country_name"] = structNew();
					  	stResponse["ship_to_Country_name"].element = "Ship-to Country Name";
					  	stResponse["ship_to_Country_name"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "33">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["Tax_Amount"] = structNew();
					  	stResponse["Tax_Amount"].element = "Tax Amount";
					  	stResponse["Tax_Amount"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "34">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["Duty_Amount"] = structNew();
					  	stResponse["Duty_Amount"].element = "Duty Amount";
					  	stResponse["Duty_Amount"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "35">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["Freight_Amount"] = structNew();
					  	stResponse["Freight_Amount"].element = "Freight Amount";
					  	stResponse["Freight_Amount"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "36">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["Tax_Exempt_Flag"] = structNew();
					  	stResponse["Tax_Exempt_Flag"].element = "Tax Exempt Flag";
					  	stResponse["Tax_Exempt_Flag"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "37">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["PO_Number"] = structNew();
					  	stResponse["PO_Number"].element = "PO Number";
					  	stResponse["PO_Number"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "38">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["MD5_Hash"] = structNew();
					  	stResponse["MD5_Hash"].element = "MD5 Hash";
					  	stResponse["MD5_Hash"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
				
				<cfcase value = "39">
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["Card_Code_Response"] = structNew();
					  	stResponse["Card_Code_Response"].element = "Card Code Response";
					  	stResponse["Card_Code_Response"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfcase>
                
				<cfdefaultcase>
					<cfscript>
					    nextResp = RTrim(ListFirst(newList, "|"));
						
						stResponse["Merchant_defined_value"] = structNew();
					  	stResponse["Merchant_defined_value"].element = "Merchant defined value";
					  	stResponse["Merchant_defined_value"].element = nextResp;	
						newList = ListDeleteAt(newList, 1, "|");
				  	
				  	</cfscript>
				</cfdefaultcase>
		
			</cfswitch>
		
		</cfloop>
		
		<cfreturn stResponse />
	</cffunction>

</cfcomponent>