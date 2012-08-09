<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Add New Host Company</title>

<!----auto tab script for phone number fields---->
<SCRIPT LANGUAGE="JavaScript">
<!-- Original:  Cyanide_7 (leo7278@hotmail.com) -->
<!-- Web Site:  http://members.xoom.com/cyanide_7 -->

<!-- Begin
var isNN = (navigator.appName.indexOf("Netscape")!=-1);
function autoTab(input,len, e) {
var keyCode = (isNN) ? e.which : e.keyCode; 
var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
if(input.value.length >= len && !containsElement(filter,keyCode)) {
input.value = input.value.slice(0, len);
input.form[(getIndex(input)+1) % input.form.length].focus();
}
function containsElement(arr, ele) {
var found = false, index = 0;
while(!found && index < arr.length)
if(arr[index] == ele)
found = true;
else
index++;
return found;
}
function getIndex(input) {
var index = -1, i = 0, found = false;
while (i < input.form.length && index == -1)
if (input.form[i] == input)index = i;
else i++;
return index;
}
return true;
}
//  End -->
</script>

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
<link href="../style.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {
	font-weight: bold;
	font-style: normal;
	font: arial;
}
body,td,th {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.style2 {font-family: Arial, Helvetica, sans-serif}
-->
</style>
<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" bgcolor="#FFFFFF">
  <tr>
    <td bordercolor="#FFFFFF">
	

<cfoutput>
<table width=95% height="18" border=0 align="center" cellpadding=0 cellspacing=0>
	<tr valign=middle height=24>
		<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1"><strong>Add &nbsp;Host Company </strong></td>
		<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">&nbsp;</td>
		<td width="1%"></td>
	</tr>
</table>
<br>
<cfquery name="business_type" datasource="mysql">
select business_typeid, business_type
from extra_typebusiness

</cfquery>

<cfquery name="get_state" datasource="mysql">
select id, state, statename
from smg_states
</cfquery>



<cfform name="form" method="post" action="hostcompany/qr_inserthostcompany.cfm">
				<!--- PERSONAL INFO --->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="90%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF" width=50% valign="top">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="C2D1EF" bordercolor="FFFFFF">
												<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Company Information</td>
											</tr>
											   <tr>
												  <th>Name</th>
												  <th><cfinput type="text" name="name" message="Company name is required." required="yes" size="25"  maxlength="200"></th>
												</tr>
													<tr class="style1">
												  <th>Business Type </th>
												  <th>
													  <cfselect name="business_type">
													  <cfloop query="business_type">
													  <option value="#business_typeid#">#business_type#</option>
													  </cfloop>
													  <option value=00>Other*</option>
													  </cfselect>       </th>
												</tr>
												 <tr class="style1">
												  <th>*Specify if Other </th>
												  <th><input type="text" size=25 name="other"></th>
												</tr>
												<tr>
												  <th>Address</th>
												  <th><cfinput name="address" size="25"  maxlength="200"></th>
												</tr>
												<tr>
												  <th>City, State</th>
												  <th><cfinput name="city" size="15"  maxlength="100">&nbsp;&nbsp; 
												  <cfselect name="state">
												  	  <option value=""></option>
													  <cfloop query="get_state">
													  <option value="#id#">#state#</option>
													  </cfloop>
												  </cfselect></th>
												</tr>
												<tr>
												  <th>ZIP</th>
												  <th><cfinput name="zip" size="25"  maxlength="50"></th>
												</tr>
												
												<tr>
												  <th>Contact</th>
												  <th><cfinput name="supervisor" size="25"  maxlength="50"></th>
										  		</tr>
												
												
												<tr>
												  <th>Phone</th>
												  <th><cfinput type="text" name="phone" value="NNNXXXNNNN" maxlength="25" size=25 onkeyup="javascript:backspacerUP(this,event); " onkeydown="javascript:backspacerDOWN(this,event);" onfocusin="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}"  onfocus="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}" id="txtDay" class="normalInputphone"  style="COLOR: 646464" /></th>
												</tr>
												<tr>
												  <th>Fax</th>
												  <th><cfinput type="text" name="fax" value="NNNXXXNNNN" maxlength="25" size=25 onkeyup="javascript:backspacerUP(this,event); " onkeydown="javascript:backspacerDOWN(this,event);" onfocusin="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}"  onfocus="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}" id="txtDay" class="normalInputphone"  style="COLOR: 646464" /></th>
												</tr>
												<tr>
												  <th>Email</th>
												  <th><cfinput name="email" size="25" maxlength="100"></th>
												<tr>
												  <th>Homepage</th>
												  <th><cfinput name="homepage" size="25"  maxlength="100"></th>
												</tr>
												
										  		<tr>
													<th>Supervisor</th>
													<th><cfinput name="supervisor_name" size="25" maxlength="50"></th>
												</tr>
												<tr>
												  <th>Supervisor Phone </th>
												  <th><cfinput name="supervisor_phone" value="NNNXXXNNNN" maxlength="25" size=25 onKeyUp="javascript:backspacerUP(this,event); " onKeyDown="javascript:backspacerDOWN(this,event);" onfocusin="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}"  onFocus="javascript:if (this.value=='NNNXXXNNNN') {this.value='';this.style.color='000000';}" id="txtDay" class="normalInputphone"  style="COLOR: 646464" /></th>
										  </tr>
												<tr>
												  <th>Supervisor Email </th>
												  <th><cfinput name="supervisor_email" size="25"  maxlength="100"></th>
										  </tr>
												<tr>
												  <th>Observations</th>
												  <th><textarea name="observations" rows="5"  cols="20"></textarea></th>
										  </tr>
												</table>


  
  </td>
<td width=10>
</td>
<td valign="top" bordercolor="FFFFFF" bgcolor="FFFFFF">
<!---<table width="100%" cellpadding=5 cellspacing=0 border=0>---->

						<!---<th>Closest Airport </th>
				 
				  <th><cfinput name="arrivalAirport" size="25"  maxlength="50"></th>
												</tr>			
				
		--->		
		
		
		 <!---- Housing --->
                              <table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
                             
                              <table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="C7CFDC" bgcolor="ffffff">
                              <tr class="style1" bordercolor="FFFFFF" bgcolor="C2D1EF">
                                <td height="16" bgcolor="8FB6C9" class="style1" colspan=4><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="FFFFFF"><b>:: Housing </b></font></td>
                              </tr>
                              <tr>
                                 
									<cfquery name="housing" datasource="mysql">
									  select type, id
									  from extra_housing							
									 </cfquery>
								
							
							   	<cfloop query="housing">
								<td height="32"> 
								  <input type="checkbox" name="housing" value="#id#"/>
                              
								 </td><td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">#type#</font></td>
								  
								 	 <cfif (housing.currentrow MOD 2) is 0></tr><tr></cfif>
								</cfloop> 
								
															 
								</td>
                              </tr>
							  
							
							  <br>
							 
							 
							  
                            </table>
							
							 
							 
							</td>
                           	</td>
							</tr>
						
											
						</table>
						
						
						<br>
						
						<table>
						
						<tr>
								<th>Cost/Week:</th>
							 	<th><cfinput name="housing_cost" size="10" maxlength="9"></th>
						</tr>	
						</table>
						
						<!---- housing close--->
		
		<br>
		
		<!---- jobs---
		
                            
                            	<table cellpadding=5 cellspacing=5 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
						  <tr>
								<td bordercolor="FFFFFF">
                            
                            
							<table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="C7CFDC" bgcolor="ffffff">
                              <tr bgcolor="C2D1EF">
                                <td height="16" bgcolor="8FB6C9" class="style1"><strong><font color="FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">:: Jobs </font></strong></td>
                              </tr>
                             <input type=hidden value="job">
							<cfinput type="hidden" name="hostcompanyid" value="#url.hostcompanyid#">

							  <tr>
                                <td height="48">
								<table width="100%" border="0" >
                                  <tr>
                                    <td> <p align="center"><input name="Submit" type="image" value="addjob" src="../pics/add-job.gif" alt="Add job to this Company" border="0"></p></font>
									<br><font size="-2" color="999999">Please, first fill out the Company Information and Housing, then add a Job.</font></td>
                                   
                                  </tr>
								 

		
		
		------>
		
		
		

			<tr>
				<td><!----<br>
			      <br>
	            <font color="##CCCCCC">Created: #DateFormat(now(),'mm/dd/yyyy')#  ----></td>
			</tr>
			 </table>

  </td>
 </tr>
 			<tr>
						
					</tr>
 </table>

<p align="center"> <input name="Submit" type="image" value="next" src="../pics/save.gif" alt="Next" border="0"></p>
  
<br>

<!--- <cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry> --->		</td>
  </tr>
</table></td></tr></table>
</cfform>
  </cfoutput>
</html>