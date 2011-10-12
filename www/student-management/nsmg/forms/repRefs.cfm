<!--- ------------------------------------------------------------------------- ----
	
	File:		displayRepAgreement.cfm
	Author:		Josh Rahl
	Date:		Sept 9, 2011
	Desc:		Services Agreement Contract

	NOTE:  The value of season needs to be updated to the season of the agreement.

----- ------------------------------------------------------------------------- --->
<title>References</title>
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
 <Cfset season = 8>
 <cfscript>
// Get User Info
		qGetUserInfo = APPLICATION.CFC.USER.getUserByID(userID=client.userID);
		FORM.SSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetUserInfo.SSN, displayType='user');
		 // This will set if SSN needs to be updated
		vUpdateUserSSN = 0;
 </cfscript>
	<cfsilent>
		<!--- Import CustomTag Used for Page Messages and Form Errors --->
        <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	</cfsilent>


</head>

<body onLoad="opener.location.reload()">
<cfset field_list = 'firstname,lastname,address,address2,city,state,zip,phone,email'>

<cfparam name="form.firstname" default="">
<cfparam name="form.lastname" default="">
<cfparam name="form.address" default="">
<cfparam name="form.address2" default="">
<cfparam name="form.city" default="">
<cfparam name="form.state" default="">
<cfparam name="form.zip" default="">
<cfparam name="form.phone" default="">
<cfparam name="form.email" default="">
<cfparam name="form.relationship" default="">
<cfparam name="form.howLong" default="">

<cfif isDefined('url.delete')>
	<cfquery datasource="mysql">
    delete from smg_user_references 
    where refid = #url.delete#
    </cfquery>
</cfif>

<cfif isDefined('form.insert')>
	 <!---Error Checking---->
         <cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.firstname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the first name.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(FORM.lastname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the last name.");
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
            if ( NOT LEN(TRIM(FORM.relationship)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate your relationship to this person.");
            }	
			// How long have you known this person
            if ( NOT LEN(TRIM(FORM.howLong)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate how long you've known this person.");
            }	
       </cfscript>
  
  
     <cfif NOT SESSION.formErrors.length()>
       <Cfif isDefined('url.edit')>
            <Cfquery name="updateRef" datasource="mysql">
                update smg_user_references 
                    set firstname = '#form.firstname#',
                        lastname = '#form.lastname#',
                        address = '#form.address#',
                        address2 = '#form.address2#',
                        city = '#form.city#',
                        state = '#form.state#',
                        zip = '#form.zip#',
                        phone = '#form.phone#',
                        relationship = '#form.relationship#',
                        howLong = '#form.howLong#',
                        email = '#form.email#',
                        referencefor = #client.userid#
                    where refID = #url.edit#
            </Cfquery>
          `
        <cfelse>
            <cfquery datasource="MySQL">
                insert into smg_user_references(firstname, lastname, address, address2, city, state, zip, phone, relationship, howLong, email, referencefor)
                values('#form.firstname#','#form.lastname#', '#form.address#', '#form.address2#', '#form.city#', '#form.state#', '#form.zip#', '#form.phone#', '#form.relationship#','#form.howLong#', '#form.email#', #client.userid#)
            </cfquery>
              <Cfquery name="refID" datasource="mysql">
                select max(refid) as newID
                from smg_user_references
            </cfquery>
            <Cfset url.edit = #refID.newId#>
        </Cfif>
        <cflocation url="repRefs.cfm?curdoc=repRefs">
<Cfelse>




</cfif>
</cfif>
<cfif isDefined('url.edit')>
	<cfquery name="get_record" datasource="mysql">
		SELECT *
		FROM smg_user_references
		WHERE refid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.edit#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
</cfif>


  <cfquery name="checkSeason" datasource="#application.dsn#">
        select *
        from smg_users_paperwork
        where seasonid = #season#
        and userid = #client.userid# 
            <Cfif client.companyid gt 5>
            and fk_companyid = #client.companyid#
            </Cfif>
        </cfquery>



<div class="wrapper">
 
<div class="greyHeader">
  <h1>References</h1>
</div>
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        />
<div class="clearfix"></div>
<div class="greybox">

<h2>Current References</h2>
<!--- Form Errors --->


<p>Please provide at least <Strong>4</Strong> references.  References can <strong>not</strong> be relatives and must have visited you <strong>in side</strong> your home. </p>
<br />
<cfquery name="qreferences" datasource="MySQL">
select *
from smg_user_references
where referencefor = #client.userid#
</cfquery>

<cfoutput>

<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr>
   	<Th>Name</Th><Th>Address</Th><th>City</th><Th>State</Th><th>Zip</th><th>Phone</th><th></th>
    </Tr>
   <Cfif qreferences.recordcount eq 0>
    <tr>
    	<td colspan=7>Currently, no references are on file for you</td>
    </tr>
    <cfelse>
    <Cfloop query="qreferences">
    <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
    	<Td><p class=p_uppercase>#firstname# #lastname#</Td>
        <td><p class=p_uppercase>#address# #address2#</td>
        <Td>#city#</Td>
        <td>#state#</td>
        <td>#zip#</td>
        <td>#phone#</td>
        <Td><a href="repRefs.cfm?curdoc=repRefs&edit=#refid#">EDIT</a> <a href="repRefs.cfm?curdoc=repRefs&delete=#refid#" onClick="return confirm('Are you sure you want to delete this reference?')"> DELETE</a></Td>
    </tr>
    </Cfloop>
    </cfif>
   </table>
	
</cfoutput>
<!-- end greybox --></div>

<h2>Add References</h2>
<cfoutput>
<cfset refs = 4>
<cfset remainingref = #refs# - #qreferences.recordcount#>

<cfif remainingref lte 0>
<cfsavecontent variable="programEmailMessage">
                <cfoutput>				
                References and work experience have been submitted for #client.name# (#client.userid#)
                
                <a href="http://111cooper.com/nsmg/index.cfm?curdoc=user_info&userid=#client.userid#">View and Submit</a>
                
                </cfoutput>
                </cfsavecontent>
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="bhause@iseusa.com">       
                    <cfinvokeargument name="email_from" value="""ISE Support"" <support@iseusa.com>">
                    <cfinvokeargument name="email_subject" value="References">
                    <cfinvokeargument name="email_message" value="#programEmailMessage#">
                    <cfinvokeargument name="email_file" value="C:/websites/student-management/nsmg/uploadedfiles/users/#client.userid#/Season#season#cbcAuthorization.pdf">
                </cfinvoke>	     
<p>No additional references are required.
    <SCRIPT LANGUAGE="JavaScript"><!--
			setTimeout('self.close()',2000);
			//--></SCRIPT>
<cfelse>
#remainingref# additional reference(s) are required.</p>
</cfif>

<p><span class="redtext">* Required fields </span></p>

<cfif remainingref gt 0>
<form method="post" action="repRefs.cfm?curdoc=repRefs<Cfif isDefined('url.edit')>&edit=#url.edit#</cfif>">

<input type="hidden" name="insert" />
<div class="border">
    <table width=100% cellspacing=0 cellpadding=2 >
    <tr bgcolor="##deeaf3">
        <td class="label"> First Name<span class="redtext">*</span> </td>
        <td colspan=3>
            <input type="text" name="firstname" value="#form.firstname#" size="20" maxlength="150">
        </td>
      </tr>
    <tr>
        <td class="label"> Last Name<span class="redtext">*</span> </td>
        <td colspan=3>
            <input type="text" name="lastname" value="#form.lastname#" size="20" maxlength="150" >
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
        <td >Email</td>
        <td colspan=3><input type="text" name="email" value="#form.email#" size="30" maxlength="200" ></td>
    </tr>
	  <tr >
        <td >Relationship<span class="redtext">*</span> <span class="redtext">*</span></td>
        <td colspan=3><input type="text" name="relationship" value="#form.relationship#" size="14" maxlength="14" mask="(999) 999-9999"></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td >How long have you known them?<span class="redtext">*</span></td>
        <td colspan=3><input type="text" name="howLong" value="#form.howLong#" size="30" maxlength="200" ></td>
    </tr>
	</table>
    <div class="clearfix"></div>
  <table border=0 cellpadding=4 cellspacing=0 width=100% >
    <tr>
      <td align="right"><Cfif isDefined('url.edit')><a href="repRefs.cfm?curdoc=repRefs"><img src="../pics/buttons/goBack_44.png" border=0/></a> <input name="Submit" type="image" src="../pics/buttons/update_44.png" border=0><cfelse><input name="Submit" type="image" src="../pics/buttons/addReference.png" border=0></Cfif></td>
      </tr>
  </table>
  </cfif>
<!-- end border --></div>

           
 
 
  <div class="clearfix"></div>
<div class="lightGrey">
	<Cfif remainingref gt 0>
      <div align="center">
     #remainingref# additional reference(s) are required.
     </div>
     <cfelse>
     <div align="center">
     You have added all the references required.
     </div>
    </cfif>


 </div> 
</cfoutput>
<!-- end wrapper --></div>

</body>
</html>