<!--- ------------------------------------------------------------------------- ----
	
	File:		displayRepAgreement.cfm
	Author:		Josh Rahl
	Date:		Sept 9, 2011
	Desc:		Services Agreement Contract

	
----- ------------------------------------------------------------------------- --->
<title>Employment History</title>
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
.outline {
	padding: 5px;
	border: thin solid #666;
	width: 500px;
	margin-left: 30px;
}
.greybox {
	background-color: #DEEAF3;
	width: 560px;
	padding-top: 5px;
	padding-right: 20px;
	padding-bottom: 20px;
	padding-left: 20px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.whitebox {
	background-color: #FFF;
	width: 560px;
	padding-top: 5px;
	padding-right: 20px;
	padding-bottom: 20px;
	padding-left: 20px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
th {
	font-size: 12px;
	font-weight: bold;
	color: #FFF;
	background-color: #000;
}
td {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.border {
	border: thin solid #999;
	padding: 10px;
}
.redtext {
	color: #900;
}
.clearfix {
	display: block;
	clear: both;
	height: 10px;
}
</style>
<link rel="stylesheet" media="all" type="text/css"href="../linked/css/baseStyle.css" />
 <Cfset season = 9>

	<cfsilent>
		<!--- Import CustomTag Used for Page Messages and Form Errors --->
        <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	</cfsilent>


</head>

<body onLoad="opener.location.reload()">
<cfset field_list = 'occupation,employer,address,address2,city,state,zip,phone,daysWorked,hoursDay,datesEmployed,current'>

<cfparam name="form.occupation" default="">
<cfparam name="form.employer" default="">
<cfparam name="form.address" default="">
<cfparam name="form.address2" default="">
<cfparam name="form.city" default="">
<cfparam name="form.state" default="">
<cfparam name="form.zip" default="">
<cfparam name="form.phone" default="">
<cfparam name="form.daysWorked" default="">
<cfparam name="form.hoursDay" default="">
<cfparam name="form.startDate" default="">
<cfparam name="form.endDate" default="">
<cfparam name="form.current" default="0">
<cfparam name="form.datesEmployed" default="">
<cfparam name="form.previousAffiliation" default="3">

<cfif isDefined('url.delete')>
	<cfquery datasource="mysql">
    delete from smg_users_employment_history
    where employmentid = #url.delete#
    </cfquery>
</cfif>
<Cfif isDefined('form.affiliationName')>
     <!---Error Checking---->
             <cfscript>
                // Data Validation
                // Family Last Name
				if ((TRIM(FORM.previousAffiliation) eq 3) ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("Please answer the question: Have you ever had an affiliation with...");
                }	
                if ((TRIM(FORM.previousAffiliation) eq 1 ) and NOT LEN(TRIM(FORM.affiliationName))) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("You have indicated you had a previous affiliation with an exchange organization, but did not provide any details.");
                }			
          </cfscript>
            <cfif NOT SESSION.formErrors.length()>
            <Cfquery datasource="#application.dsn#">
            update smg_users
            set prevOrgAffiliation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.previousAffiliation#">,
            	prevAffiliationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.affiliationName#">,
                prevAffiliationProblem = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.affiliationProblem#">
             where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            </cfquery>
            
                <SCRIPT LANGUAGE="JavaScript">
				<!--
				  setTimeout('self.close()',2000);
				//-->
                </SCRIPT>
			
            </cfif>
</Cfif>
    
<cfif isDefined('form.insert')>
	<CFif isDefined('form.noAdditional')>
    	<cfset form.current = 1>
    	<Cfset form.employer = 'None Provided'>
        <Cfset form.occupation = 'None Provided'>
        <Cfset form.address = 'None Provided'>
        <Cfset form.address2 = 'None Provided'>
        <Cfset form.city = 'None Provided'>
        <Cfset form.state = 'N/A'>
        <Cfset form.zip = 'N/A'>
        <Cfset form.phone = 'None Provided'>
        <Cfset form.daysWorked = 'None Provided'>
        <Cfset form.hoursDay = 'None Provided'>
        <Cfset form.datesEmployed = 'None Provided'>
    </CFif> 
	 <!---Error Checking---->
         <cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.employer)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the name of your employer.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(FORM.occupation)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your occupation.");
            }	
			
			// City
            if ( NOT LEN(TRIM(FORM.address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the address.");
            }			
        	
			// City
            if ( NOT LEN(TRIM(FORM.city)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the city.");
            }		
			
        	// State
            if ( NOT LEN(TRIM(FORM.state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please select the state.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(FORM.zip)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a zip code.");
            }			
        	
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.phone)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the phone number.");
            }		
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.daysWorked)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the days you worked.");
            }	
            if ( NOT LEN(TRIM(FORM.hoursDay)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the numbers of hours worked per day.");
            }	
            if ( NOT LEN(TRIM(FORM.datesEmployed)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the dates you were employed.");
            }	
       </cfscript>
  
  
     <cfif NOT SESSION.formErrors.length()>
       <Cfif isDefined('url.edit')>
            <Cfquery name="updateRef" datasource="mysql">
                update smg_users_employment_history 
                    set occupation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.occupation#">,
                        employer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.employer#">,
                        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
                        address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#">,
                        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                        state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
                        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
                        daysWorked = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daysWorked#">,
                        hoursDay = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hoursDay#">,
                        current = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.current#">,
                        datesEmployed = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.datesEmployed#">,
                        fk_userID = <cfqueryparam cfsqltype="cf_sql_interger" value="#client.userid#">
                    where employmentID = #url.edit#
            </Cfquery>
          
     <cfelse>
            <cfquery datasource="MySQL">
                insert into smg_users_employment_history(occupation, employer, address, address2, city, state, zip, phone, daysWorked, hoursDay, current,  fk_userID, datesEmployed)
                values('#form.occupation#','#form.employer#', '#form.address#', '#form.address2#', '#form.city#', '#form.state#', '#form.zip#', '#form.phone#', '#form.daysWorked#', '#form.hoursDay#', #form.current#, #client.userid#,'#datesEmployed#')
            </cfquery>
              <Cfquery name="refID" datasource="mysql">
                select max(employmentID) as newID
                from smg_users_employment_history
            </cfquery>
            <Cfset url.edit = #refID.newId#>
        </Cfif>
        
         <!----Check if this account should be reviewed more then likely this will not happen here, but depending on the order of people submitting things, we have to check.---->
			<Cfscript>
                    //Check if paperwork is complete for season
                    get_paperwork = APPLICATION.CFC.udf.allpaperworkCompleted(userid=client.userid);
					//Get User Info
                    qGetUserInfo = APPLICATION.CFC.user.getUserByID(userid=client.userid);
         </cfscript>
         
		 <cfif val(get_paperwork.reviewAcct)>
         
                 <cfquery name="progManager" datasource="#application.dsn#">
                  select pm_email
                  from smg_companies
                  where companyid = #client.companyid#
                  </cfquery>
                 <cfsavecontent variable="programEmailMessage">
                    <cfoutput>				
                    The references and all other paperwork appear to be in order for  #qGetUserInfo.firstname# #qGetUserInfo.lastname# (#qGetUserInfo.userID#).  A manual review is now required to actiavte the account.  Please review all paper work and submit the CBC for processing. If everything looks good, approval of the CBC will activate this account.  
                    
                   <Br><Br>
                    
                   <a href="#client.exits_url#/nsmg/index.cfm?curdoc=user_info&userid=#client.userid#">View #qGetUserInfo.firstname#<cfif Right(#qGetUserInfo.firstname#, 1) is 's'>'<cfelse>'s</cfif> account.</a>
                    </cfoutput>
                    </cfsavecontent>
                        <cfinvoke component="nsmg.cfc.email" method="send_mail">
                            
                            **********This emai is sent to the Program Manager*******************<Br>
                        *****************#progManager.pm_email#<br>**********************
                            <cfinvokeargument name="email_to" value="josh@pokytrails.com">      
                            <!----
                           
                            <cfinvokeargument name="email_to" value="#progManager.pm_email#"> 
							 ---->
                              
                            <cfinvokeargument name="email_from" value="""#client.companyshort# Support"" <#client.emailfrom#>">
                            <cfinvokeargument name="email_subject" value="CBC Authorization for #client.name#">
                            <cfinvokeargument name="email_message" value="#programEmailMessage#">
                          
                        </cfinvoke>
             
                 </cfif>
                 
        <cflocation url="employmentHistory.cfm?curdoc=employmentHistory">
<Cfelse>




</cfif>
</cfif>
<cfif isDefined('url.edit')>
	<cfquery name="get_record" datasource="mysql">
		SELECT *
		FROM smg_users_employment_history
		WHERE employmentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.edit#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
</cfif>






<div class="wrapper">
 
<div class="greyHeader">
  <h1>Employment History</h1>
</div>
<!--- Form Errors --->
<gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />
<div class="clearfix"></div>
<div class="greybox">

<h2>Employers on File</h2>


<p>Please indicate your current or previous employer. <br>
<em>If you do not want to provide this information, check the appropriate box and then click on 'Add Employer'</em></p>
<br />
<cfquery name="qEmploymentHistory" datasource="MySQL">
select *
from smg_users_employment_history
where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
order by current
</cfquery>

<cfoutput>

<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr>
   	<Th></Th><Th>Employer</Th><Th>Address</Th><th>City</th><Th>State</Th><th>Zip</th><th>Phone</th><th></th>
    </Tr>
   <Cfif qEmploymentHistory.recordcount eq 0>
    <tr>
    	<td colspan=7>Currently, no employers are on file for you</td>
    </tr>
    <cfelse>
    <Cfloop query="qEmploymentHistory">
    <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
    	<Td><cfif current eq 1>&radic;</cfif></Td>
    	<Td><p class=p_uppercase>#employer#</Td>
        <td><p class=p_uppercase>#address# #address2#</td>
        <Td>#city#</Td>
        <td>#state#</td>
        <td>#zip#</td>
        <td>#phone#</td>
        <Td><a href="employmentHistory.cfm?curdoc=employmentHistory&edit=#employmentID#">EDIT</a> <a href="employmentHistory.cfm?curdoc=employmentHistory&delete=#employmentID#" onClick="return confirm('Are you sure you want to delete this employer?')"> DELETE</a></Td>
    </tr>
    </Cfloop>
    </cfif>
   </table>
	
</cfoutput>
<!-- end greybox --></div>

<h2>Add Employer</h2>
<cfoutput>
<cfset employers =1>
<cfset remainingEmployers = #employers# - #qEmploymentHistory.recordcount#>

<cfif remainingEmployers lte 0>
<p>No additional references are required.



<cfelse>
#remainingEmployers# additional employer are required.</p>
</cfif>

<p><span class="redtext">* Required fields </span></p>


<form method="post" action="employmentHistory.cfm?curdoc=employmentHistory<Cfif isDefined('url.edit')>&edit=#url.edit#</cfif>">

<input type="hidden" name="insert" />
<div class="border">
    <table width=100% cellspacing=0 cellpadding=2 >
     <tr bgcolor="##deeaf3">
        <td class="label"> I don't need / want to provide previous employment information.</td>
        <td colspan=3>
            <input type="checkBox" name="noAdditional" value="1" >
        </td>
      </tr>
     </table>
</div>
<br>
<div class="border">
    <table width=100% cellspacing=0 cellpadding=2 >
     <tr bgcolor="##deeaf3">
        <td class="label"> Current Employer<span class="redtext">*</span> </td>
        <td colspan=3>
            <input type="checkBox" name="current" value="1" <cfif form.current eq 1>checked</cfif>>
        </td>
      </tr>
    <tr bgcolor="##deeaf3">
        <td class="label"> Occupation<span class="redtext">*</span> </td>
        <td colspan=3>
            <input type="text" name="occupation" value="#form.occupation#" size="20" maxlength="150">
        </td>
      </tr>
    <tr>
        <td class="label">Employer<span class="redtext">*</span> </td>
        <td colspan=3>
            <input type="text" name="employer" value="#form.employer#" size="20" maxlength="150" >
        </td>
      </tr>
     <tr bgcolor="##deeaf3">
        <td class="label">
        
        Address <span class="redtext">*</span></td>
        <td colspan=2>
        	<input type="text" name="address" value="#form.address#" size="40" maxlength="150" >
            <font size="1">NO PO BOXES 
        </td>
        <td rowspan=2> </td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td></td>
        <td colspan=3><input type="text" name="address2" value="#form.address2#" size="40" maxlength="150"></td>
    </tr>
    <tr>			 
        <td class="label">City <span class="redtext">*</span></td>
        <td colspan=3><input type="text" name="city" value="#form.city#" size="20" maxlength="150" ></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td class="label">State <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_states" datasource="mysql">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<select NAME="state" query="get_states">
			      	<option></option>
				<cfloop query="get_states">
                	<option value="#state#" <Cfif state eq #form.state#>selected</cfif>>#statename#</option>
                </cfloop>
            </select>
        </td>
        <td class="zip">Zip<span class="redtext">*</span> </td>
        <td><input type="text" name="zip" value="#form.zip#" size="5" maxlength="5"></td>
    </tr>
	  <tr >
        <td >Phone <span class="redtext">*</span></td>
        <td colspan=3><input type="text" name="phone" value="#form.phone#" size="14" maxlength="14" mask="(999) 999-9999"></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td >Days Worked <span class="redtext">*</span> </td>
        <td colspan=3><input type="text" name="daysWorked" value="#form.daysWorked#" size="30" maxlength="200" ></td>
    </tr>
     <tr>
        <td >Hours per Day <span class="redtext">*</span> </td>
        <td colspan=3><input type="text" name="hoursDay" value="#form.hoursDay#" size="30" maxlength="200" ></td>
    </tr>
    <tr>
        <td bgcolor="##deeaf3">Dates Employed <span class="redtext">*</span> </td>
        <td colspan=3><input type="text" name="datesEmployed" value="#form.datesEmployed#" size="30" maxlength="200" ></td>
    </tr>

	</table>
    <div class="clearfix"></div>
  <table border=0 cellpadding=4 cellspacing=0 width=100%>
    <tr>
      <td align="right"><Cfif isDefined('url.edit')><a href="employmentHistory.cfm?curdoc=employmentHistory"><img src="../pics/buttons/goBack_44.png" border=0/></a> <input name="Submit" type="image" src="../pics/buttons/update_44.png" border=0><cfelse><input name="Submit" type="image" src="../pics/buttons/addEmployer.png" border=0></Cfif></td>
      </tr>
  </table>
 
<!-- end border --></div>

           
 
 
  <div class="clearfix"></div>

	<Cfif remainingEmployers gt 0>
    <div class="lightGrey">
          <div align="center">
         #remainingEmployers# additional employer(s) are required.
         </div>
    </div>
    </cfif>
</form>
<Cfif remainingEmployers lte 0>

<Br>


	<div class="greybox">

<h2>Prior Student Exchange Experience</h2>

<cfform method="post" action="employmentHistory.cfm?curdoc=employmentHistory">

<p>Have you had a previous affiliation in any way with international exchange student programs (i.e., hosting, placing, or monitoring exchange students) or with Department of State Secondary School Student programs?<br>
    <div align="center">
     <cfinput type="radio" name="previousAffiliation" value="1"
                onclick="document.getElementById('showQs').style.display='table-row';" checked="#previousAffiliation eq 1#" />Yes &nbsp;&nbsp;&nbsp;&nbsp;
                
     <cfinput type="radio" name="previousAffiliation" value="0"
                onclick="document.getElementById('showQs').style.display='none';" checked="#previousAffiliation eq 0#"/>No
    </div>
</p>
<Table>
		<tr id="showQs" <cfif previousAffiliation eq 0 or previousAffiliation eq 3 >style="display: none;"</cfif>  >	
    	<Td>

<p>If Yes, please indicate the name of the sponsor that you were affiliated with and list your dates of affiliation with that organization.<Br>
<textarea name="affiliationName" cols="60" rows="10"></textarea></p>
<p>Were there any issues with the prior organization(s)? If Yes, please explain<br>
<textarea name="affiliationProblem" cols="60" rows="10"></textarea></p>
		</td>
      	</tr>
</table>
<input type="hidden" name="update">
<div align="right"><input type="image" src="../pics/buttons/Next.png"></div>
</div>
</cfform>
</Cfif>

 </div> 
</cfoutput>
<!-- end wrapper --></div>

</body>
</html>