<!--- ------------------------------------------------------------------------- ----
	
	File:		displayRepAgreement.cfm
	Author:		Josh Rahl
	Date:		Sept 9, 2011
	Desc:		Services Agreement Contract

	NOTE:  The value of season needs to be updated to the season of the agreement.

----- ------------------------------------------------------------------------- --->
	<!--- Import CustomTag Used for Page Messages and Form Errors --->

    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

  
<title>Current Area Rep Agreement</title>
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
</head>

<body onload="opener.location.reload()">
	<cfsilent>
		<!--- Import CustomTag Used for Page Messages and Form Errors --->
        <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	</cfsilent>
	<cfparam name="form.termsAgree" default="">


<Cfset season = 9>
<cfquery name="checkSeason" datasource="#application.dsn#">
select *
from smg_users_paperwork
where seasonid = #season#
and userid = #client.userid# 
	<Cfif client.companyid gt 5>
	and fk_companyid = #client.companyid#
	</Cfif>
</cfquery>

<cfquery name="repInfo" datasource="#application.dsn#">
select firstname, lastname, address, address2, city, state, zip
from smg_users
where userid = #client.userid#
</cfquery>

<Cfif isDefined('form.sign')>
 	<Cfset expectedSig = '#repInfo.firstname# #repInfo.lastname#'>
    <Cfif #trim(form.Signature)# is #trim(expectedSig)#>
    	<Cfset sigMatch = 0>
    <cfelse>
    	<cfset sigMatch = 1>
    </Cfif>
	<cfscript>
	// Father is Required
            if (not len(trim(FORM.signature)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please sign your name");
			}
			if (sigMatch is 1 )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Your signed name #form.signature# does not match the name on file #expectedSig#");
			}
			// Father is Required
            if (not val(FORM.termsAgree) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please check the box indicating you agree to the terms of the service agreement.");
			}
	</cfscript>
	<!--- Check if there are no errors --->
    <cfif NOT SESSION.formErrors.length()>
    
			<cfif DirectoryExists('C:/websites/student-management/nsmg/uploadedfiles/users/#client.userid#/')>
        <cfelse>
            <cfdirectory action = "create" directory = "C:/websites/student-management/nsmg/uploadedfiles/users/#client.userid#/" >
        </cfif>
        <cfdocument format="PDF" filename="C:/websites/student-management/nsmg/uploadedfiles/users/#client.userid#/Season#season#AreaRepAgreement.pdf" overwrite="yes">
        <!--- form.pr_id and form.report_mode are required for the progress report in print mode.
                    form.pdf is used to not display the logo which isn't working on the PDF. --->
                    <cfset form.report_mode = 'print'>
                    <cfset form.pdf = 1>
                    <cfinclude template="AreaRepAgreement.cfm">
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
                <cfoutput>				
                Attached is a copy of the Service Agreement you electronically signed.  A copy is also available at any time in the paperwork section under My Information when logged into EXITS.
                <br /><br />
                Regards-<Br />
                EXITS Support
                </cfoutput>
                </cfsavecontent>
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
               
                    <cfinvokeargument name="email_to" value="#client.email#">   
				 <!----  
                  <cfinvokeargument name="email_to" value="gary@iseusa.com">   
                   ---->
                    <cfinvokeargument name="email_from" value="""#client.companyshort# Support"" <#client.emailfrom#>">
                    <cfinvokeargument name="email_subject" value="Agreement">
                    <cfinvokeargument name="email_message" value="#repEmailMessage#">
                    <cfinvokeargument name="email_file" value="C:/websites/student-management/nsmg/uploadedfiles/users/#client.userid#/Season#season#AreaRepAgreement.pdf">
                   
              </cfinvoke>	
                    
            <cfif checkSeason.recordcount gt 0> 
                <cfquery name="updatePaperwork" datasource="#application.dsn#">
                update smg_users_paperwork
                set ar_agreement = #CreateODBCDate(now())#,
                agreeSig = <Cfqueryparam cfsqltype="cf_sql_varchar" value="#form.signature#"> 
                where userid = <Cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#"> 
                AND seasonid = <Cfqueryparam cfsqltype="cf_sql_integer" value="#season#">
                </cfquery>
            <cfelse>
                <cfquery name="updatePaperwork" datasource="#application.dsn#">
               INSERT INTO smg_users_paperwork (ar_agreement, userid, seasonid,fk_companyid, agreeSig)
               values (#CreateODBCDate(now())#, <Cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
                        <Cfqueryparam cfsqltype="cf_sql_integer" value="#season#">,<Cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">, <Cfqueryparam cfsqltype="cf_sql_varchar" value="#form.signature#">)
                </cfquery>
            </cfif>
            <!----Clost window if signature is fine---->
            <SCRIPT LANGUAGE="JavaScript"><!--
			setTimeout('self.close()',2000);
			//--></SCRIPT>
	</Cfif>
   			
            
	
</Cfif>
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
  <h1>Services Agreement</h1>

</div>
<Br />
<!--- Form Errors --->
 <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />
<br />
<p>It's time to re-sign the Area Representative Agreement.  Please read carefully and then sign below indicationg you agree to the terms and conditions.</p>
<p>Once signed, a PDF version will be available under your profile that is available for printing if you would like a hard copy.</p>

<div class="scroll">
         
                		<cfinclude template="AreaRepAgreement.cfm">
	
           
           </div>
  <cfoutput>
  <div class="clearfix"></div>
<div class="lightGrey">

<Cfif checkSeason.recordcount gte 0>
	<cfif checkSeason.ar_agreement is ''>
        <form method="post" action="displayRepAgreement.cfm?curdoc=displayRepAgreement">
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
         	<Td colspan=2 align="center"><Br /><input type="image" src="../pics/buttons_SUBMIT.png" /></Td>
        </table>
        </form>
     <cfelse>
     <div align="center">
     Signed by #checkSeason.agreeSig# on #DateFormat(checkSeason.ar_agreement, 'mmmm d, yyyy')#
     </div>
     </cfif>
</cfif>
 </div> 
  </cfoutput>

</div>
</div>
</body>
</html>