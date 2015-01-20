<link rel="stylesheet" href="linked/css/buttons.css" type="text/css">


	
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />
    <!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="nsmg.extensions.components.udf" jsclassname="UDFComponent">
    
<style type="text/css">
	
	ul, li {
		margin:0;
		padding:0;
		list-style-type:none;
	}
	#outerContainer {
	width:800px;
	margin-right:auto;
	margin-left:auto;

}
	#container {
	width:400px;
	padding:0px;
	background:#fefefe;
	margin:0 auto;
	border:1px solid #c4cddb;
	border-top-color:#d3dbde;
	border-bottom-color:#bfc9dc;
	box-shadow:0 1px 1px #ccc;
	border-radius:5px;
	position:relative;
}
h1 {
	margin:0;
	padding:10px 0;
	font-size:24px;
	text-align:center;
	background:#eff4f7;
	border-bottom:1px solid #dde0e7;
	box-shadow:0 -1px 0 #fff inset;
	border-radius:5px 5px 0 0; /* otherwise we get some uncut corners with container div */
	text-shadow:1px 1px 0 #fff;
}

form ul li {
	margin:10px 20px;

}
form ul li:last-child {
	text-align:center;
	margin:20px 0 25px 0;

}
.placeholderText {
	padding:10px 10px;
	border:1px solid #d5d9da;
	border-radius:5px;
	box-shadow: 0 0 5px #e8e9eb inset;
	width:328px; /* 400 (#container) - 40 (li margins) -  10 (span paddings) - 20 (input paddings) - 2 (input borders) */
	
	outline:0; /* remove webkit focus styles */
	font-size:16px; color:#333;
}
.placeholderText:focus {
	border:1px solid #b9d4e9;
	border-top-color:#b6d5ea;
	border-bottom-color:#b8d4ea;
	box-shadow:0 0 5px #b9d4e9;
}
select {
	padding:10px 10px;
	border:1px solid #d5d9da;
	border-radius:5px;
	box-shadow: 0 0 5px #e8e9eb inset;
	width:328px; /* 400 (#container) - 40 (li margins) -  10 (span paddings) - 20 (input paddings) - 2 (input borders) */
	
	outline:0; /* remove webkit focus styles */
	font-size:16px; color:#333;
}
select:focus {
	border:1px solid #b9d4e9;
	border-top-color:#b6d5ea;
	border-bottom-color:#b8d4ea;
	box-shadow:0 0 5px #b9d4e9;
}
label {
	color:#555;
}
#container span {
	background:#f6f6f6;
	padding:3px 5px;
	display:block;
	border-radius:5px;
	margin-top:5px;
}

button {
	background: #57a9eb; /* Old browsers */
	background: -moz-linear-gradient(top, #57a9eb 0%, #3a76c4 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#57a9eb), color-stop(100%,#3a76c4)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #57a9eb 0%,#3a76c4 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #57a9eb 0%,#3a76c4 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top, #57a9eb 0%,#3a76c4 100%); /* IE10+ */
	background: linear-gradient(top, #57a9eb 0%,#3a76c4 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#57a9eb', endColorstr='#3a76c4',GradientType=0 ); /* IE6-9 */
	border:1px solid #326fa9;
	border-top-color:#3e80b1;
	border-bottom-color:#1e549d;
	color:#fff;
	text-shadow:0 1px 0 #1e3c5e;
	font-size:.875em;
	padding:8px 15px;
	width:150px;
	border-radius:20px;
	box-shadow:0 1px 0 #bbb, 0 1px 0 #9cccf3 inset;
}
button:active {
	background: #3a76c4; /* Old browsers */
	background: -moz-linear-gradient(top, #3a76c4 0%, #57a9eb 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#3a76c4), color-stop(100%,#57a9eb)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #3a76c4 0%,#57a9eb 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #3a76c4 0%,#57a9eb 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top, #3a76c4 0%,#57a9eb 100%); /* IE10+ */
	background: linear-gradient(top, #3a76c4 0%,#57a9eb 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#3a76c4', endColorstr='#57a9eb',GradientType=0 ); /* IE6-9 */
	box-shadow:none;
	text-shadow:0 -1px 0 #1e3c5e;
}

#pswd_info {
	position:absolute;
	bottom:220px;
	bottom: -115px\9; /* IE Specific */
	right:55px;
	width:250px;
	padding:15px;
	background:#fefefe;
	font-size:.875em;
	border-radius:5px;
	box-shadow:0 1px 3px #ccc;
	border:1px solid #ddd;
}

#pswd_info h4 {
	margin:0 0 10px 0;
	padding:0;
	font-weight:normal;
}

#pswd_info::before {
	content: "\25BC";
	position:absolute;
	bottom:-16px;
	left:45%;
	font-size:14px;
	line-height:14px;
	color:#ddd;
	text-shadow:none;
	display:block;
}

.invalid {
	background:url(pics/invalid.png) no-repeat 0 50%;
	padding-left:22px;
	line-height:24px;
	color:#ec3f41;
}
.valid {
	background:url(pics/valid.png) no-repeat 0 50%;
	padding-left:22px;
	line-height:24px;
	color:#3a7d34;
}

#pswd_info {
	display:none;
}

.descriptiveText {	
	font-size:16px;
	float:right;
	display:block;
	margin-top:10px;
	
	
}	
.descriptiveText p {
	margin:20px;	
	font-size:16px;
	
}	
.descriptiveText ol {
	margin:10px;	
	font-size:16px;
	background-color:#fff;	
}	


</style>
<cfscript>
	
		
		//Random Password for account, if needed
		strPassword = APPLICATION.CFC.UDF.randomPassword(length=8);
		
		
		
		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();

		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=CLIENT.usertype);
		
		// Get Current User Information
		qGetUserComplianceInfo = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);
		

	</cfscript>


    <cfparam name="FORM.familyLastName" default="">
    <cfparam name="FORM.fatherLastName" default="">
    <cfparam name="FORM.fatherFirstName" default="">
    <cfparam name="FORM.fatherMiddleName" default="">
    <cfparam name="FORM.fatherBirth" default="0">
    <cfparam name="FORM.fatherDOB" default="">
    <cfparam name="FORM.fatherSSN" default="">
    <cfparam name="FORM.fatherWorkType" default="">
    <cfparam name="FORM.father_cell" default="">
    <cfparam name="FORM.motherFirstName" default="">
    <cfparam name="FORM.motherLastName" default="">
    <cfparam name="FORM.motherMiddleName" default="">
    <cfparam name="FORM.motherBirth" default="0">
    <cfparam name="FORM.motherDOB" default="">
    <cfparam name="FORM.motherSSN" default="">
    <cfparam name="FORM.motherWorkType" default="">
    <cfparam name="FORM.mother_cell" default="">
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.companyid" default="">
    <cfparam name="FORM.regionid" default="">
    <cfparam name="FORM.arearepid" default="">
    <cfparam name="FORM.submit_Start" default="">
    <cfparam name="currentHost" default="0">
    <cfparam name="FORM.zipLookup" default="">
 <script src="linked/js/jquery.validateAccountInfo.js"></script>
 
 <script type="text/JavaScript">
	<!--
	// Set cursor to Family Name field	
	$(document).ready(function() {
		$("#familyLastName").focus();
	});

	var copyFamilyLastName = function() { 
		$("#fatherLastName").val( $("#familyLastName").val() );
		$("#motherLastName").val( $("#familyLastName").val() );
	}

	// Jquery Masks 
	jQuery(function($){
	   	// Phone Number
	   	$("#phone").mask("(999) 999-9999");
	   	$("#father_cell").mask("(999) 999-9999");
	   	$("#mother_cell").mask("(999) 999-9999");
	   	// DOB
	   	$("#fatherDOB").mask("99/99/9999");
	   	$("#motherDOB").mask("99/99/9999");
		// SSN
	   	$("#fatherSSN").mask("***-**-9999");
	   	$("#motherSSN").mask("***-**-9999");
	});
	
	// Function to find the index in an array of the first entry with a specific value. 
	// It is used to get the index of a column in the column list. 
	Array.prototype.findIdx = function(value){ 
		for (var i=0; i < this.length; i++) { 
			if (this[i] == value) { 
				return i; 
			} 
		} 
	} 

	// Create an instance of the proxy. 
	var udf = new UDFComponent();
	
	// Get the submit type
	var submitType = "";

	// Use an asynchronous call to get the student details. The function is called when the user selects a student. 
	function verifyAddress(selectedSubmitType) { 
		// Check required Fields
		submitType = selectedSubmitType;
		var errorMessage = "";
		if($("#address").val() == ''){
			errorMessage = (errorMessage + 'Please enter the Address. \n')
		}
		if($("#city").val() == ''){
			errorMessage = (errorMessage + 'Please enter the City. \n')
		}
		if($("#state").val() == ''){
			errorMessage = (errorMessage + 'Please select the State. \n')
		}
		if($("#zip").val() == ''){
			errorMessage = (errorMessage + 'Please enter the Zip. \n')
		}
		if (errorMessage == "") {
			// FORM Variables
			var address = $("#address").val();
			var city = $("#city").val();
			var state = $("#state").val();
			var zip = $("#zip").val();
			
			// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous.
			udf.setCallbackHandler(checkAddress);
			udf.setErrorHandler(myErrorHandler); 
			udf.addressLookup(address,city,state,zip,"232");
		}
	} 

	// Callback function to handle the results returned by the getHostLeadList function and populate the table. 
	var checkAddress = function(googleResponse) { 

		var isAddressVerified = googleResponse.ISVERIFIED;
		var inputState = googleResponse.INPUTSTATE;

		if ( isAddressVerified == 1 ) {

			// Get Data Back	
			var streetAddress = googleResponse.ADDRESS;
			var city = googleResponse.CITY;
			var state = googleResponse.STATE;
			var zip = googleResponse.ZIP;
			zip = zip.substring('zip='.length);
			var verifiedStateID = googleResponse.VERIFIEDSTATEID;
			
			if ((streetAddress == $("#address").val()) && (city == $("#city").val()) && (state == $("#state").val()) && (zip == $("#zip").val()))
			{
				$("#" + submitType).removeAttr("onClick");
				$("#" + submitType).click();
			} else {
				$(function() {
					$( "#dialog:ui-dialog" ).dialog( "destroy" );
					$( "#dialog-approveAddress-confirm" ).empty();
					$( "#dialog-approveAddress-confirm" ).append(
						"<table width='100%'>" +
							"<tr width='100%'><td width='50%'>Verified Address:</td><td width='50%'>Input Address:</td></tr>" +
							"<tr><td>" + streetAddress + "</td><td>" + $("#address").val() + "</td></tr>" +
							"<tr><td>" + city + ", " + state + " " + zip + "</td><td>" + $("#city").val() + ", " + $("#state").val() + " " + $("#zip").val() + "</td></tr>" +
						"</table>");
					$( "#dialog-approveAddress-confirm").dialog({
						resizable: false,
						height:230,
						width:400,
						modal: true,
						buttons: {
							"Use verified": function() {
								$( this ).dialog( "close" );
								$("#address").val(streetAddress);
								$("#city").val(city);
								$("#state").val(state);
								$("#zip").val(zip);
								$("#" + submitType).removeAttr("onClick");
								$("#" + submitType).click();
							},
							"Use input": function() {
								$( this ).dialog( "close" );
								$("#" + submitType).removeAttr("onClick");
								$("#" + submitType).click();
							},
							"Go back": function() {
								$( this ).dialog( "close" );
							}
						}
					});
				});
			}
		} else {
			$(function() {
				$( "#dialog:ui-dialog" ).dialog( "destroy" );
				$( "#dialog-canNotVerify-confirm" ).empty();
				$( "#dialog-canNotVerify-confirm" ).append("We could not verify the following address:<br />" + $("#address").val() + "<br />" + $("#city").val() + ", " + $("#state").val() + " " + $("#zip").val());
				$( "#dialog-canNotVerify-confirm").dialog({
					resizable: false,
					height:230,
					width:400,
					modal: true,
					buttons: {
						"Use anyway": function() {
							$( this ).dialog( "close" );
							$("#" + submitType).removeAttr("onClick");
							$("#" + submitType).click();
						},
						"Go back": function() {
							$( this ).dialog( "close" );
						}
					}
				});
			});
		}	
	}
	
	var getLocationByZip = function() {
		
		var zip = $("#zipLookup").val();

		if (zip.length == 5) {
			udf.setCallbackHandler(checkZip); 
			udf.setErrorHandler(myErrorHandler); 
			udf.zipCodeLookUp(zip);
		} else {
			alert("Please verify your zip code 4");
		}
	} 

	// Callback function to handle the results returned by the getHostLeadList function and populate the table. 
	var checkZip = function(googleResponse) { 

		var isAddressVerified = googleResponse.ISVERIFIED;

		if ( isAddressVerified == 1 ) {	
			var city = googleResponse.CITY;
			var state = googleResponse.STATE;
			
			$("#city").val(city);
			$("#state").val(state);
			$("#zip").val($("#zipLookup").val());
			$("#zipLookupRow").html("");
		} else {
			alert("Please verify your zip code");
		}

	}

	// Error handler for the asynchronous functions. 
	var myErrorHandler = function(statusCode, statusMsg) { 
		alert('Status: ' + statusCode + ', ' + statusMsg); 
	}
	//-->
</script>
<!--- Modal Dialogs --->
        
    <!--- Approve Address - Modal Dialog Box --->
    <div id="dialog-approveAddress-confirm" title="Which address would you like to use?" class="displayNone"> 
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span></p>  
    </div>
    
    <!--- Can Not Verify Address - Modal Dialog Box --->
    <div id="dialog-canNotVerify-confirm" title="We could not verify this address." class="displayNone"> 
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span></p> 
    </div>

	<!--- address lookup turned on. --->
    <cfif VAL(APPLICATION.address_lookup)>
        <cfinclude template="../includes/address_lookup_#APPLICATION.address_lookup#.cfm">
    </cfif>
    
    
  <cfoutput>
  <div id="outerContainer">
   	<!--- Form Errors --->
        <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="onlineApplication"
        />
        
        
		<div style="width:49%;float:left;display:block;margin-top:10px">
                <div id="container">
                <h1>Add New Host Family</h1>
                <form action="">
               
            <table div align="center">
                <Tr>
                    <td><label for="username">Family Last Name</label></td>
                </Tr>
                <tr>
                    <td><span><input id="email" name="familyLastName" type="text"  value="#form.familyLastName#" class="placeholderText" /></span></td>
                </tr>
                <Tr>
                    <td><label for="username">Address</label></td>
                </Tr>
                <tr>
                    <td><span><input id="address" name="address" type="text" placeholder="123 Main" value="#form.address#" class="placeholderText" /><br /> <input id="address" name="address2" type="text" placeholder="Apt 104" value="#form.address2#" class="placeholderText" /></span></td>
                </tr>
                <Tr>
                    <td><label for="username">City</label></td>
                </Tr>
                <tr>
                    <td><span><input id="email" name="city" type="text" placeholder="123 Main" value="#form.city#" class="placeholderText" /></span></td>
                </tr>
              
                <Tr >
                    <td><label for="username">State</label></td>
                </Tr>
                <tr>
                    <td><span> <select style="width:350px;" name="state">
               
                    <option value=""></option>
                <Cfloop query="qGetStateList">
                    <option value="#qGetStateList.state#" <cfif FORM.state EQ qGetStateList.state> selected="selected" </cfif>>#qGetStateList.stateName#</option>
                </Cfloop>
                    
                </select></span></td>
                </tr>
                
                 <Tr>
                    <td><label for="username">Zip</label></td>
                </Tr>
                  <tr id="zipLookup">
                    <td><span>
                    <input type="text" name="zipLookup" id="zipLookup" value="#FORM.zipLookup#" class="placeholderText" maxlength="5" onblur="getLocationByZip()">
                 </span></td>
                </tr>
                 
                  
                <tr> 
                	<Td align="Center"> <button type="submit">Validate</button></Td>
            </table>
                    
                 <cfif form.zip is ''> style="display: none;"</cfif>
     
                   
                   
                    
                </form>
                
                <div id="pswd_info">
                    <h4>Password must meet the following requirements:</h4>
                    <ul>
                        <li id="letter" class="invalid">At least <strong>one letter</strong></li>
                        <li id="number" class="invalid">At least <strong>one number</strong></li>
                        <li id="length" class="invalid">Be at least <strong>8 characters</strong></li>
                    </ul>
                </div>
                </div>
              </div>
   
                    <!--- ------------------------------------------------------------------------- ---->
	<!---- Right Column---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
  <div class="descriptiveText" style="width:46%;background-color:##eff4f7;float:right;display:block;">
   
   <p>To increase account access security and to ensure that we are in compliance with Dept. of State regulations, we have implemented a continuing account verification tool.</p>
  <p>From time to time, you will be asked to submit certain information on your account to make sure that we have current and accurate information on everyone who is accessing EXITS and help ensure the safety of our students, host families, and users.</p>
  <p>Along with verifying information on your account, account passwords must now meet minimum requirements:
  	
    <ol>
    	<li>  They need to be 8 characters long</li>
        <li>  Must contain at least 1 letter</li>
        <li>  Must contain at least 1 number</li>
    </ol>
   
    </p>
  <p>Once the form at the left is succesfully submited, you will immediatly have full account access.</p>
  
  </div>
</div>                 
    </cfoutput>              
