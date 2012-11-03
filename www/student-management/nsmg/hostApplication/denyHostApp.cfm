<link href="http://ise.111cooper.com/hostApp/css/hostApp.css" rel="stylesheet" type="text/css" />
<link href="http://ise.exitsapplication.com/nsmg/linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<cfparam name="url.hostid" default="">
<cfif val(url.hostid)>
	<cfset client.hostid = #url.hostid#>
</cfif>
<cfquery name="appStatus" datasource="#application.dsn#">
    select hostAppStatus, familylastname, arearepid, regionid, email 
    from smg_hosts
    where hostid = #client.hostid#
    </cfquery>
<!----Set Email on who is receiving---->
 <Cfquery name="repInfo" datasource="#application.dsn#">
    select email, firstname, lastname, userid
    from smg_users
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.arearepid#">
    </Cfquery>
    
    <Cfquery name="repInfoAdvisor" datasource="#application.dsn#">
    select advisorid
    from user_access_rights
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.arearepid#">
    and regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
    </Cfquery>
    <cfif repInfoAdvisor.recordcount eq 0>
    	<cfset get_regional_manager.email = ''>
    <cfelse>
        <cfquery name="get_regional_manager" datasource="#application.dsn#">
            SELECT smg_users.userid, smg_users.email, smg_users.firstname, smg_users.lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#repInfoAdvisor.advisorid#"> 
        </cfquery>
	</cfif>
    <cfquery name="get_regional_director" datasource="#application.dsn#">
        SELECT smg_users.userid, smg_users.email, smg_users.firstname, smg_users.lastname
        FROM smg_users
        LEFT JOIN user_access_rights on smg_users.userid = user_access_rights.userid
        WHERE user_access_rights.usertype = 5
        AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.regionid#">
        AND smg_users.active = 1
    </cfquery>
   

    <cfquery name="get_facilitator" datasource="#application.dsn#">
        SELECT smg_regions.regionfacilitator, smg_users.email, smg_users.firstname, smg_users.lastname
        FROM smg_regions
        LEFT JOIN smg_users on smg_users.userid = smg_regions.regionfacilitator
        WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.regionid#">
    </cfquery>
   <cfif client.usertype eq 7>
   		<cfset mailTo = '#appStatus.email#'>
	    <cfset appCurrentStatus = 8>
   <Cfelseif client.usertype eq 6>
    <Cfset mailTo = '#repInfo.email#'>
   	<cfset appCurrentStatus = 7>
   <cfelseif client.usertype eq 5>
   		<Cfif get_regional_manager.email is ''>
        	<cfset mailTo = '#repInfo.email#'>
            <cfset appCurrentStatus = 7>
       <cfelse>
        	<cfset mailTo = '#get_regional_manager.email#'>
            <cfset appCurrentStatus = 6>
       </Cfif>
   
   	<cfelseif client.usertype lte 4>
   		<cfset mailTo = '#get_regional_director.email#'>
        <cfset appCurrentStatus = 5>
   </cfif>


<Cfquery name="getDeniedReasons" datasource="#application.dsn#">
select tdld.arearepDenial, tdld.regionalAdvisorDenial, tdld.regionalDirectorDenial,tdld.facDenial, tdl.description 
from smg_ToDoListDates tdld
left join smg_ToDoList tdl on tdl.id = tdld.itemID 
where fk_hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
and (tdld.arearepDenial != '' OR 
	 tdld.regionalAdvisorDenial != '' OR 
     tdld.regionalDirectorDenial != '' OR
     tdld.facDenial != '')
</Cfquery>
<Cfquery name="hostInfo" datasource="#application.dsn#">
select email, password, familylastname, hostid
from smg_hosts
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
</Cfquery>

<Cfif isDefined('form.sendEmail')>

<cfquery datasource="#application.dsn#">
update smg_hosts
	set hostAppStatus =
    <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#appCurrentStatus#">,
    applicationDenied = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
    reasonAppDenied = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.additionalInfo#">
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
</cfquery>

<cfif appCurrentStatus lte 7>
<cfsavecontent variable="denyApp">      
	<style type="text/css">
                         .rdholder {
                            height:auto;
                            width:auto;
                            margin-bottom:25px;
                            margin-top: 15px;
                         } 
                        
                        
                         .rdholder .rdbox {
                            border-left:1px solid #c6c6c6;
                            border-right:1px solid #c6c6c6;
                            padding:2px 15px;
                            margin:0;
                            display: block;
                            min-height: 137px;
                         } 
                        
                         .rdtop {
                            width:auto;
                            height:20px;
                            /* -webkit for Safari and Google Chrome */
                        
                          -webkit-border-top-left-radius:12px;
                            -webkit-border-top-right-radius:12px;
                            /* -moz for Firefox, Flock and SeaMonkey  */
                        
                          -moz-border-radius-topright:12px;
                            -moz-border-radius-topleft:12px;
                            background-color: #FFF;
                            color: #006699;
                            border-top-width: 1px;
                            border-right-width: 1px;
                            border-bottom-width: 0px;
                            border-left-width: 1px;
                            border-top-style: solid;
                            border-right-style: solid;
                            border-bottom-style: solid;
                            border-left-style: solid;
                            border-top-color: #c6c6c6;
                            border-right-color: #c6c6c6;
                            border-bottom-color: #c6c6c6;
                            border-left-color: #c6c6c6;
                         } 
                        
                         .rdtop .rdtitle {
                            margin:0;
                            line-height:30px;
                            font-family:Arial, Geneva, sans-serif;
                            font-size:20px;
                            padding-top: 5px;
                            padding-right: 10px;
                            padding-bottom: 0px;
                            padding-left: 10px;
                            color: #006699;
                         }
                        
                         .rdbottom {
                        
                          width:auto;
                          height:10px;
                          border-bottom: 1px solid #c6c6c6;
                          border-left:1px solid #c6c6c6;
                          border-right:1px solid #c6c6c6;
                           /* -webkit for Safari and Google Chrome */
                        
                          -webkit-border-bottom-left-radius:12px;
                          -webkit-border-bottom-right-radius:12px;
                        
                        
                         /* -moz for Firefox, Flock and SeaMonkey  */
                        
                          -moz-border-radius-bottomright:12px;
                          -moz-border-radius-bottomleft:12px; 
                         
                         }
                        
                        .clearfix {
                            display: block;
                            height: 5px;
                            width: 500px;
                            clear: both;
                        }
                        .rdholder .rdbox p, li, td {
                            font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
                            font-size: .80em;
                            padding-top: 0px;
                            padding-right: 20px;
                            padding-bottom: 0px;
                            padding-left: 20px;
                        }
                        
						
						.thinBorder{border:solid 1px;}
						
                        </style> 
                         
                        <div class="rdholder" style="width: 595px;"> 
                                        <div class="rdtop"> </div> <!-- end top --> 
                                     <div class="rdbox">               
		<cfoutput>
         The #hostInfo.familylastname# (#hostInfo.hostid#) application has been denied for the following reasons. If you are able to make the necessary changes, please update the application and re-approve it.  If you are unable to make the needed changes, deny the application and it will move back down the hierarchy. 
          <br /><br />
          <Cfoutput>
 
<table style="border: solid 1px;" width=80% align="center" cellpadding="4" cellspacing="0" >
	<Tr >
    	<Th align="left">Item</Th><th align="left">Problem Found</th>
    </Tr>
<cfif getDeniedReasons.recordcount eq 0>
	<tr bgcolor="##F7F7F7" >
    	<td colspan=2 align="center">No issues were recorded on specific sections of the application, please see below for general comments.</td>
    </tr>
<cfelse>
    <cfloop query="getDeniedReasons">
        <Tr <cfif currentRow mod 2> bgcolor="##F7F7F7"</cfif>>
            <Td>#description#</Td><td>#arearepDenial# #regionalAdvisorDenial# #regionalDirectorDenial# #facdenial#</td>
        </Tr>       
    </cfloop>
</cfif>
</Table>


<br><br>
</Cfoutput>
<Cfif form.additionalInfo is not ''>
<div align="left">
The following additional information was added:<br><Br>
#form.additionalInfo#
</div>
<br>
<br>
</Cfif> 


        
        </cfoutput>
    </cfsavecontent>

<cfelse>
<cfsavecontent variable="denyApp">      
	<style type="text/css">
                         .rdholder {
                            height:auto;
                            width:auto;
                            margin-bottom:25px;
                            margin-top: 15px;
                         } 
                        
                        
                         .rdholder .rdbox {
                            border-left:1px solid #c6c6c6;
                            border-right:1px solid #c6c6c6;
                            padding:2px 15px;
                            margin:0;
                            display: block;
                            min-height: 137px;
                         } 
                        
                         .rdtop {
                            width:auto;
                            height:20px;
                            /* -webkit for Safari and Google Chrome */
                        
                          -webkit-border-top-left-radius:12px;
                            -webkit-border-top-right-radius:12px;
                            /* -moz for Firefox, Flock and SeaMonkey  */
                        
                          -moz-border-radius-topright:12px;
                            -moz-border-radius-topleft:12px;
                            background-color: #FFF;
                            color: #006699;
                            border-top-width: 1px;
                            border-right-width: 1px;
                            border-bottom-width: 0px;
                            border-left-width: 1px;
                            border-top-style: solid;
                            border-right-style: solid;
                            border-bottom-style: solid;
                            border-left-style: solid;
                            border-top-color: #c6c6c6;
                            border-right-color: #c6c6c6;
                            border-bottom-color: #c6c6c6;
                            border-left-color: #c6c6c6;
                         } 
                        
                         .rdtop .rdtitle {
                            margin:0;
                            line-height:30px;
                            font-family:Arial, Geneva, sans-serif;
                            font-size:20px;
                            padding-top: 5px;
                            padding-right: 10px;
                            padding-bottom: 0px;
                            padding-left: 10px;
                            color: #006699;
                         }
                        
                         .rdbottom {
                        
                          width:auto;
                          height:10px;
                          border-bottom: 1px solid #c6c6c6;
                          border-left:1px solid #c6c6c6;
                          border-right:1px solid #c6c6c6;
                           /* -webkit for Safari and Google Chrome */
                        
                          -webkit-border-bottom-left-radius:12px;
                          -webkit-border-bottom-right-radius:12px;
                        
                        
                         /* -moz for Firefox, Flock and SeaMonkey  */
                        
                          -moz-border-radius-bottomright:12px;
                          -moz-border-radius-bottomleft:12px; 
                         
                         }
                        
                        .clearfix {
                            display: block;
                            height: 5px;
                            width: 500px;
                            clear: both;
                        }
                        .rdholder .rdbox p, li, td {
                            font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
                            font-size: .80em;
                            padding-top: 0px;
                            padding-right: 20px;
                            padding-bottom: 0px;
                            padding-left: 20px;
                        }
                        
						
						.thinBorder{border:solid 1px;}
						
                        </style> 
                         
                        <div class="rdholder" style="width: 595px;"> 
                                        <div class="rdtop"> </div> <!-- end top --> 
                                     <div class="rdbox">               
		<cfoutput>
          Unfortunately there are some problems with your host family application.  Please review the list below or problem items.
          <br><br>Your application has been unlocked and you can login to make any adjustments that are needed.
          <br /><br />
          <Cfoutput>
 
<table style="border: solid 1px;" width=80% align="center" cellpadding="4" cellspacing="0" >
	<Tr >
    	<Th align="left">Item</Th><th align="left">Problem Found</th>
    </Tr>
<cfif getDeniedReasons.recordcount eq 0>
	<tr bgcolor="##F7F7F7" >
    	<td colspan=2 align="center">No issues were recorded on specific sections of the application, please see below for general comments.</td>
    </tr>
<cfelse>
    <cfloop query="getDeniedReasons">
        <Tr <cfif currentRow mod 2> bgcolor="##F7F7F7"</cfif>>
            <Td>#description#</Td><td>#arearepDenial# #regionalAdvisorDenial# #regionalDirectorDenial# #facdenial#</td>
        </Tr>       
    </cfloop>
</cfif>
</Table>


<br><br>
</Cfoutput>
<Cfif form.additionalInfo is not ''>
<div align="left">
The following additional information was added:<br><Br>
#form.additionalInfo#
</div>
<br>
<br>
</Cfif> 

<div style="display: block; float: left; width: 250px;  padding: 10px;  font-family:Arial, Helvetica, sans-serif; font-size: .80em"> <strong><em>To update your application, please click on the following link:</em></strong><br /><br />
         <a href="http://www.iseusa.com/hostApp/" target="_blank"><img src="http://www.iseusa.com/hostApp/images/buttons/contApp.png" width="200" height="56" border="0"></a> <br /></div>
         <div style="display: block; float: right; width: 270px; padding: 10px; font-family:Arial, Helvetica, sans-serif; font-size: .80em; border: thin solid ##CCC;"><div><strong><em>Please use the following login information:</em></strong></div><br /><br />
<div style="width: 50px; float: left;"><img src="http://ise.exitsapplication.com/nsmg/pics/lock.png" width="39" height="56"></div>
   <div> <strong>Username / Email:</strong><br /> <a href="mailto:#hostinfo.email#" target="_blank">#hostInfo.email#</a><br />
  <strong>Password:</strong>#hostInfo.password#</div>
          
        
        </cfoutput>
    </cfsavecontent>
</cfif>
    <cfinvoke component="nsmg.cfc.email" method="send_mail">
    
        <cfinvokeargument name="email_to" value="#mailTo#">
		<!----
        <cfinvokeargument name="email_to" value="josh@pokytrails.com">
	---->
         <cfinvokeargument name="email_cc" value="#client.email#">
        <cfinvokeargument name="email_subject" value="Problems with Host Application">
        <cfinvokeargument name="email_message" value="#denyApp#">
        <cfinvokeargument name="email_from" value="hostApp@iseusa.com">
    </cfinvoke>
    
 <div align="center">
                
                <h1>Succesfully Submited.</h1>
                <em>this window should close shortly</em>
                </div>
            
                 <body onLoad="parent.$.fn.colorbox.close();">
                    <cfabort>

</Cfif>
The following problems have been noted with the application and these reasons will be included in the email sent to the host family:<br><br>
<Cfoutput>
<Table class=border width=80% align="center" cellpadding="4" cellspacing="0">
	<Tr >
    	<Th align="left">Item</Th><th align="left">Problem Found</th>
    </Tr>
<cfif getDeniedReasons.recordcount eq 0>
	<tr bgcolor="##F7F7F7" >
    	<td colspan=2 align="center">No issues were recorded for any sections of the application.<br><br>Are you sure you want to deny it?</td>
    </tr>
<cfelse>
    <cfloop query="getDeniedReasons">
        <Tr <cfif currentRow mod 2> bgcolor="##F7F7F7"</cfif>>
            <Td>#description#</Td><td>#arearepDenial# #regionalAdvisorDenial# #regionalDirectorDenial# #facdenial#</td>
        </Tr>       
    </cfloop>
</cfif>
</Table>

<br>
<div align="center">
<form action="denyHostApp.cfm" method="post">
<input type="hidden" name="sendEmail">
Please include any additional information or a message to the host family below:<br><Br>
<textarea rows="10" cols="60" name="additionalInfo" placeholder="Your application is just missing a few...."></textarea><br><br>
<input type="image" src="../pics/buttons/submit.png">
</form>
</Cfoutput>
</div>
<p>&nbsp;</p>
