<!--- ------------------------------------------------------------------------- ----
	
	File:		displayRepAgreement.cfm
	Author:		Josh Rahl
	Date:		Sept 9, 2011
	Desc:		Services Agreement Contract

	NOTE:  The value of season needs to be updated to the season of the agreement.

----- ------------------------------------------------------------------------- --->
<title>CBC Authorization</title>
<style type="text/css">
div.scroll {
	height: 400px;
	width:auto;
	overflow:auto;
	left:auto;
	padding: 8px;
	border-top-width: thin;
	border-right-width: 2px;
	border-bottom-width: thin;
	border-left-width: 2px;
	border-top-style: inset;
	border-right-style: solid;
	border-bottom-style: outset;
	border-left-style: solid;
	border-top-color: #efefef;
	border-right-color: #c6c6c6;
	border-bottom-color: #efefef;
	border-left-color: #c6c6c6;
}
.greyHeader{
	width:590px;
	background-color:#CCC;
	padding:5px;
	text-align: center;
}
.lightGrey{
	width:590px;
	background-color:#EFEFEF;
	padding:5px;
	text-align: left;
}
.wrapper {
	padding: 8px;
	width: 600px;
	margin-right: auto;
	margin-left: auto;
	border: thin solid #CCC;
}
body {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #000;
}
.clearfix {
	display: block;
	height: 12px;
}
.italic {
	font-size: 11px;
	font-style: italic;
}
</style>
 <link rel="stylesheet" media="all" type="text/css"href="../linked/css/baseStyle.css" />
 <Cfset season = 9>
 <cfscript>
// Get User Info
		qGetUserInfo = APPLICATION.CFC.USER.getUserByID(userID=client.userID);
		ORIGSSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetUserInfo.SSN, displayType='user');
		 // This will set if SSN needs to be updated
		vUpdateUserSSN = 0;
</cfscript>

 	<cfparam name="form.termsagree" default="">
	<cfparam name="form.address" default="#qGetUserInfo.address#">
    <cfparam name="form.address2" default="#qGetUserInfo.address2#">
    <cfparam name="form.city" default="#qGetUserInfo.city#">
    <cfparam name="form.state" default="#qGetUserInfo.state#">
    <cfparam name="form.zip" default="#qGetUserInfo.zip#">
    <cfparam name="form.previous_address" default="#qGetUserInfo.previous_address#">
    <cfparam name="form.previous_address2" default="#qGetUserInfo.previous_address2#">
    <cfparam name="form.previous_city" default="#qGetUserInfo.previous_city#">
    <cfparam name="form.previous_state" default="#qGetUserInfo.previous_state#">
    <cfparam name="form.previous_zip" default="#qGetUserInfo.previous_zip#">
	<cfparam name="form.dob" default="#qGetUserInfo.dob#">
    <cfparam name="form.ssn" default="#ORIGSSN#">


</head>

<body onLoad="opener.location.reload()">

	<cfsilent>
		<!--- Import CustomTag Used for Page Messages and Form Errors --->
        <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	</cfsilent>


<Cfif isDefined('form.sign')>
	<Cfset expectedSig = '#trim(qGetUserInfo.firstname)# #trim(qGetUserInfo.lastname)#'>
    <Cfif #trim(form.Signature)# is #trim(expectedSig)#>
    	<Cfset sigMatch = 0>
    <cfelse>
    	<cfset sigMatch = 1>
    </Cfif>
	<cfscript>
			// Data Validation - Current Address
			if (sigMatch is 1 and LEN(FORM.signature)  )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Your signed name #form.signature# does not match the name on file #expectedSig#");
			}
			if ( NOT LEN(FORM.address) ) {
				SESSION.formErrors.Add("Please enter your current address.");
			}

			if ( NOT LEN(FORM.city) ) {
				SESSION.formErrors.Add("Please enter your current city.");
			}
			if ( NOT LEN(FORM.state) ) {
				SESSION.formErrors.Add("Please enter your current state.");
			}

			if ( NOT LEN(FORM.zip) ) {
				SESSION.formErrors.Add("Please enter your current zip.");
			}
	

			if ( LEN(FORM.DOB) AND NOT IsDate(FORM.DOB) ) {
				FORM.DOB = '';
				SESSION.formErrors.Add("Please enter a valid Date of Birth.");				
            }    
			
			if ( LEN(FORM.SSN) AND Left(FORM.SSN, 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM.SSN)) ) {
				SESSION.formErrors.Add("Please enter a valid SSN.");
            }    
				
			// signature
            if (not len(trim(FORM.signature)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please sign your name");
			}
			// agree
            if (not val(FORM.termsAgree) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please check the box indicating you agree to the terms.");
			}

		</cfscript>
     
 	

	<!--- Check if there are no errors --->
    <cfif NOT SESSION.formErrors.length()>
      <cfscript>
                // Father SSN - Will update if it's blank or there is a new number
                if ( isValid("social_security_number", Trim(FORM.SSN)) ) {
                    // Encrypt Social
                    FORM.SSN = APPLICATION.CFC.UDF.encryptVariable(FORM.SSN);
                    // Update
                    vUpdateUserSSN = 1;
                } else if ( NOT LEN(FORM.SSN) ) {
                    // Update - Erase SSN
                    vUpdateUserSSN = 1;
                }
            </cfscript>
          <cfquery name="progManager" datasource="#application.dsn#">
          select pm_email
          from smg_companies
          where companyid = #client.companyid#
          </cfquery>
   	 	<cfquery name="updateUsers" datasource="#application.dsn#">
        update smg_users
        	set address = '#form.address#',
              	address2 = '#form.address2#',
                city = '#form.city#',
                state = '#form.state#',
                zip = '#form.zip#',
                previous_address = '#form.previous_address#',
              	previous_address2 = '#form.previous_address2#',
                previous_city = '#form.previous_city#',
                previous_state = '#form.previous_state#',
                previous_zip = '#form.previous_zip#',
				 <cfif VAL(vUpdateUserSSN)>
                    SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SSN#">,
                </cfif>
                dob = #CreateODBCDate(form.dob)#
           where userid = #client.userid#
        </cfquery>
        <cfquery name="checkSeason" datasource="#application.dsn#">
        select *
        from smg_users_paperwork
        where seasonid = #season#
        and userid = #client.userid# 
            <Cfif client.companyid gt 5>
            and fk_companyid = #client.companyid#
            </Cfif>
        </cfquery>
		<cfif DirectoryExists('C:/websites/student-management/nsmg/uploadedfiles/users/#client.userid#/')>
        <cfelse>
            <cfdirectory action = "create" directory = "C:/websites/student-management/nsmg/uploadedfiles/users/#client.userid#/" >
        </cfif>
        <cfdocument format="PDF" filename="C:/websites/student-management/nsmg/uploadedfiles/users/#client.userid#/Season#season#cbcAuthorization.pdf" overwrite="yes">
        <!--- form.pr_id and form.report_mode are required for the progress report in print mode.
                    form.pdf is used to not display the logo which isn't working on the PDF. --->
                    <cfset form.report_mode = 'print'>
                    <cfset form.pdf = 1>
                    <cfinclude template="completedCBCAuth.cfm">
                    <br /><Br />
                    <Cfoutput>
                    Electronically Signed<Br />
                    #form.signature#<br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<Br />
                    IP: #cgi.REMOTE_ADDR# 
                    </Cfoutput>
                </cfdocument>
                        <!----Email to Student---->    
            <cfsavecontent variable="repEmailMessage">
              <Cfoutput>	
              
                Attached is a copy of the Criminal Background Check Authorization you electronically signed.  A copy is also available at any time via 'My Information' when logged into EXITS.
                <br /><br />
                Regards-<Br />
                #client.companyshort#
              </Cfoutput>
                </cfsavecontent>
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                
                    <cfinvokeargument name="email_to" value="#client.email#">       
					<!----
                    <cfinvokeargument name="email_to" value="gary@iseusa.com"> 
					---->
                    <cfinvokeargument name="email_from" value="""#client.companyshort# Support"" <#client.emailfrom#>">
                    <cfinvokeargument name="email_subject" value="CBC Authorization">
                    <cfinvokeargument name="email_message" value="#repEmailMessage#">
                    <cfinvokeargument name="email_file" value="C:/websites/student-management/nsmg/uploadedfiles/users/#client.userid#/Season#season#cbcAuthorization.pdf">
                </cfinvoke>	
            
             <Cfif (qGetUserInfo.accountCreationVerified is '')>  
              <cfsavecontent variable="programEmailMessage">
                <cfoutput>				
               
                #form.signature# (#userid#) has submitted their CBC authorization. 
                Please run and review the CBC.<Br><Br>
                
               <a href="#client.exits_url#/nsmg/index.cfm?curdoc=user_info&userid=#userid#">View and Submit</a>
                
                </cfoutput>
                </cfsavecontent>
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                	<!----
					 **********This emai is sent to the Program Manager*******************<Br>
                *****************#progManager.pm_email#<br>**********************
                    <cfinvokeargument name="email_to" value="gary@iseusa.com">      
                    ---->
                    <cfinvokeargument name="email_to" value="#progManager.pm_email#"> 
					      
                    <cfinvokeargument name="email_from" value="""#client.companyshort# Support"" <#client.emailfrom#>">
                    <cfinvokeargument name="email_subject" value="CBC Authorization for #client.name#">
                    <cfinvokeargument name="email_message" value="#programEmailMessage#">
                  
                </cfinvoke>	 
             </Cfif>    
             
            <cfif checkSeason.recordcount gt 0> 
                <cfquery name="updatePaperwork" datasource="#application.dsn#">
                update smg_users_paperwork
                set ar_cbc_auth_form = #CreateODBCDate(now())#,
                ar_info_sheet = #CreateODBCDate(now())#,
                cbcSig = <Cfqueryparam cfsqltype="cf_sql_varchar" value="#form.signature#"> 
                where userid = <Cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#"> 
                AND seasonid = <Cfqueryparam cfsqltype="cf_sql_integer" value="#season#">
                </cfquery>
            <cfelse>
                <cfquery name="updatePaperwork" datasource="#application.dsn#">
               INSERT INTO smg_users_paperwork (ar_cbc_auth_form, userid, seasonid,fk_companyid, cbcSig, ar_info_sheet)
               values (#CreateODBCDate(now())#, <Cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
                        <Cfqueryparam cfsqltype="cf_sql_integer" value="#season#">,<Cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">, <Cfqueryparam cfsqltype="cf_sql_varchar" value="#form.signature#">, #CreateODBCDate(now())#)
                </cfquery>
			</cfif>
   
		   <SCRIPT LANGUAGE="JavaScript"><!--
			setTimeout('self.close()',2000);
			//--></SCRIPT>

    </Cfif>

         
	</Cfif>




<cfquery name="checkSeason" datasource="#application.dsn#">
select *
from smg_users_paperwork
where seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#season#">
and userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid# ">
	<Cfif client.companyid gt 5>
	and fk_companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
	</Cfif>
</cfquery>
<cfquery name="get_states" datasource="#application.dsn#">
    SELECT state, statename
    FROM smg_states
    ORDER BY id
</cfquery>

<div class="wrapper">
 
<div class="greyHeader">
  <h1>CBC Authorization</h1>

</div>
<!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />
<p>As mandated by the Department of State, a Criminal Background Check on all Office Staff, Regional Directors/
  Managers, Regional Advisors, Area Representatives and all members of the host family aged 18 and above is 
  required for involvement with the J-1 Secondary School Exchange Visitor Program.. </p>
<cfoutput>
<div class="scroll">
         
  <p>I, <strong>#qGetUserInfo.firstName# #qGetUserInfo.middlename# #qGetUserInfo.lastname#</strong> do hereby authorize verification of all information in my application for involvement with the Exchange Program from all necessary sources and additionally authorize any duly recognized agent of General Information Services, Inc. to obtain the said records and any such disclosures.</p>
<p>Information appearing on this Authorization will be used exclusively by General Information Services, Inc. for identification
purposes and for the release of information that will be considered in determining any suitability for participation in the
Exchange Program.</p>
<p>Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to
request from General Information Services, Inc. information about the nature and substance of all records on file about me
at the time of my request. This may include the type of information requested as well as those who requested reports from
General Information Services, Inc. within the two-year period preceding my request.  </p>
<cfform method="post" action="cbcAuthorization.cfm?curdoc=cbcAuthorization">
<Table>
	<Tr>
    	<Td>
             <table>
                <Tr>
                    <td>Current Address</td><Td><input type="text" value="#form.address#" name="address" /></Td>
                </Tr>
                <tr>
                    <td></td><Td><input type="text" value="#form.address2#" name="address2" /></Td>
                </tr>    
                <tr>
                    <td>City</td><Td><input type="text" value="#form.city#" name="city"/></Td>
                </tr>    
                <tr>
                    <td>State</td><Td>
                    	<cfselect NAME="state" query="get_states" value="state" display="statename" selected="#FORM.state#" queryPosition="below">
                            <option></option>
                        </cfselect>
                    </Td>
                </tr>  
                <tr>
                    <td>Zip</td><Td><input type="text" value="#form.zip#" name="zip" /></Td>
                </tr>  
             </table>   
          </Td>
          <td>
              <table>
                <Tr>
                    <td>Previous Address</td><Td><input type="text" value="#form.previous_address#" name="previous_address" /></Td>
                </Tr>
                <tr>
                    <td></td><Td><input type="text" value="#form.previous_address2#" name="previous_address2" /></Td>
                </tr>    
                <tr>
                    <td>City</td><Td><input type="text" value="#form.previous_city#" name="previous_city"  /></Td>
                </tr>    
                <tr>
                    <td>State</td><Td>
                    <cfselect NAME="previous_state" query="get_states" value="state" display="statename" selected="#FORM.previous_state#" queryPosition="below">
                            <option></option>
                    </cfselect>
                    </Td>
                </tr>  
                <tr>
                    <td>Zip</td><Td><input type="text" value="#form.previous_zip#" name="previous_zip"  /></Td>
                </tr>  
             </table>     
		</td>
	</tr>
</Table> 
<hr width=50% align="center" />
<table width=100%>
	<tr>
    	<Td>Date of Birth</Td><td>   <input type="text" value="#DateFormat(form.dob, 'mm/dd/yyyy')#" size=12 name="dob" /></td>
    </tr>
    <tr>
    	<Td>Social Security Number</Td><Td><input type ="Text" value="#form.ssn# " size=20 name="ssn"/></Td>
   
    </Td>
 </Tr>
</Table>
  
  	
 </div>
 

	
           
 
  
  <div class="clearfix"></div>
<div class="lightGrey">
<Cfif checkSeason.recordcount gte 0>
	<cfif checkSeason.ar_cbc_auth_form is ''>
        
        <input type="hidden" name="sign"/>
        <table width=100% align="Center">
          <Tr>
            <Td valign="top"><input type="checkbox" name="termsAgree" value=1 /></Td><td>I agree to the terms and conditions set above.<Br /><i class="italic"> (Typing your name below replaces your signature on this document) </i></td>
            </Tr>
            <tr>
            <td colspan=2>&nbsp; </td>
            </tr>
          <tr>
            <td colspan=2 align="center">
              <input type="text" name="signature" size=25 /><Br />#client.name#
              </td>
            </tr>
         <tr>
         	<Td colspan=2 align="center"><Br /><input type="image" src="../pics/buttons_SUBMIT.png"/></Td>
        </table>
       
     <cfelse>
     <div align="center">
     Signed by #checkSeason.cbcSig# on #DateFormat(checkSeason.ar_cbc_auth_form, 'mmmm d, yyyy')#
     </div>
     </cfif>
</cfif>
 </cfform>
 </div> 
  </cfoutput>
</div>
</div>
</body>
</html>