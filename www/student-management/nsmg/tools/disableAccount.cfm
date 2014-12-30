<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>
<!--- Page Header --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    <gui:pageHeader
        headerType="applicationNoHeader"
    />

<cfif isDefined('form.userToDisable')>
	<cfquery name="addReason" datasource="#application.dsn#">
    insert into smg_accountdisabledhistory (date, fk_whoDisabled, fk_userDisabled, reason, accountAction)
    					values(#now()#, #client.userid#, #form.userToDisable#, '#form.disabledReason#', 'Disable')
    </cfquery>
    <cfquery name="disableAccount" datasource="#application.dsn#">
    update smg_users set accountCreationVerified = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
    					dateAccountVerified = <cfqueryparam cfsqltype="cf_sql_date" value="">
                  where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userToDisable#">
	</cfquery>
<div style="width:600px;text-align:center;margin-right:auto;margin-left:auto;" >
<body onload="parent.$.fn.colorbox.close();">
<h2>This account is now disabled. </h2> 
If the user is currently logged in, they will be able to finish there session, <Br /> but will not be able to re-login.
</div>

<cfabort>
</cfif>
<body>
<cfoutput>
<div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Disable Account</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
<form method="post" action="disableAccount.cfm">
<input type="hidden" name="userToDisable" value="#url.userid#"/>
<div style="width:600px;text-align:center;margin-right:auto;margin-left:auto;" >
<h2>Please indicate why you are disabling this account.</h2> 
<p>This information is  recorded for future reference, no emails are sent out and the user doesn't see this message when they attempt to login.<br />
<br />
  
  
</p>
<div style="background-color:##CCC;padding:20px;" >
  <textarea cols="50" rows=10 name="disabledReason"></textarea>

</div>
<br />
 <input type="image" src="../pics/buttons/disable.png" width="100"/>
</div>
</form>
</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
</cfoutput>
</body>
</html>