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
<body onload="opener.location.reload()">
<cfif isDefined('form.userToDisable')>
	<cfquery name="addReason" datasource="#application.dsn#">
    insert into smg_accountdisabledhistory (date, fk_whoDisabled, fk_userDisabled, reason, accountAction)
    					values(#now()#, #client.userid#, #form.userToDisable#, '#form.enableReason#', 'Activate')
    </cfquery>
    <cfquery name="disableAccount" datasource="#application.dsn#">
    update smg_users set accountCreationVerified = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
    					dateAccountVerified = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                  where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userToDisable#">
	</cfquery>
<div style="width:600px;text-align:center;margin-right:auto;margin-left:auto;" >
<h2>This account is now active. </h2> 
The user may now login.
</div>
  <!----Clost window if signature is fine---->
		<SCRIPT LANGUAGE="JavaScript"><!--
        setTimeout('self.close()',2000);
        //--></SCRIPT>
<cfabort>
</cfif>
<cfoutput>
<div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Enable Account</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
<form method="post" action="enableAccount.cfm">
<input type="hidden" name="userToDisable" value="#url.userid#"/>
<div style="width:600px;text-align:center;margin-right:auto;margin-left:auto;" >
<h2>Please indicate why you are activating this account.</h2> 
This information is just recorded for future reference only, no emails are sent out.<br /><br />


 <div style="background-color:##CCC;padding:20px;" >
<textarea cols="50" rows=10 name="enableReason"></textarea>

</div>
<br />
 <input type="image" src="../pics/buttons/activate.png" width="100"/>
</div>
</form>
</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
</cfoutput>
</body>
</html>