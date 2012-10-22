<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CSB International: Summer Work Travel Program</title>
<style type="text/css">
<!--
.text {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	text-align: left;
	font-weight: bold;
}
.textCenter {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	text-align: center;
	font-weight: bold;
}
-->
</style>
<script>
function test(){
	with (document.form) {
		if (firstname.value == '') {
			alert("FIRST NAME is Required");
			firstname.focus();
			return false;
		}
		if (lastname.value == '') {
			alert("LAST NAME is Required");
			lastname.focus();
			return false;
		}
		if (email.value == '') {
			alert("EMAIL is Required");
			email.focus();
			return false;
		}
		if (street.value == '') {
			alert("STREET ADDRESS is Required");
			street.focus();
			return false;
		}
		if (city.value == '') {
			alert("CITY is Required");
			city.focus();
			return false;
		}
		if (state.value == '') {
			alert("STATE is Required");
			state.focus();
			return false;
		}
		if (zip.value == '') {
			alert("ZIP CODE is Required");
			zip.focus();
			return false;
		}
	}
}

function testChangeAdrress(){
	with (document.formChangeAdrress) {
		if (firstname2.value == '') {
			alert("FIRST NAME is Required");
			firstname2.focus();
			return false;
		}
		if (lastname2.value == '') {
			alert("LAST NAME is Required");
			lastname2.focus();
			return false;
		}
		if (email2.value == '') {
			alert("EMAIL is Required");
			email2.focus();
			return false;
		}
		if (company.value == '') {
			alert("COMPANY is Required");
			company.focus();
			return false;
		}
		if (compaddress.value == '') {
			alert("COMPANY'S STREET ADDRESS is Required");
			compaddress.focus();
			return false;
		}
		if (compcity.value == '') {
			alert("COMPANY'S CITY is Required");
			compcity.focus();
			return false;
		}
		if (compstate.value == '') {
			alert("COMPANY'S STATE is Required");
			compstate.focus();
			return false;
		}
		if (compzip.value == '') {
			alert("COMPANY'S ZIP CODE is Required");
			compzip.focus();
			return false;
		}
		if (compcontact.value == '') {
			alert("COMPANY'S PRIMARY CONTACT is Required");
			compcontact.focus();
			return false;
		}
		if (comphone.value == '') {
			alert("COMPANY'S PHONE NUMBER is Required");
			comphone.focus();
			return false;
		}
		if (housingaddress.value == '') {
			alert("HOUSING ADDRESS is Required");
			housingaddress.focus();
			return false;
		}
		if (housingcity.value == '') {
			alert("HOUSING CITY is Required");
			housingcity.focus();
			return false;
		}
		if (housingstate.value == '') {
			alert("HOUSING STATE is Required");
			housingstate.focus();
			return false;
		}
		if (housingzip.value == '') {
			alert("HOUSING ZIP CODE is Required");
			housingzip.focus();
			return false;
		}
	}
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}


</script>


<link href="../css/csbusa.css" rel="stylesheet" type="text/css" />
<cfinclude template="includes/superfish_js.cfm">
</head>

<body class="oneColFixCtrHdr">
<cfinclude template="Theader.cfm">
<div class="clearfixG">Trainee Program</div>
<div id="container">
<div id="tabsDiv"><cfinclude template="includes/t_menu.cfm"></div>
<div class="clearfixFillG"></div>
<div id="mainContent">
<h2>Trainee Program Check-In</h2>
<p><u>&#x2713;CHECK-IN / VALIDATION <strong>(at arrival in the United States) </strong></u><br>
	In order to keep your visa from being cancelled by the SEVIS system, CSB must validate your visa within 30 days from the start date on the DS-2019. Please CHECK-IN in maximum 10 days from your arrival date in U.S.A. by filling in all the below fields and submitting the form. If you have questions or concerns, please call 1-877-669-0717 (Toll-Free).</p>
	          <p class="text"> * Required<br>
              </p>
	<form action="submit_request.cfm?request=checkin" method="post" name="form" id="form" onSubmit="return test()"> 
			      <table width="85%" align="center">
  <tr>
    <td  class="text">SEVIS Number:&nbsp;</td>
    <td width="355" class="text">
      <input name="sevis" type="Text" class="text" id="sevis" size="50" maxlength="50">
     <a href="javascript:MM_openBrWindow('images/ds-2019.jpg','ds2019','width=635,height=467')"><img src="images/question.gif" width="15" height="15" border="0"> What is this?</a></td>
  </tr>
  <tr>
    <td class="text">Last Name:*</td>
    <td class="text">
      <input name="lastname" type="Text" class="text" id="lastname" size="50" maxlength="50" required="yes">    </td>
  </tr>
  <tr>
    <td class="text">First Name: *</td>
    <td class="text">
      <input name="firstname" type="Text" class="text" id="firstname" size="50" maxlength="50" required="yes">    </td>
  </tr>
  <tr>
    <td class="text">Middle Name:&nbsp;
    </td>
    <td class="text">
        <input name="middlename" type="Text" class="text" id="middlename" size="50" maxlength="50">
        
  <tr>
    <td class="text">E-Mail Address:*</td>
    <td class="text"><input name="email" type="Text" class="text" id="email" size="50" maxlength="50" required="yes"></td>
  </tr>
  <tr>
    <td height="17" colspan="2" class="textCenter">&nbsp;</td>
  </tr>
  <tr>
    <td height="17" colspan="2" bgcolor="#CCCCCC" class="textCenter">&nbsp;Housing Information:<br></td>
  </tr>
  <tr>
    <td colspan="2" class="text">(please provide the address where you currently live in the United States)</td>
    </tr>
  <tr>
    <td class="text">Street Address:&nbsp;*</td>
    <td class="text"><input name="street" type="Text" class="text" id="street" size="50" maxlength="50">    </td>
  </tr>
  <tr>
    <td class="text">City:*</td>
    <td class="text">
      <input name="city" type="Text" class="text" id="city" size="50" maxlength="50">    </td>
  </tr>
  <tr>
    <td class="text">State:*</td>
    <td class="text"><select name="state" size="1" class="text">
      <option value="">
      <option value="AL"> Alabama
              <option value="AK"> Alaska
              <option value="AZ"> Arizona
              <option value="AR"> Arkansas
              <option value="CA"> California
              <option value="CO"> Colorado
              <option value="CT"> Connecticut
              <option value="DE"> Delaware
              <option value="DC"> District of Columbia
              <option value="FL"> Florida
              <option value="GA"> Georgia
              <option value="HI"> Hawaii
              <option value="ID"> Idaho
              <option value="IL"> Illinois
              <option value="IN"> Indiana
              <option value="IA"> Iowa
              <option value="KS"> Kansas
              <option value="KY"> Kentucky
              <option value="LA"> Louisiana
              <option value="ME"> Maine
              <option value="MD"> Maryland
              <option value="MA"> Massachusetts
              <option value="MI"> Michigan
              <option value="MN"> Minnesota
              <option value="MS"> Mississippi
              <option value="MO"> Missouri
              <option value="MT"> Montana
              <option value="NE"> Nebraska
              <option value="NV"> Nevada
              <option value="NH"> New Hampshire
              <option value="NJ"> New Jersey
              <option value="NM"> New Mexico
              <option value="NY"> New York
              <option value="NC"> North Carolina
              <option value="ND"> North Dakota
              <option value="OH"> Ohio
              <option value="OK"> Oklahoma
              <option value="OR"> Oregon
              <option value="PA"> Pennsylvania
              <option value="RI"> Rhode Island
              <option value="SC"> South Carolina
              <option value="SD"> South Dakota
              <option value="TN"> Tennessee
              <option value="TX"> Texas
              <option value="UT"> Utah
              <option value="VT"> Vermont
              <option value="VA"> Virginia
              <option value="WA"> Washington
              <option value="WV"> West Virginia
              <option value="WI"> Wisconsin
              <option value="WY"> Wyoming
              </select>    </td>
  </tr>
  <tr>
    <td class="text">Zip Code:*</td>
    <td class="text">
      <input name="zip" type="Text" class="text" id="zip" size="50" maxlength="50">    </td>
  </tr>
  <tr>
    <td class="text">Phone Number:</td>
    <td class="text"><input name="phone" type="Text" class="text" id="phone" size="50" maxlength="50"></td>
  </tr>
  <tr>
    <td valign="top" class="text">Comments:</td>
    <td class="text">
      <textarea name="comment" cols="50" rows="5" wrap="VIRTUAL" class="text"></textarea>    </td>
  </tr>
  <tr>
    <td colspan="2" align="center" bgcolor="#CCCCCC" class="textCenter">
      <input name="submit" type="Submit" class="text" value="Submit">    </td>
  </tr>
</table>
</form>
                  <hr width="95%" color="#000099" align="center"> <br />                 
  To keep your information updated in the SEVIS system while you are in the United States, you must notify CSB of any changes related to your housing address.<br /> <br />   
                 
<form action="submit_request.cfm?request=change" method="post" enctype="multipart/form-data" name="formChangeAdrress" onSubmit="return testChangeAdrress()">
                  <cfset filepath = expandpath('/var/www/html/intoedventures/uploaded/job-offers/')>
                  <table width="85%" align="center">
                   
                                      <tr>
                                        <td height="25" colspan="2" bgcolor="#CCCCCC" class="textCenter">New Housing Information:</td>
                                      </tr>
                                      <tr>
                                        <td class="text">Street Address:&nbsp;*</td>
                                        <td class="text"><input name="housingaddress" type="Text" class="text" id="housingaddress" size="50" maxlength="50"></td>
                                      </tr>
                                      <tr>
                                        <td class="text">City:&nbsp;*</td>
                                        <td class="text"><input name="housingcity" type="Text" class="text" id="housingcity" size="50" maxlength="50"></td>
                                      </tr>
                                      <tr>
                                        <td class="text">State:&nbsp;*</td>
                                        <td class="text"><select name="housingstate" size="1" class="text" id="housingstate">
                                          <option value="">
                                          <option value="AL"> Alabama
	                                      <option value="AK"> Alaska
	                                      <option value="AZ"> Arizona
	                                      <option value="AR"> Arkansas
	                                      <option value="CA"> California
	                                      <option value="CO"> Colorado
	                                      <option value="CT"> Connecticut
	                                      <option value="DE"> Delaware
	                                      <option value="DC"> District of Columbia
	                                      <option value="FL"> Florida
	                                      <option value="GA"> Georgia
	                                      <option value="HI"> Hawaii
	                                      <option value="ID"> Idaho
	                                      <option value="IL"> Illinois
	                                      <option value="IN"> Indiana
	                                      <option value="IA"> Iowa
	                                      <option value="KS"> Kansas
	                                      <option value="KY"> Kentucky
	                                      <option value="LA"> Louisiana
	                                      <option value="ME"> Maine
	                                      <option value="MD"> Maryland
	                                      <option value="MA"> Massachusetts
	                                      <option value="MI"> Michigan
	                                      <option value="MN"> Minnesota
	                                      <option value="MS"> Mississippi
	                                      <option value="MO"> Missouri
	                                      <option value="MT"> Montana
	                                      <option value="NE"> Nebraska
	                                      <option value="NV"> Nevada
	                                      <option value="NH"> New Hampshire
	                                      <option value="NJ"> New Jersey
	                                      <option value="NM"> New Mexico
	                                      <option value="NY"> New York
	                                      <option value="NC"> North Carolina
	                                      <option value="ND"> North Dakota
	                                      <option value="OH"> Ohio
	                                      <option value="OK"> Oklahoma
	                                      <option value="OR"> Oregon
	                                      <option value="PA"> Pennsylvania
	                                      <option value="RI"> Rhode Island
	                                      <option value="SC"> South Carolina
	                                      <option value="SD"> South Dakota
	                                      <option value="TN"> Tennessee
	                                      <option value="TX"> Texas
	                                      <option value="UT"> Utah
	                                      <option value="VT"> Vermont
	                                      <option value="VA"> Virginia
	                                      <option value="WA"> Washington
	                                      <option value="WV"> West Virginia
	                                      <option value="WI"> Wisconsin
	                                      <option value="WY"> Wyoming
                                        </select></td>
                                      </tr>
                                      <tr>
                                        <td class="text">Zip code:&nbsp;*</td>
                                        <td class="text"><input name="housingzip" type="Text" class="text" id="housingzip" size="50" maxlength="50"></td>
                                      </tr>
                                      <tr>
                                        <td class="text">Phone Number:&nbsp;</td>
                                        <td class="text"><input name="housingphone" type="Text" class="text" id="housingphone" size="50" maxlength="50"></td>
                                      </tr>                                      
                                      <tr>
                                        <td height="32" colspan="2" align="center" bgcolor="#CCCCCC" class="textCenter"><input type="Submit" class="text" value="Submit"></td>
                                      </tr>
                  </table>
    </form>
    
  <!-- end mainContent --></div>
  
  <div class="clearfix"></div>
<!-- end container --></div>
<div class="clearfixT"></div>
<cfinclude template="../footer.cfm">
<div class="gStrip"></div>
</body>
</html>
