<HTML>
<HEAD>
<TITLE>ISE - International Student Exchange | Private and Public High School Programs</TITLE>
<META NAME="Keywords" CONTENT="homestay, exchange student, foreign students, student exchange, foreign exchange, foreign exchange program, academic exchange, student exchange program, high school, high school program, host family, host families, public high school program, private high school program, public high school, private high school, American exchange">
<META NAME="Description" CONTENT="ISE offers semester programs, as well as school year programs, that allow foreign students the opportunity to become familiar with the American way of life by experiencing its schools, homes and communities. ISE can also now offer students the opportunity to study at some of America's finest Private High Schools. ISE works with a network of independent international educational partners who provide information, screening and orientations for prospective applicants to a variety of education and training programs in the United States.">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	background-color: #000343;
}
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style5 {	color: #FFFFFF;
	font-weight: bold;
}
.style6 {	color: #2E4F7A;
	font-weight: bold;
}
.style7 {font-size: 14px}
.style8 {color: #FF0000}
.style13 {	font-size: 10px;
	color: #FF0000;
	font-weight: bold;
}
.style9 {font-size: 10px}
.style14 {	font-size: 24px;
	font-weight: bold;
}
-->
</style><script src="../menu.js"></script>

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
		if (d.word.value != r_text[i]) {
			alert("Please type the word now showing in the left box into the right box!")
			d.word.focus();
			return false;    
		} 
		
		return true;
	}
</script></HEAD>
<cfquery name="tours" datasource="mysql">
	SELECT *
	FROM smg_tours
	WHERE tour_status <> 'Inactive'
	ORDER BY tour_name
</cfquery> 
<BODY LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<cfoutput>
<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD COLSPAN=3><script>menutop();</script></TD>
	</TR>
	<TR>
		<TD width="17" background="../../images/blank_02.gif">&nbsp;			</TD>
		<TD width="736" bgcolor="##FFFFFF"> <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="42%"><div align="center"><img src="../images/ISEtrips.jpg" width="266" height="70"></div></td>
            <td width="58%"><img src="../images/top1.jpg" width="400" height="70"></td>
          </tr>
          <tr>
            <td height="305" colspan="2">
              <div align="center"> <br>
                <table width="70%" border="0" cellspacing="1" cellpadding="0">
                  <tr>
                    <td width="18%" height="22" bgcolor="##2E4F7A" class="style1"><A href="index.cfm" class="style5">
                      <div align="center">Home</div>
                    </A></td>
                    <td width="18%" bgcolor="##2E4F7A" class="style1"><div align="center"><a href="contact.cfm" class="style5">Contact</a></div></td>
                    <td width="28%" bgcolor="##2E4F7A" class="style1"><div align="center"><a href="rules.html" class="style5">Rules &amp; Policies</a></div></td>
                    <td width="15%" bgcolor="##FFFFFF" class="style1"><div align="center" class="style6">Forms</div></td>
                    <td width="21%" bgcolor="##2E4F7A" class="style1"><div align="center"><a href="faqs.html" class="style5">Questions?</a></div></td>
                  </tr>
                </table>
                  <br>
                  <span class="style3"><strong class="style1">Deposit Form </strong><br>
                  </span><br>
                  <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td class="style1"><div align="center">
                          <p align="center" class="style3">Use this form to reserve the tour you want. Your early deposit holds your place.</p>
                        <form action="submit_request.cfm" method="post" name="form" onSubmit="return validaForm()">
                            <table width="90%" border="0" cellspacing="0" cellpadding="1">
                              <tr>
                                <td width="27%" class="style1"><div align="right"><span class="style3"><strong>Payment options:</strong></span></div></td>
                                <td width="73%" class="style1"><input name="payment" type="radio" value="Check">
                                Check </td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"></div></td>
                                <td class="style1"><input name="payment" type="radio" value="Money Order">
                                Money Order </td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"></div></td>
                                <td class="style1"><input name="payment" type="radio" value="Visa">
                                Visa</td>
                              </tr>
                              <tr>
                                <td rowspan="2" class="style1"><div align="right"></div></td>
                                <td class="style1"><input name="payment" type="radio" value="MasterCard">
                                MasterCard </td>
                              </tr>
                              <tr>
                                <td class="style1"><input name="payment" type="radio" value="American Express">
                                American Express</td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><span class="style3"><strong>Card ##: </strong></span></div></td>
                                <td class="style1">&nbsp;
                                  <input name="card" type="text" id="card" size="40"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right" class="style3"><strong>Expires: </strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="expires" type="text" id="expires" size="20"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><span class="style3"><strong>Name on Card: </strong></span></div></td>
                                <td class="style1">&nbsp;
                                  <input name="name" type="text" id="name" size="40"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><span class="style3"><strong>Charge my card for :</strong></span></div></td>
                                <td class="style1"><span class="style3">
                                  <input name="charge" type="radio" value="The Full Amount">
                                The Full Amount </span></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"></div></td>
                                <td class="style1"><span class="style3">
                                  <input name="charge" type="radio" value="$100 Deposit Per Tour">
                                $100 Deposit Per Tour </span></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"></div></td>
                                <td class="style1"><span class="style3">
                                  <input name="charge" type="radio" value="Other">
                                  Other
                                  <input name="other" type="text" id="other" size="30">
                                </span></td>
                              </tr>

                              <tr>
                                <td height="38" colspan="2" class="style1"><div align="center" class="style3"><strong>Personal Information </strong></div></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>Date of Birth: </strong></div></td>
                                <td class="style1">&nbsp;
                                    <input name="birth" type="text" id="birth" size="20">
                                mm/dd/yyyy</td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>Male</strong></div></td>
                                <td class="style1"><strong>
                                  <input name="sex" type="radio" value="Male">
                                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Female
                                  <input name="sex" type="radio" value="Female">
                                </strong></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>Last Name: </strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="lastname" type="text" id="lastname" size="40"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>First Name: </strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="firstname" type="text" id="firstname" size="40"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>Host Family Name: </strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="hostname" type="text" id="hostname" size="40"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>Street:</strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="street" type="text" id="street" size="40"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>City:</strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="city" type="text" id="city" size="40"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>State:</strong></div></td>
                                <td class="style1">&nbsp;
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
                                <td class="style1"><div align="right"><strong>Zip:</strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="zip" type="text" id="zip" size="20"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>Student email: </strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="studentemail" type="text" id="studentemail" size="40"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>Host email: </strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="hostemail" type="text" id="hostemail" size="40"></td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>Phone</strong></div></td>
                                <td class="style1">&nbsp;
                                  <input name="phone" type="text" id="phone" size="40"></td>
                              </tr>
                              <tr>
                                <td colspan="2" class="style1">Airline tickets are cheaper when booked ahead.</td>
                              </tr>
                              <tr>
                                <td class="style1"><div align="right"><strong>State:</strong></div></td>
                                <td class="style1"><select name="stateaiport" size="1" id="stateaiport">
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
                                <td class="style1"><div align="right"><strong>Airport:</strong></div></td>
                                <td class="style1"><span class="style3">
                                  <input name="airport" type="text" id="airport" size="40">
                                </span></td>
                              </tr>
                              <tr>
                                <td height="32" colspan="2" class="style1"><div align="center"><strong>Indicate which trip(s) you are taking: </strong></div></td>
                              </tr>
							  <cfset num = 1>
							  
							  <cfloop query="tours">
							  <tr>
                                <td class="style1"><div align="right"><strong><input name="tour" type="checkbox" id="tour" value=" #Replace(tour_name, ('!company!'), 'ISE', 'ALL')#">&nbsp;</strong></div></td>
                                <td class="style1">#Replace(tour_name, ("!company!"), "ISE", "ALL")#</td>
                              </tr>
							  <cfset num = num+1>
							  </cfloop>

                              <tr>
                                <td height="110" colspan="2" class="style1"><div align="center">
                                  <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="##E9E9E9">
                                    <tr>
                                      <td height="27"><div align="center" class="style1"><strong>Please type the word now showing in the left box into the right box and   hit submit</strong>:</div></td>
                                    </tr>
                                    <tr>
                                      <td height="60"><table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
                                          <tr>
                                            <td width="50%"><div align="center">
                                                <table width="90%" border="1" cellpadding="5" cellspacing="0" bordercolor="##000066">
                                                  <tr>
                                                    <td><div align="center" class="style14">
                                                      <script type="text/javascript">DrawBotBoot()</script>                                                    </div></td>
                                                  </tr>
                                                </table>
                                            </div></td>
                                            <td width="50%"><div align="center">
                                                <input name="word" type='text' class="style1" id='word' size='15' maxlength='15'/>
												<input name="company" type="hidden" class="style1" id='company' value="ISE"/>
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
                                <td height="50" colspan="2" class="style1"><div align="center">
                                  <input type="submit" name="Submit" value="Submit">
                                </div></td>
                              </tr>
                            </table>
                        </form>
                        <table width="80%" border="0" cellpadding="3" cellspacing="1" bordercolor="##666666" bgcolor="##666666">
                            <tr>
                              <td bgcolor="##FFFFFF"><div align="center" class="style1"><span class="style3">Fax your credit card deposit to: 1-718-439-8565 or mail to<br>
                                        <strong>MPD TOUR AMERICA,INC.<br>
                                          9101 Shore Road, ##203<br>
                                          Brooklyn, NY 11209</strong></span><br>
                              </div></td>
                            </tr>
                        </table>
                        <hr width="95%" color="##666666">
                          <p><strong>Terms and Conditions</strong></p>
                        <p align="justify" class="style9">&##9642; The tour member &amp; guardians agree to abide by all of ISE &amp; MPD Tour America, Inc. policies &amp; rules in order to ensure each participant&rsquo;s safety, health, welfare &amp; our smooth management of tours.<br>
                              <br>
                          &##9642; Participants &amp; guardians acknowledge that ISE or MPD Tour America may terminate any participant&rsquo;s tour at its sole discretion. Tour termination may be caused by rule violations that ISE or MPD Tour America, Inc. deems to endanger anyone or impedes the success of the tour. In such a case the participant will be sent home at his or her own expense &amp; there will be no refund whatsoever.<br>
                          <br>
                          &##9642; All program participants are required to have medical coverage at the time of travel. ISE &amp; MPD Tour America, Inc. do not assume any medical costs.<br>
                          <br>
                          &##9642; ISE &amp; MPD Tour America, Inc. reserve the right to cancel any program with insufficient participation, limit enrollment in any tour &amp; make substitutions or alterations to the itinerary as            necessary.<br>
                          <br>
                          &##9642; ISE &amp; MPD Tour America, Inc. may use photographs, videotapes or testimonials of participants for marketing purpose. Such use will be without remuneration.<br>
                          <br>
                          &##9642; MPD Tour America, Inc. acts as an agent only &amp; accepts no responsibility for loss, damage or injury resulting from delay or negligence of any company or vendor in the service of  MPD Tour America, Inc.<br>
                          <br>
                          &##9642; Responsibility Clause: MPD Tour America, Inc. its officers, directors, employees, shareholders, affiliates, subsidiaries &amp; agents do not own or operate any entity which provides goods or services for your trip including, for example. lodging, transportation, meals, etc. As a result, MPD Tour America, Inc. is not liable for any third party not under its control. Without limiting the foregoing in any risks or resulting injury, delay, inconvenience, damages or death resulting from criminal activity, weather or other acts of God, accidents, illness, physical activities, strikes, political unrest, acts of terrorism, or other events beyond its control. Participants &amp; guardians assume these risks.<br>
                          <br>
                          &##9642; Participation in these tours constitutes specific consent for the tour member to take part in all tour activities, amusement park rides, as well as biking, rollerblading, surfing, canoeing, boating, sailing or other similar activities &amp; to travel in public transportation &amp; private leased or hired vehicles.<br>
                          <br>
                          &##9642; Any dispute concerning this contract, the brochure, or any tour will be resolved exclusively though arbitration in the state of New York pursuant to the current rules of the American Arbitration Association.</p>
                        <p><span class="style9"><br>
                          </span> </p>
                      </div></td>
                    </tr>
                  </table>
                <span class="style1"><br>
                </span></div></td></tr>
        </table></TD>
		<TD width="17" background="../images/blank_04.gif">&nbsp;			</TD>
	</TR>
	<TR>
		<TD COLSPAN=3>
			<IMG SRC="../images/blank_05.gif" ALT="" WIDTH=770 HEIGHT=34 border="0" usemap="##Map"></TD>
	</TR>
</TABLE>
</cfoutput>
<map name="Map">
  <area shape="rect" coords="521,6,655,22" href="mailto:contact@iseusa.com">
</map>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-880717-2";
urchinTracker();
</script>
</BODY>
</HTML>