
<CFIF not isdefined("url.action")>
	<CFSET url.action = "">
</cfif>

<!-----Script to show certain fileds---->
<script type="text/javascript">
<!--

function changeDiv(the_div,the_change)
{
  var the_style = getStyleObject(the_div);
  if (the_style != false)
  {
    the_style.display = the_change;
  }
}

function hideAll()
{
  changeDiv("1","none");
  changeDiv("2","none");

}

function getStyleObject(objectId) {
  if (document.getElementById && document.getElementById(objectId)) {
    return document.getElementById(objectId).style;
  } else if (document.all && document.all(objectId)) {
    return document.all(objectId).style;
  } else {
    return false;
  }
}
// -->
</script>


</head>


<cfif url.action is ''>
<cfset temp = "temp">
<cfset temp_password = "#temp##RandRange(100000, 999999)#">

<cfform action="?curdoc=querys/insert_user_info" method="POST" name="one"> 
<cfquery name="usertype" datasource="MySQL">
select *
from smg_usertype
</cfquery>


<div class="form_section_title"><h3>User Type</h3></div>
<table>
	<Tr>
<cfoutput query="usertype">
<Cfif #usertypeid# lt #client.usertype#><Cfelse>
<cfif usertype.currentrow mod 2>
<tr>
</cfif>
<td>

<cfinput type="radio" name="usertype" value=#usertypeid# 
	onClick="hideAll(); changeDiv('#formtype#','block');" message="Please select a user type." required="yes" disabled="true">#usertype#
</td>

</cfif>
</cfoutput>

	</Tr>
</table>

<div id ="1" style="display:none">
<div class="form_section_title"><h3>Personal Information</h3></div>


<table>
	<tr>	
		<td align="right">First Name:</td><Td align="left"> <cfinput type=text name="user_first_name" size=20> </td>
	</tr>
	<Tr>
		<td align="right">Last Name: </td><td align="left"><cfinput type=text name="user_last_name" size=20></td>
	</tr>

	<tr>
		<td align="right">Address:</td><td align="left"><cfinput type=text name="address" size=30></td>
	</tr>
	<tr>
		<td align="right"></td><td align="left"><cfinput type=text name=address2 size=30></td>
	</tr>
	<tr>
		<td align="right">	City</td><td align="left"><cfinput type=text name=city size=15> State <cfinput type=text name=state size=2></td>
	</tr>
	<tr>
		<td align="right">Zip</td><td> <cfinput type=text name=zip size=10></td>		
	</tr>
	</table>
<div class="form_section_title"><h3>Employement Information</h3></div>
<table>
	<tr>	
		<td align="right">Occupation/Title:</td><Td align="left"> <cfinput type=text name="occupation" size=20></td>
	</tr>
	<Tr>
		<td align="right">Company Name: </td><td align="left"><cfinput type=text name="businessname" size=20></td>
	</tr>
</table>
<br>
<div class="form_section_title"><h3>Misc Information</h3></div>
<table>
	<tr>	
		<td align="right">Sex:</td><Td align="left"> <cfinput type="radio" name="Sex" value="male">Male <cfinput type="radio" name="Sex" value="female">Female</td>
	</tr>
	<Tr>
		<td align="right">Social Security: </td><td align="left"><cfinput type=text name="ssn" size=11></td>
	</tr>
</table>
	</div>
	
	<div id ="2" style="display:none">
	<div class="form_section_title"><h3>Company Information</h3></div>


<table>
	<tr>	
		<td align="right">Contact First Name:</td><Td align="left"> <cfinput type=text name="contact_first_name" size=20></td>
	</tr>
	<Tr>
		<td align="right">Contact Last Name: </td><td align="left"><cfinput type=text name="contact_last_name" size=20></td>
	</tr>
	<Tr>
		<td align="right">Company Name: </td><td align="left"><cfinput type=text name="companyname" size=20></td>
	</tr>
	<tr>
		<td align="right">Address:</td><td align="left"><cfinput type=text name="companyaddress" size=30></td>
	</tr>
	<tr>
		<td align="right"></td><td align="left"><cfinput type=text name=companyaddress2 size=30></td>
	</tr>
	<tr>
		<td align="right">	City</td><td align="left"><cfinput type=text name=intcity size=30> </td>
	</tr>
	<tr>
		<td align="right">	Country</td><td align="left"><cfinput type=text name=country size=30> </td>
	</tr>
	<tr>
		<td align="right">Zip</td><td> <cfinput type=text name=companyzip size=10></td>		
	</tr>
	</table>
	
	</div>
	<br><br>
<div class="form_section_title"><h3>Contact Information</h3></div>
<table>
	<tr>	
		<td align="right">Email:</td><Td align="left"> <cfinput type=text name="email" size=20 onchange="javascript:copy()"> login information will be sent on creation of account.</td>
	</tr>
	<tr>
		<td align="right">Username:</td><Td align="left"> <cfinput type=text name="username" size=20> defualts to email address, change if desired</td>
	</tr>
	<tr>	
		<td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Phone:</td><Td align="left"> <cfinput type=text name="phone" size=20 value=800.766.4656></td>
	</tr>
	<tr>	
		<td align="right">Fax:</td><Td align="left"> <cfinput type=text name="fax" size=20></td>
	</tr>
</table>
<br>
<cfinput type="checkbox" name="listing" value="yes" checked>include information in online phone book (accessable only to employees & field)<br>

<Cfoutput><input type="hidden" value="#temp_password#" name="password"></Cfoutput>
<br>
<div class="button" align="right"><input type="submit" value=" Next "></div>

</cfform>

<SCRIPT LANGUAGE="javascript">

   function copy()

   {

document.one.username.value = document.one.email.value;



}

</SCRIPT>
</cfif>
