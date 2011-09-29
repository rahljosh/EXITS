<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Put Student on Hold</title>
</head>

<body>

    <cfquery name="studentInfo" datasource="#application.dsn#">
    select firstName, familylastname, studentid
    from smg_students
    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
    </cfquery>
    <Cfquery name="tripDetails" datasource="mysql">
    select *
    from smg_tours
    where tour_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tour#"> 
    </cfquery>

<Cfif isDefined('form.sendEmail')>
<cfoutput>
<cfquery datasource="#application.dsn#">
update student_tours
set hold = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#now()#">,
	holdReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.holdReason#">
where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
</cfquery>

<cfsavecontent variable="holdEmailMessage">
        <cfoutput>				
      #client.name# put #studentInfo.firstname# #studentInfo.familylastname# (#studentInfo.studentid#), who registered to go on the #tripDetails.tour_name# tour on hold for the following reason:
      <br /><Br />
      #form.holdreason#
	    </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
        	<cfinvokeargument name="email_to" value="brendan@iseusa.com">       
            <cfinvokeargument name="email_from" value="""ISE Trip Support"" <ISETrips@iseusa.com>">
            <cfinvokeargument name="email_subject" value="Student on HOLD">
            <cfinvokeargument name="email_message" value="#holdEmailMessage#">
	 </cfinvoke>	
</cfoutput>
	<Cfif client.usertype lte 4>
    	<cflocation url="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
    </Cfif>
</Cfif>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor="#ffffff">
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=30 background="pics/header_background.gif"><img src="pics/plane.png"></td>
        <td background="pics/header_background.gif"><h2>Trips</h2></td>
        <td background="pics/header_background.gif" align="right"></td>
    	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
 <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
<Cfif isDefined('form.sendEmail')>
	<h2>Hold was successfully placed.</h2>
<cfelse>             

    <h2>Put Student on Hold</h2>
    <Cfoutput>
    <p>You are about to place a hold on the registration process for #studentInfo.firstname# #studentInfo.familylastname#</p>
    
    Please explain why you don't think they should be able to go. 
    
    <form method="post" action="index.cfm?curdoc=tours/hold&studentid=#url.studentid#&tour=#url.tour#">
    <input type="hidden" name="sendEmail" />
    <textarea cols="50" rows="10" name="holdReason"></textarea>
    <br /><br />
    <input type="image" src="pics/submitBlue.png" />
    The hold is not placed until this form is submitted. 
    </form>
    </Cfoutput>
</Cfif>
			</td>
         </tr>
       </table>
       <cfinclude template="../table_footer.cfm">
</body>
</html>