<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Student Tours General Questions</title>
<meta name="description" content="International Student Exchange Student Tours"/>

<meta name="keywords" content="Trips, Vacation, student Tours, Student Trips"/>
<style type="text/css">
<!--
-->
</style>

<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	color: #000;
	text-decoration: none;
}
a:hover {
	color: #0B954E;
	text-decoration: none;
}
a {
	font-weight: bold;
}
a:active {
	text-decoration: none;
}
.whtMiddle1 {
	background-image: url(../images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	height: 2000px;
	width: 746px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
}
-->
</style></head>
<script src="../flash/menu.js"></script>

<script language="JavaScript">
	var r_text = new Array ();
	r_text[0] = "house";
	r_text[1] = "car";
	r_text[2] = "student";
	r_text[3] = "exchange";
	r_text[4] = "flag";
	r_text[5] = "trip";
	r_text[6] = "school";
	r_text[7] = "many";
	r_text[8] = "hours";
	r_text[9] = "computer";
	r_text[10] = "square";
	var i = Math.round(10*Math.random());

    function DrawBotBoot()
    {
        document.write(r_text[i]);
    } 
	
	function validaForm(){

		d = document.form;

		if (d.firstname.value == ""){
			alert("First Name");
			d.firstname.focus();
			return false;
		}
		if (d.lastname.value == ""){
			alert("Last Name");
			d.lastname.focus();
			return false;
		}
		if (d.birth.value == ""){
			alert("Date of Birth");
			d.birth.focus();
			return false;
		}
		if (!d.payment[0].checked && !d.payment[1].checked && !d.payment[2].checked && !d.payment[3].checked && !d.payment[4].checked) {
			alert("Payment Method")
			return false;
		}
		if (!d.charge[0].checked && !d.charge[1].checked && !d.charge[2].checked) {
			alert("Charge for")
			return false;
		}
		if (!d.sex[0].checked && !d.sex[1].checked) {
			alert("Sex")
			return false;
		}
		if (!d.americomp[0].checked && !d.americomp[1].checked && !d.americomp[2].checked && !d.americomp[3].checked) {
			alert("American Company")
			return false;
		}
        if (d.word.value != r_text[i]) {
			alert("Please, Type the word on the Box!")
			d.word.focus();
			return false;    
		}    
		
		return true;
	}
</script>

</HEAD>
<body class="oneColFixCtr">
<cfquery name="tours" datasource="mysql">
	SELECT *
	FROM smg_tours
	WHERE tour_status <> 'Inactive'
	ORDER BY tour_name
</cfquery>

<div id="topBar">
<cfinclude template="../topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="../images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="titleTrips.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="../tabsBar.cfm"><!-- end tabsBar --></div>
<div id="mainContent">
    <div id="subPages">
      <div class="whtTop"></div>
      <div class="whtMiddle1">
        <div class="trips">
        <br>
        <span class="style3"><h1 allign="center">Deposit Form </h1><br>
        </span><br>
        <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td class="style1"><div align="center"> 
              <p align="center" class="style3">Use this form to reserve the tour you want. Your early deposit holds your place.</p>
							<form action="submit_request.cfm" method="post" name="form" onSubmit="return validaForm()"> 
              <table width="90%" border="0" cellspacing="0" cellpadding="1">
                <tr>
                  <td width="27%"><div align="right"><span class="style3"><strong>Payment options:</strong></span></div></td>
                  <td width="73%" class="style3"><input name="payment" type="radio" value="Check">
                  
                    Check </td>
                </tr>
                <tr>
                  <td><div align="right"></div></td>
                  <td class="style3"><input name="payment" type="radio" value="Money Order"> 
                    Money Order </td>
                </tr>
                <tr>
                  <td><div align="right"></div></td>
                  <td class="style3"><input name="payment" type="radio" value="Visa">
                    Visa</td>
                </tr>
                <tr>
                  <td rowspan="2"><div align="right"></div></td>
                  <td class="style3"><input name="payment" type="radio" value="MasterCard">
                    MasterCard </td>
                </tr>
                <tr>
                  <td class="style3"><input name="payment" type="radio" value="American Express"> 
                    American Express</td>
                </tr>
                <tr>
                  <td><div align="right"><span class="style3"><strong>Card #: </strong></span></div></td>
                  <td>&nbsp;<input name="card" type="text" id="card" size="40"></td>
                </tr>
                <tr>
                  <td><div align="right" class="style3"><strong>Expires: </strong></div></td>
                  <td>&nbsp;<input name="expires" type="text" id="expires" size="20"></td>
                </tr>
                <tr>
                  <td><div align="right"><span class="style3"><strong>Name on Card: </strong></span></div></td>
                  <td>&nbsp;<input name="name" type="text" id="name" size="40"></td>
                </tr>
                <tr>
                  <td><div align="right"><span class="style3"><strong>Charge my card for :</strong></span></div></td>
                  <td><span class="style3">
                    <input name="charge" type="radio" value="The Full Amount">
                    The Full Amount </span></td>
                </tr>
                <tr>
                  <td><div align="right"></div></td>
                  <td><span class="style3">
                    <input name="charge" type="radio" value="$100 Deposit Per Tour">
                    $100 Deposit Per Tour </span></td>
                </tr>
                <tr>
                  <td><div align="right"></div></td>
                  <td><span class="style3">
                    <input name="charge" type="radio" value="Other">
                    Other 
                    <input name="other" type="text" id="other" size="30">
                  </span></td>
                </tr>
                <tr>
                  <td><div align="right"></div></td>
                  <td><span class="style3">
                    <input name="americomp" type="hidden" value="ISE">
                  NO DEBIT CARDS</span></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><span class="style3"><strong>USA Rep Name: </strong></span></div></td>
                  <td class="style3">&nbsp;
                    <input name="repName" type="text" id="repName" size="40"></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><strong>USA Rep Phone:</strong></div></td>
                  <td class="style3">&nbsp;
                    <input name="phone2" type="text" id="phone2" size="40"></td>
                </tr>
                <tr>
                  <td height="38" colspan="2"><div align="center" class="style3"><strong>Personal Information </strong></div></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><span class="style3"><strong>Date of Birth: </strong></span></div></td>
                  <td class="style3"><span class="style3">&nbsp;<input name="birth" type="text" id="birth" size="20">
                      mm/dd/yyyy</span></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><span class="style3"><strong>Male</strong></span></div></td>
                  <td class="style3"><span class="style3"><strong>
                    <input name="sex" type="radio" value="Male">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Female 
                    <input name="sex" type="radio" value="Female">
                  </strong></span></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><span class="style3"><strong>Last Name: </strong></span></div></td>
                  <td class="style3">&nbsp;<input name="lastname" type="text" id="lastname" size="40"></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><span class="style3"><strong>First Name: </strong></span></div></td>
                  <td class="style3">&nbsp;<input name="firstname" type="text" id="firstname" size="40"></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><span class="style3"><strong>Host Family Name: </strong></span></div></td>
                  <td class="style3">&nbsp;<input name="hostname" type="text" id="hostname" size="40"></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><strong>Street:</strong></div></td>
                  <td class="style3">&nbsp;<input name="street" type="text" id="street" size="40"></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><strong>City:</strong></div></td>
                  <td class="style3">&nbsp;<input name="city" type="text" id="city" size="40"></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><strong>State:</strong></div></td>
                  <td class="style3">&nbsp;
                    <select name="state" size="1">
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
                  <td class="style3"><div align="right"><strong>Zip:</strong></div></td>
                  <td class="style3">&nbsp;<input name="zip" type="text" id="zip" size="20"></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><strong>Student email: </strong></div></td>
                  <td class="style3">&nbsp;<input name="studentemail" type="text" id="studentemail" size="40"></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><strong>Host email: </strong></div></td>
                  <td class="style3">&nbsp;<input name="hostemail" type="text" id="hostemail" size="40"></td>
                </tr>
                <tr>
                  <td class="style3"><div align="right"><strong>Phone:</strong></div></td>
                  <td class="style3">&nbsp;<input name="phone" type="text" id="phone" size="40"></td>
                </tr>
                <tr>
                  <td colspan="2" class="style3">Airline tickets are cheaper when booked ahead.</td>
                  </tr>
                <tr>
                  <td class="style3"><div align="right"><strong>State:</strong></div></td>
                  <td><select name="stateaiport" size="1" id="stateaiport">
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
                  <td class="style3"><div align="right"><strong>Airport:</strong></div></td>
                  <td><span class="style3">
                    <input name="airport" type="text" id="airport" size="40">
                  </span></td>
                </tr>
                <tr>
                  <td height="32" colspan="2" class="style3"><div align="center"><strong>Indicate which trip(s) you are taking: </strong></div></td>
                  </tr>
                <tr>

				  <cfoutput>                  
				  <cfset num = 1>
							  
				  <cfloop query="tours">
				  <tr>
					<td class="style1"><div align="right"><strong><input name="tour" type="checkbox" id="tour" value=" #Replace(tour_name, ('!company!'), 'ISE', 'ALL')#">&nbsp;</strong></div></td>
					<td class="style1">#Replace(tour_name, ("!company!"), "SMG", "ALL")#</td>
				  </tr>
				  <cfset num = num+1>
				  </cfloop>
				  </cfoutput>
				  
                <tr>
                  <td height="110" colspan="2" class="style3"><div align="center">
                    <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9E9E9">
                      <tr>
                        <td height="27"><div align="center" class="style3"><strong>Please type the word now showing in the left box into the right box and   hit submit</strong>:</div></td>
                      </tr>
                      <tr>
                        <td height="60"><table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr>
                            <td width="50%"><div align="center">
                                <table width="90%" border="1" cellpadding="5" cellspacing="0" bordercolor="#000066">
                                  <tr>
                                    <td><div align="center" class="style14"><script type="text/javascript">DrawBotBoot()</script></div></td>
                                  </tr>
                                </table>
                            </div></td>
                            <td width="50%"><div align="center">
                                <input name="word" type='text' class="style3" id='word' size='15' maxlength='15'/>
								<input name="required" type="hidden" class="style1" id='required'/>
								<input name="emailRequired" type="hidden" class="style1" id='emailRequired'/>
                            </div></td>
                          </tr>
                        </table></td>
                      </tr>
                    </table>
                  </div></td>
                  </tr>
                <tr>
                  <td height="40" colspan="2" class="style3"><div align="center">
                    <input type="submit" name="Submit" value="Submit">
                  </div></td>
                </tr>
              </table>
              </form>
              <table width="80%" border="0" cellpadding="3" cellspacing="1" bordercolor="#666666" bgcolor="#666666">
                <tr>
                  <td bgcolor="#FFFFFF"><div align="center"><span class="style3">Fax your credit card deposit to: 1-718-439-8565 or mail to<br>
                        <strong>MPD TOUR AMERICA,INC.<br>
                        9101 Shore Road, #203<br>
                          Brooklyn, NY 11209</strong></span><br>
                  </div></td>
                </tr>
              </table>
              <hr width="95%" color="#666666">
              <p><strong>Terms and Conditions</strong></p>
              <p align="justify" class="style7">&#9642; The tour member &amp; guardians agree to abide by all of SMG &amp; MPD Tour America, Inc. policies &amp; rules in order to ensure each participant&rsquo;s safety, health, welfare &amp; our smooth management of tours.<br>
                  <br>
  &#9642; Participants &amp; guardians acknowledge that SMG or MPD Tour America may terminate any participant&rsquo;s tour at its sole discretion. Tour termination may be caused by rule violations that SMG or MPD Tour America, Inc. deems to endanger anyone or impedes the success of the tour. In such a case the participant will be sent home at his or her own expense &amp; there will be no refund whatsoever.<br>
  <br>
  &#9642; All program participants are required to have medical coverage at the time of travel. SMG &amp; MPD Tour America, Inc. do not assume any medical costs.<br>
  <br>
  &#9642; SMG &amp; MPD Tour America, Inc. reserve the right to cancel any program with insufficient participation, limit enrollment in any tour &amp; make substitutions or alterations to the itinerary as            necessary.<br>
  <br>
  &#9642; SMG &amp; MPD Tour America, Inc. may use photographs, videotapes or testimonials of participants for marketing purpose. Such use will be without remuneration.<br>
  <br>
  &#9642; MPD Tour America, Inc. acts as an agent only &amp; accepts no responsibility for loss, damage or injury resulting from delay or negligence of any company or vendor in the service of  MPD Tour America, Inc.<br>
  <br>
  &#9642; Responsibility Clause: MPD Tour America, Inc. its officers, directors, employees, shareholders, affiliates, subsidiaries &amp; agents do not own or operate any entity which provides goods or services for your trip including, for example. lodging, transportation, meals, etc. As a result, MPD Tour America, Inc. is not liable for any third party not under its control. Without limiting the foregoing in any risks or resulting injury, delay, inconvenience, damages or death resulting from criminal activity, weather or other acts of God, accidents, illness, physical activities, strikes, political unrest, acts of terrorism, or other events beyond its control. Participants &amp; guardians assume these risks.<br>
  <br>
  &#9642; Participation in these tours constitutes specific consent for the tour member to take part in all tour activities, amusement park rides, as well as biking, rollerblading, surfing, canoeing, boating, sailing or other similar activities &amp; to travel in public transportation &amp; private leased or hired vehicles.<br>
  <br>
  &#9642; Any dispute concerning this contract, the brochure, or any tour will be resolved exclusively though arbitration in the state of New York pursuant to the current rules of the American Arbitration Association.</p>
              <p><span class="style7"><br>
              </span> </p>
            </div>              </td>
          </tr>
        </table>
          <div class="clear"></div>
        <!-- end trips --></div>
        <!-- end whtMiddle -->
      </div>
      <div class="whtBottom"></div>
      <!-- end subPages --></div>
    <!-- end mainContent -->
  </div>
<!-- end container --></div>
<div class="clear"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="../bottomLinks.cfm">
<!-- end footer --></div>
</body>
</html>
