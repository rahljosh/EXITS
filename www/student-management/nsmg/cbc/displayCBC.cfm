<!--- ------------------------------------------------------------------------- ----
	
	File:		displayRepAgreement.cfm
	Author:		Josh Rahl
	Date:		March 15, 2011
	Desc:		View CBC results and options

	NOTE:  linked from the users paper work list. 

----- ------------------------------------------------------------------------- --->
 <!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />  

<!--- Import CustomTag Used for Page Messages and Form Errors --->
	<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<head>
<title>View Users CBC</title>
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
	width:690px;
	background-color:#CCC;
	padding:5px;
	text-align: center;
}
.lightGrey{
	width:690px;
	background-color:#EFEFEF;
	padding:5px;
	text-align: left;
}
.wrapper {
	padding: 8px;
	width: 700px;
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
.historyTitle{
	color: #666;
}
.historyCol{
	color: #999;
}
.historyItem{
	color: #999;
}
</style>

 <link rel="stylesheet" media="all" type="text/css"href="../linked/css/baseStyle.css" />
</head>

<!----Submit info, but don't approve---->
<cfif isDefined('form.submitcbcinfo')>
	<Cfquery datasource="#application.dsn#">
    update smg_users_cbc
    set notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.notes#">,
    <cfif isDefined('form.flagCBC')>
    flagCBC = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
    </cfif>
    date_approved = <cfqueryparam cfsqltype="cf_sql_date" value="">
    where cbcID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cbcID#">
    </Cfquery>
        <Cfquery datasource="#application.dsn#">
    insert into smg_users_cbc_reason_history (reason, type, dateCommented, whoCommented, cbcid)
    		values( 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.notes#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Info">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cbcid#">
                    )
  
    </Cfquery>
    <cfscript> 
	// Set Page Message
    SESSION.pageMessages.Add("Information has been updated.  CBC was NOT approved.");
	</cfscript>
        <!----Clost window---->
            <SCRIPT LANGUAGE="JavaScript"><!--
			setTimeout('self.close()',1000);
			//--></SCRIPT>
</cfif>

<!----Approve CBC---->
<cfif isDefined('form.approveCBC')>
	<Cfquery datasource="#application.dsn#">
    update smg_users_cbc
    set notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.notes#">,
    flagCBC = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
    date_approved = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
    denied = <cfqueryparam cfsqltype="cf_sql_date" value="">
    
   
    where cbcID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cbcID#">
    </Cfquery>
    
    <Cfquery datasource="#application.dsn#">
    insert into smg_users_cbc_reason_history (reason, type, dateCommented, whoCommented, cbcid)
    		values( 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.notes#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Approved">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cbcid#">
                    )
  
    </Cfquery>
      <cfscript>
	    SESSION.pageMessages.Add("Information was updated, CBC was approved, and flags (if any) removed");
	</cfscript>
    <!----Clost window ---->
            <SCRIPT LANGUAGE="JavaScript"><!--
			setTimeout('self.close()',1000);
			//--></SCRIPT>
</cfif>
<cfif isDefined('form.denyCBCInfo')>
	<Cfquery datasource="#application.dsn#">
    update smg_users_cbc
    set
    flagCBC = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
    denied = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
    
   
    where cbcID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cbcID#">
    </Cfquery>
	
    <Cfquery datasource="#application.dsn#">
    insert into smg_users_cbc_reason_history (reason, type, dateCommented, whoCommented, cbcid)
    		values( 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.notes#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Denied">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cbcid#">
                    )
  
    </Cfquery>
    
      <cfscript>
	    SESSION.pageMessages.Add("Information was updated, CBC was approved, and flags (if any) removed");
	</cfscript>
    <!----Clost window ---->
            <SCRIPT LANGUAGE="JavaScript"><!--
			setTimeout('self.close()',1000);
			//--></SCRIPT>
</cfif>
<body onLoad="opener.location.reload()">

<!----get any info regarding this CBC---->
<cfscript>
// Get User CBC
		qGetCBCUser = APPCFC.CBC.getCBCUserByID(userID=userID,cbcType='user',cbcID=#url.cbcID#);
</cfscript>
<!----Denial/Submit/Approve info history---->
    <Cfquery name="cbcDenialReasons" datasource="#application.dsn#">
    select h.type, h.dateCommented, h.whoCommented, h.reason, smg_users.firstname, smg_users.lastname
    from smg_users_cbc_reason_history h
    left join smg_users on smg_users.userid = h.whoCommented
    where cbcid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cbcID#">
    order by dateCommented desc
    </Cfquery>
<cfoutput>

</cfoutput>
<div class="wrapper">
<div class="greyHeader">
  <h1>CBC Results</h1>

</div>
<Br />
<!--- Page Messages --->
 
  	<div align="center">
                    	<h2>Current Status: 
						<strong>
                         <cfif qGetCBCUser.flagcbc eq 1>
                         	<img src="../pics/warning.png" height=15 width=15 /> Flagged
                         <cfelseif qGetCBCUser.denied is not ''>
                         	<img src="../pics/x.png" height=15 width=15 /> Denied
                         <cfelseif qGetCBCUser.date_Approved is not '' >
                         	Approved on <Cfoutput>#DateFormat(qGetCBCUser.date_approved, 'mm/dd/yyyy')#</Cfoutput>
                         <cfelse>
                            Review Required
                         </cfif>
                         </strong>
                         </h2>
	</div>
<div class="scroll">
	<cfinclude template="view_user_cbc.cfm">
</div>

  <div class="clearfix"></div>
<div class="lightGrey">
<Cfoutput>
 <form method="post" action="displayCBC.cfm?userid=#url.userid#&cbcID=#url.cbcID#&file=#url.file#&curdoc=displayCBC">
        <input type="hidden" name="cbcID" value="#url.cbcID#"/>
        <input type="hidden" name="seasonID" value="#qGetCBCUser.seasonID#" />
        <table width=100% align="Center">
        
            <tr>
            
            
            <td valign="top" colspan=3 align="center">
            <Table>
            	<Tr>
                	<td align="right">
            Flag:</td><td><input type="checkbox" <cfif VAL(qGetCBCUser.flagCBC)>checked="checked"</cfif> name="flagCBC"></td>
                </Tr>
                <tr>
                    <td valign="top">Notes/Explanation: </td><td><textarea rows="3" cols=25 name="notes">#qGetCBCUser.notes#</textarea></td>
                </tr>
          	</Table>
         <tr>                                  
         	<Td align="right" valign="middle"><input name="approveCBC" type="image" value="approveCBC" src="../pics/buttons/approveBut.png" alt="Approve CBC" />&nbsp;&nbsp;</Td>
            <td align="center" valign="middle"><input name="submitCBCInfo" type="image" value="submitInfo" src="../pics/buttons/submitCaution.png" alt="Submit Information on CBC" /></td>
            <td align="left" valign="middle"><input name="denyCBCInfo" type="image" value="denyInfo" src="../pics/buttons/deny.png" alt="Deny CBC" /></a></td>
         </tr>
        </table>
        </form>
  </div> 
 <cfif cbcDenialReasons.recordcount gt 0>
 
 	 <table width=100% align="Center">
 		<tr>
        	<th colspan=4 align="Center" class="historyTitle"><h3>History</h3></th>
        </tr>
    	<Tr>
        	<Th align="left" class="historyCol">Date</Th>
            <th align="left" class="historyCol">User</th>
            <th align="left" class="historyCol">Type</th>
            <th align="left" class="historyCol">Reason</th>
        </Tr>
        <cfloop query="cbcDenialReasons">
        <tr>
        	<td class="historyItem">#DateFormat(dateCommented, 'mm/dd/yyyy')#</td>
            <Td class="historyItem">#firstName# #lastname#</Td>
            <Td class="historyItem">#type#</Td>
            <td class="historyItem">#reason#</td>
        </tr>
        </cfloop>
        </table>
 
 </cfif>       
        <br /><br />
</cfoutput>

</body>
</html>