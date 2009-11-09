<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>HostCompany Profile</title>
<link href="../style.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style3 {	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
}
-->
</style>





<!----format for phone number---->
<script language="javascript">

<!-- This script is based on the javascript code of Roman Feldblum (web.developer@programmer.net) -->
<!-- Original script : http://javascript.internet.com/forms/format-phone-number.html -->
<!-- Original script is revised by Eralper Yilmaz (http://www.eralper.com) -->
<!-- Revised script : http://www.kodyaz.com -->

var zChar = new Array(' ', '(', ')', '-', '.');
var maxphonelength = 13;
var phonevalue1;
var phonevalue2;
var cursorposition;

function ParseForNumber1(object){
phonevalue1 = ParseChar(object.value, zChar);
}
function ParseForNumber2(object){
phonevalue2 = ParseChar(object.value, zChar);
}

function backspacerUP(object,e) {
if(e){
e = e
} else {
e = window.event
}
if(e.which){
var keycode = e.which
} else {
var keycode = e.keyCode
}

ParseForNumber1(object)

if(keycode > 48){
ValidatePhone(object)
}
}

function backspacerDOWN(object,e) {
if(e){
e = e
} else {
e = window.event
}
if(e.which){
var keycode = e.which
} else {
var keycode = e.keyCode
}
ParseForNumber2(object)
}

function GetCursorPosition(){

var t1 = phonevalue1;
var t2 = phonevalue2;
var bool = false
for (i=0; i<t1.length; i++)
{
if (t1.substring(i,1) != t2.substring(i,1)) {
if(!bool) {
cursorposition=i
bool=true
}
}
}
}

function ValidatePhone(object){

var p = phonevalue1

p = p.replace(/[^\d]*/gi,"")

if (p.length < 3) {
object.value=p
} else if(p.length==3){
pp=p;
d4=p.indexOf('(')
d5=p.indexOf(')')
if(d4==-1){
pp="("+pp;
}
if(d5==-1){
pp=pp+")";
}
object.value = pp;
} else if(p.length>3 && p.length < 7){
p ="(" + p;
l30=p.length;
p30=p.substring(0,4);
p30=p30+")"

p31=p.substring(4,l30);
pp=p30+p31;

object.value = pp;

} else if(p.length >= 7){
p ="(" + p;
l30=p.length;
p30=p.substring(0,4);
p30=p30+")"

p31=p.substring(4,l30);
pp=p30+p31;

l40 = pp.length;
p40 = pp.substring(0,8);
p40 = p40 + "-"

p41 = pp.substring(8,l40);
ppp = p40 + p41;

object.value = ppp.substring(0, maxphonelength);
}

GetCursorPosition()

if(cursorposition >= 0){
if (cursorposition == 0) {
cursorposition = 2
} else if (cursorposition <= 2) {
cursorposition = cursorposition + 1
} else if (cursorposition <= 5) {
cursorposition = cursorposition + 2
} else if (cursorposition == 6) {
cursorposition = cursorposition + 2
} else if (cursorposition == 7) {
cursorposition = cursorposition + 4
e1=object.value.indexOf(')')
e2=object.value.indexOf('-')
if (e1>-1 && e2>-1){
if (e2-e1 == 4) {
cursorposition = cursorposition - 1
}
}
} else if (cursorposition < 11) {
cursorposition = cursorposition + 3
} else if (cursorposition == 11) {
cursorposition = cursorposition + 1
} else if (cursorposition >= 12) {
cursorposition = cursorposition
}

var txtRange = object.createTextRange();
txtRange.moveStart( "character", cursorposition);
txtRange.moveEnd( "character", cursorposition - object.value.length);
txtRange.select();
}

}

function ParseChar(sStr, sChar)
{
if (sChar.length == null)
{
zChar = new Array(sChar);
}
else zChar = sChar;

for (i=0; i<zChar.length; i++)
{
sNewStr = "";

var iStart = 0;
var iEnd = sStr.indexOf(sChar[i]);

while (iEnd != -1)
{
sNewStr += sStr.substring(iStart, iEnd);
iStart = iEnd + 1;
iEnd = sStr.indexOf(sChar[i], iStart);
}
sNewStr += sStr.substring(sStr.lastIndexOf(sChar[i]) + 1, sStr.length);

sStr = sNewStr;
}

return sNewStr;
}
</script>


</head>
	<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
		<tr>
			<td bordercolor="FFFFFF">
<cfinclude template="../hostcompany/qr_hostcompany.cfm"> 
<!--- <cfdump var="#session.auth#"> ---->

<cfquery name="get_extrahostcompany" datasource="MySql">
SELECT *, smg_states.state as s
FROM extra_hostcompany
INNER JOIN smg_states ON extra_hostcompany.state = smg_states.id
WHERE hostcompanyid = #url.hostcompanyid#
</cfquery>

<cfquery name="get_smguser" datasource="MySql">
SELECT firstname, middlename, lastname
FROM smg_users
INNER JOIN extra_hostcompany ON smg_users.userid = extra_hostcompany.enteredby
</cfquery>

<cfquery name="get_extracandidates" datasource="MySql">
SELECT * 
FROM extra_candidates
</cfquery>

<cfquery name="get_smgprograms" datasource="MySql">
SELECT smg_programs.programid, smg_programs.programname, smg_programs.startdate
FROM smg_programs
INNER JOIN extra_candidates ON smg_programs.programid = extra_candidates.programid
</cfquery>

<cfquery name="get_upcomingtrainee2" datasource="MySql">
SELECT extra_candidates.firstname, extra_candidates.lastname, smg_programs.programname 
FROM extra_candidates
INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
WHERE smg_programs.startdate > #now()#
</cfquery>

<cfquery name="get_upcomingtrainee" datasource="MySql">
 SELECT extra_candidates.firstname, extra_candidates.lastname  
 FROM extra_candidates
 WHERE startdate > #now()#
</cfquery>

<cfquery name="get_extrajobs" datasource="MySql">
 SELECT extra_jobs.id, extra_jobs.title, extra_jobs.description, extra_jobs.wage, extra_jobs.wage_type
 FROM extra_jobs
 INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_jobs.hostcompanyid 
 WHERE extra_hostcompany.hostcompanyid = #url.hostcompanyid#
</cfquery> 
 
 <cfquery name="get_currenttrainee9" datasource="MySql">
SELECT extra_candidates.candidateid, extra_candidates.uniqueid, extra_candidates.firstname, extra_candidates.lastname, extra_candidates.active, smg_programs.programname, extra_candidates.enddate
FROM extra_candidates
INNER JOIN smg_programs ON smg_programs.programid = extra_candidates.programid
WHERE smg_programs.enddate > #now()#
AND smg_programs.companyid = #url.hostcompanyid#
AND smg_programs.active = 1
AND extra_candidates.active = 1
ORDER BY smg_programs.programid
</cfquery>


<cfquery name="hostcompanies" datasource="MySql">
	SELECT extra_hostcompany.hostcompanyid, extra_hostcompany.name, extra_hostcompany.phone, extra_hostcompany.supervisor, extra_hostcompany.city, extra_hostcompany.state, extra_hostcompany.business_typeid, extra_typebusiness.business_type as typebusiness, smg_states.state as s

	FROM extra_hostcompany
    LEFT JOIN smg_states ON smg_states.id = extra_hostcompany.state
    LEFT JOIN extra_typebusiness ON extra_typebusiness.business_type = extra_hostcompany.business_typeid
 WHERE extra_hostcompany.hostcompanyid = #url.hostcompanyid#    
</cfquery>

<script language="JavaScript"> 
//open program history
function OpenHistory(url) {
	newwindow=window.open(url, 'Application', 'height=400, width=600, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
</script>

<body>
<link href="../phpusa.css" rel="stylesheet" type="text/css">
<div class="section">
<!----Header Table---->
<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
	<tr bgcolor="E4E4E4">
		<td class="title1">&nbsp; &nbsp; Edit Host Company Information </td>
	</tr>
</table>

<br>


<table cellpadding=5 cellspacing=5 border=1 align="center" width="770" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">

<table width="770" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">	
	<tr>
		<td valign="top" width="770" class="box">
		
			<table width="100%" align="Center" cellpadding="2">				
	   		<tr>
					<td width="135">
					
					<table width="94%" border="0" align="center" cellpadding=8 cellspacing=8 bordercolor="#C7CFDC" >
			  <tr><td width="930">
					
								<cfoutput>
								
								  <cfif '#FileExists("c:/websites/extra/internal/uploadedfiles/web-hostlogo/#url.hostcompanyid#.#get_extrahostcompany.picture_type#")#'>
									<img src="../uploadedfiles/web-hostlogo/#url.hostcompanyid#.#get_extrahostcompany.picture_type#" width="135" /><br>
								<a class=nav_bar href="" onClick="javascript: win=window.open('hostcompany/upload_picture.cfm?hostcompanyid=#url.hostcompanyid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Change Picture</a>
										<cfelse>
							<a class=nav_bar href="" onClick="javascript: win=window.open('hostcompany/upload_picture.cfm?hostcompanyid=#url.hostcompanyid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="../pics/no_logo.jpg" width="135" border=0></a>
						</cfif></cfoutput>
										</td>
					  </tr> 
					  </table>
					
                        
                        
  </td>
					<td valign="top">
					
				<cfform name="form" id="form" method="post" action="index.cfm?curdoc=hostcompany/qr_updatehostcompanyprofile&amp;hostcompanyid=#url.hostcompanyid#">
						<table width="100%" cellpadding="2">
							<tr><td width="561" align="center"><cfoutput query="get_extrahostcompany"> 
						       <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Company: </font><cfinput type="text" name="name" value="#name#"></cfoutput>
					          <span class="style2"><br /> 
						    <cfoutput><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#get_extrahostcompany.phone# </font></span></cfoutput><br />
						    <br />
						    <font size=2 face="Verdana, Arial, Helvetica, sans-serif"><span class="edit_link"><br />
						 <!----   [  <a href='company_profile.cfm?companyid=#session.companyid#'>profile</a><a href='company_profile_pdf.cfm?companyid=#session.companyid#'><img src="../pics/pdficon_small.gif" border=0 /></a>]</span></font>---->						    <table width="76%" border=0 align="center" cellpadding=2 cellspacing=2 bordercolor="C7CFDC"  >
                              <tr>
                                <td width="100"><p><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Business:<br />   
                                  Date of Entry: <br />
                                  Entered by: </font></p></td>
                                <td width="325" valign="top"><cfoutput>
                                    <p><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                   
                                    <cfquery name="get_typebusiness" datasource="MySql">
										select business_typeid, business_type
                                   		from extra_typebusiness
                                        
                                    </cfquery>
                             <cfselect name="business">
                             <option value="0"></option>
                                  <cfloop query="get_typebusiness">
                               <option value="#business_typeid#" <cfif get_extrahostcompany.business_typeid eq business_typeid>selected</cfif>> #business_type#</option>
                                  </cfloop>
                             </cfselect>
                                  
                                   <br />

                                      #DateFormat(get_extrahostcompany.entrydate, "mm/dd/yyyy")# <br />
                                      #get_smguser.firstname# #get_smguser.lastname# </font></p></cfoutput></td>
                              </tr>
                            </table></td>
							</tr>
						</table>
					</td>
				</tr>
		  </table>
			
		</td>		
	</tr>
</table>
	</td>
							</tr>
						</table>
<br>



<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
							
                          <tr>
                            <td width="386" align="left" valign="top">
					       <!--- address --->  
<table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                             
                              <table width="98%" border=0 align="center" cellpadding=0 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                                <tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
                                  <td height="16" bgcolor="#8FB6C9" colspan="2" class="style1" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF"><b>:: Address</b></font></td>
                                </tr>
                                
                                <tr>
                                	<td >
                                   <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Address: </font><br />
									<font size="2" face="Verdana, Arial, Helvetica, sans-serif">City/State: </font> <br />
									<font size="2" face="Verdana, Arial, Helvetica, sans-serif">Zip Code:</font>
                                    </td>
                                 <td height="32"><cfoutput query="get_extrahostcompany"> <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                <cfinput type="text" name="address" value="#address#">
                                  <br />
                                  <cfinput type="text" name="city" value="#city#">
                                  <cfquery name="get_state" datasource="mysql">
											select id, state, statename
											from smg_states
											</cfquery>
                                  <br />
									<cfselect name="state">
                                  <option value=""></option>
                                  <cfloop query="get_state">
                                    <option value="#id#" <cfif get_extrahostcompany.state eq id>selected</cfif>>#state#</option>
                                  </cfloop>
                                  </cfselect>
                                  </font> 
<font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                    <cfinput type="text" name="zip" value="#zip#">
                                  </font>
                                  </tr>
                                  </cfoutput></td>
                              </tr>
                            </table></td>
                            </td>
							</tr>
						</table>
                        
                        <!--- close address ---->
                        
                        
                            <td width="384" align="right" valign="top">
                        <!--- contact info ---->    
                            <table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
						  <tr>
								<td bordercolor="FFFFFF">
                            
				          <table width="98%" border="0" align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                                <tr bgcolor="#C2D1EF">
                                  <td height="16" bgcolor="#8FB6C9" class="style1" colspan="3"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">:: Contact Info </font></strong></td>
                                </tr>
                                <tr>
                                  <td width="10%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
<br />

								
 Contact:
								  <br />

Phone:<br />
                                  Fax:<br />
                                  Email:<br /><br />

<br />


								  Supervisor:<br />
<br />

								  Supervisor Phone:<br />

								  Supervisor Email:<br />	<br />

								  Homepage: <br /><br />
								  Observations: </font></td>
                                  <td width="90%" height="48"><cfoutput query="get_extrahostcompany"> 
								  <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><br />

                                 <cfinput type="text" name="supervisor" value="#get_extrahostcompany.supervisor#">
								 <br />
								  <cfinput type="text" name="phone" value="#phone#" maxlength="25" onkeyup="javascript:backspacerUP(this,event); " onkeydown="javascript:backspacerDOWN(this,event);" onfocusin="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}"  onfocus="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}" id="txtDay" class="normalInputphone"  style="COLOR: 646464" />
                                  <br />
                                  <cfinput type="text" name="fax" value="#fax#" maxlength="25" onkeyup="javascript:backspacerUP(this,event); " onkeydown="javascript:backspacerDOWN(this,event);" onfocusin="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}"  onfocus="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}" id="txtDay" class="normalInputphone"  style="COLOR: 646464" />
                                  <br />
                                  <cfinput type="text" name="email" value="#email#"><br />
<br />
			
									<cfinput type="text" name="supervisor_name" value="#get_extrahostcompany.supervisor_name#">
									<br /><br />


									 <cfinput type="text" name="supervisor_phone" value="#get_extrahostcompany.supervisor_phone#" maxlength="25" onkeyup="javascript:backspacerUP(this,event); " onkeydown="javascript:backspacerDOWN(this,event);" onfocusin="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}"  onfocus="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}" id="txtDay" class="normalInputphone"  style="COLOR: 646464" /><br />


									 <br />
									 <cfinput type="text" name="supervisor_email" value="#get_extrahostcompany.supervisor_email#">
<br />
<br />


 
								  <cfinput type="text" name="homepage" value="#homepage#"><br /><br />


								  <cfinput type="text" name="observations" value="#observations#">
                                  </font></cfoutput></td>
                            </tr>
                            </table>
                            
                            </td>
							</tr>
						</table>
                            <!--- close contact info ----> 
                            <br /></td>
</tr>
                          <tr>
                            <td align="left" valign="top">
							 
                             <!--- housing ---->
                              <table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                             
                              <table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                              <tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
                                <td height="16" bgcolor="#8FB6C9" class="style1" colspan=4><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF"><b>:: Housing </b></font></td>
                              </tr>
                              <tr>
                                 
									<cfquery name="housing" datasource="mysql">
									  select type, id
									  from extra_housing							
									 </cfquery>
								  <cfoutput>
							
								 
                            
                            	<cfloop query="housing">
								<td height="32"> 
								  <input type="checkbox" name="housing" value="#id#" 
									     <cfif ListFind(get_extrahostcompany.housing_options, id , ",")>checked<cfelse></cfif> />
                              
								 </td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#type#</font></td>
								  
								 	 <cfif (housing.currentrow MOD 2) is 0></tr><tr></cfif>
								</cfloop> 
								
							 
								</td>
                              </tr>
                            </table></td>
                            	</td>
							</tr>
						</table>
						
						
						<table>
						<tr>
								<th><font size="1" face="Verdana, Arial, Helvetica, sans-serif">* Cost/Week:</font></th>
							 	<th><font size="1" face="Verdana, Arial, Helvetica, sans-serif">$ <cfinput name="housing_cost" value=#get_extrahostcompany.housing_cost# size="10" maxlength="9"></font></th>
						</tr>	
						</table>

						
						
						
							</cfoutput>
                            <!--- close housing --->
                            
                            <!---- jobs ---->
                            <td align="right" valign="top">
                            <table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                            
							<table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                              <tr bgcolor="#C2D1EF">
                                <td height="16" bgcolor="#8FB6C9" class="style1"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">:: Jobs </font></strong></td>
                              </tr>
                              <tr>
                                <td height="48">
								<table width="100%" border="0" >
                                  <tr>
                                    <td> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Job Title</u> </font></td>
                                    <td> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Wage</u></font></td>
                                  </tr>
								  <cfoutput query="get_extrajobs">
                                  <tr>
                                    <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><a href="" onClick="javascript: win=window.open('hostcompany/edit_newjob.cfm?jobid=#id#', 'Edit Job', 'height=400, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#title#</a></font><br /></td>
                                    <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#wage# / hour <!---#wage_type#----></font><br /></td>
                                  </tr>
								  </cfoutput>
								  <cfoutput>
                                  <tr>
                                    <td colspan="2"><div align="center"><cfif client.usertype LTE 4 >
									<a href="javascript:OpenHistory('hostcompany/add_newjob.cfm?hostcompanyid=#url.hostcompanyid#');"> <img src="../pics/add-job.gif" width="64" height="20" border="0" /></a></cfif></div></td>
                                  </tr>
								  </cfoutput>
                                </table></td>
                              </tr>
                            </table>
                            	</td>
							</tr>
						</table>
                            
                            <!--- close jobs --->
                            
                            <br />
                            <br /></td>
</tr>
                          <tr>
                            <td colspan="2" valign="top"><br />

						<!---- ticket 1041 ---------
						
							<!--- current trainee --->
                            	<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                            
                            <table width="100%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                              <tr bgcolor="#C2D1EF">
                                <td bgcolor="#8FB6C9" class="style1"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>:: Current Trainee </strong></font></td>
                              </tr>
                              <tr>
                                <td height="64"><cfif (get_currenttrainee9.RecordCount) eq 0>
								<font size="2" face="Verdana, Arial, Helvetica, sans-serif">No current Trainee now </font>
                                <cfelse>
								
                                    <table width="100%" border="0">
                                      <tr>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Program</u></font></td>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Trainee</u></font></td>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>End Date</u></font></td>
                                      </tr>
                                      <tr>
                                        <cfoutput query="get_currenttrainee9"><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#programname#</font></td>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><a href="index.cfm?curdoc=candidate/candidate_info&uniqueid=#uniqueid#">#get_currenttrainee9.firstname# #get_currenttrainee9.lastname# </a></font></td>
                                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#dateformat (enddate, 'mm/dd/yyyy')#</font></td>                                      </tr></cfoutput>
                                    </table>
                                  <br />
                                </cfif></td>
                              </tr>
                            </table>
                            
                            </td>
							</tr>
						</table>
                        
                        <!---- close current trainee ---> 
                        
							<br /></td>
                          </tr>

                          <tr>
                            <td colspan="2" valign="top">
					
                            <!--- upcoming trainee --->
                            
                            <table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                            
                            <table width="100%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                              <tr bgcolor="#C2D1EF">
                                <td height="16" bgcolor="#8FB6C9" class="style1"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">:: Upcoming Trainee </font></strong></td>
                              </tr>
                              <tr>
                                <td><CFIF (get_upcomingtrainee.RecordCount) eq 0 >
							<font size="2" face="Verdana, Arial, Helvetica, sans-serif">No upcoming Trainee now </font> 
								<cfelse> 
								<cfoutput query="get_upcomingtrainee2">
								  <table width="100%" border="0">
                                    <tr>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Program</u></font></td>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Trainee</u></font></td>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><u>Start Date</u></font></td>
                                    </tr>
                                    <tr>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#programname#</font></td>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname#</font></td>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#dateformat (startdate, 'mm/dd/yyyy')#</font></td>
                                    </tr>
                                  </table>
                                  
                                  </td>
							</tr>
						</table>
                        <!--- close upcoming trainee ---> 
                                  
								</cfoutput>
                                </cfif></td>
                              </tr>
                            </table>

						</td>
                          </tr> --------->
          </table><div align="center"> <input type="image" name="submit" src="../pics/save.gif" value="Update" />
          </div>
	</cfform>
		
                        
</tr>
    </table>
        <br />
      </div>
</body>
</html>
