<html>
<head>
<title>:: CSB International : Employers ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../style.css" rel="stylesheet" type="text/css">
<script>
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function checkin(){
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

function changeAddress(){
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
</script>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table width="871" height="435" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
    <tr>
        <td height="131" background="images/top.jpg">
        	<table width="99%" border="0">
                <tr>
                    <td height="90" colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <a href="../index.cfm"><img src="images/transparent.gif" alt="" width="250" height="83" border="0"></a></td>
                </tr>
                <tr>
                    <td width="325">&nbsp;</td>
                    <td><cfinclude template="menu.cfm"></td>
                </tr>
            </table>
        </td>
	</tr>
    <tr>
        <td height="252" valign="top" background="images/back-table.png">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="5%" height="26">&nbsp;</td>
                    <td width="90%" valign="bottom" class="top"><p><a href="index.cfm" class="LinkItens">Home</a> &gt; Check In</p></td>
                    <td width="5%">&nbsp;</td>
                </tr>
                <tr>
                    <td height="17" colspan="3"><hr width="94%" color="#CCCCCC"></td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
            </table>
			
            <!--- Check-In Validation --->
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="90%" class="text">
                        <div align="justify">
                        <p><u><strong>Within 10 (ten) days from your arrival</strong></u> at your host site in the US, <strong> <u>you must Check-In on the CSB website</u></strong>  to ensure that your U.S. address is accurately reflected in the  Student Exchange Visitor Information System (SEVIS).  The SEVIS system  shows that your visa is current, and that you are lawfully present in  the United States and authorized to work. </p>
<p><strong>When you check-in, you should always answer two basic questions:</strong> </p>
<p>1. Submitting  inaccurate information may cause delays in updating the information in  SEVIS and further, delays in the process of applying and obtaining the  Social Security Number. </p>
<p>2. Intentionally  submitting false information may lead to program termination. In such  case, the participant will be asked to return home immediately. </p>

<p>Please fill-in the below form carefully. If you have any questions or concerns, please call our toll-free number and we will be glad to assist you: 1-877-669-0717.<br /><br />
  <span class="redText"><strong>Note: You must Check-in ONLY <u>after you have arrived in the United States.</u></strong></span>	          </p>
                          <!---  <p><span class="style3"><u>- CHECK-IN / VALIDATION</u></span><span class="style3"><u> </u></span><u><strong>(at arrival in the United States) </strong></u><br>
                            In order to keep your visa from being cancelled by the SEVIS system, CSB must validate your visa within 30 days from the start date on the DS-2019. 
                            Please CHECK-IN in maximum 10 days from your arrival date in U.S.A. by filling in all the below fields and submitting the form. If you have questions or concerns, 
                            please call 1-877-669-0717 (Toll-Free).</p>--->
                            <p><strong><span class="style5">*</span></strong><span class="style5"> Required</span><br></p>
                        </div>
                        <form action="submit_request.cfm?request=checkin" method="post" name="form" id="form" onSubmit="return checkin()"> 
                        <table width="620px" align="center">
                            <tr>
                                <td width="180" class="text"><div align="right"><strong>Participant ID Number:&nbsp; </strong></div></td>
                                <td width="440" class="text">
                                    <input name="idnumber" type="Text" class="text" id="idnumber" size="50" maxlength="50">
                                    <!---
                                    <strong><a href="javascript:MM_openBrWindow('images/id-card.jpg','idnumber','width=535,height=310')"><img src="images/question.gif" width="15" height="15" border="0"> What is this? </a></strong>
                                	--->
								</td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>SEVIS Number:&nbsp; </strong></div></td>
                                <td class="text">
                                    <input name="sevis" type="Text" class="text" id="sevis" size="50" maxlength="50">
                                    <strong> <a href="javascript:MM_openBrWindow('images/ds-2019.jpg','ds2019','width=635,height=467')"><img src="images/question.gif" width="15" height="15" border="0"> What is this?</a></strong>
								</td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Last Name: <span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="lastname" type="Text" class="text" id="lastname" size="50" maxlength="50" required="yes"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>First Name: <span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="firstname" type="Text" class="text" id="firstname" size="50" maxlength="50" required="yes"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Middle Name:&nbsp;</strong></div></td>
                                <td>
                                    <span class="text">
                                    <input name="middlename" type="Text" class="text" id="middlename" size="50" maxlength="50">
                                    </span>
                                </td>                        
                            </tr>                    
                            <tr>
                                <td class="text"><div align="right"><strong>E-Mail Address: <span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="email" type="Text" class="text" id="email" size="50" maxlength="50" required="yes"></td>
                            </tr>
                            <tr>
                                <td height="35" colspan="2" class="text">
                                    <span class="style4"><span class="style7">&nbsp;- Employer Information:</span><br>
                                    (you must provide the address where you currently work in the United States) </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Company Name:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="companyName" type="Text" class="text" id="companyName" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Street Address:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="companyStreet" type="Text" class="text" id="companyStreet" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>City:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="companyCity" type="Text" class="text" id="city3" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>State:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text">
                                    <select name="companyState" size="1" class="text" id="companyState">
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
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Zip Code:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="companyZip" type="Text" class="text" id="companyZip" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Primary Contact/Supervisor:&nbsp;</strong></div></td>
                                <td class="text"><input name="companyContact" type="Text" class="text" id="phone3" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Phone Number:&nbsp;</strong></div></td>
                                <td class="text"><input name="companyPhone" type="Text" class="text" id="companyPhone" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td height="17" colspan="2" class="text"><span class="style4">
                                    <span class="style7">&nbsp;- Housing Information:</span><br>
                                    (you must provide the address where you currently live in the United States) </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Street Address:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="street" type="Text" class="text" id="street" size="50" maxlength="50">    </td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>City:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="city" type="Text" class="text" id="city" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>State:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text">
                                    <select name="state" size="1" class="text">
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
                                    </select>    
                                </td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Zip Code:&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="zip" type="Text" class="text" id="zip" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Phone Number:&nbsp;</strong></div></td>
                                <td class="text"><input name="phone" type="Text" class="text" id="phone" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td valign="top" class="text"><div align="right"><strong>Comments:&nbsp;</strong></div></td>
                                <td class="text"><textarea name="comment" cols="50" rows="5" wrap="VIRTUAL" class="text"></textarea></td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" class="text"><input name="submit" type="Submit" class="text" value="Submit"></td>
                            </tr>
                        </table>
                        </form>                        
                        
                        <hr width="95%" color="#000099" align="center"><br>
                        
                        <!--- Change of Employer Address --->
                        <div align="justify">
                            <span class="style3"><u>- CHANGE OF EMPLOYER/ADDRESS </u></span><u><strong>(while in the United States) </strong></u><br>
                            To keep your information updated in the SEVIS system while you are in the United States, you must notify CSB of any changes related to your job or to your housing address.<br>
                        </div>
            
                        <form action="submit_request.cfm?request=change" method="post" enctype="multipart/form-data" name="formChangeAdrress" onSubmit="return changeAddress()">
                        <cfset filepath = expandpath('/var/www/html/intoedventures/uploaded/job-offers/')>
                        <table width="620px" align="center">
                            <tr>
                                <td width="180" class="text"><div align="right"><strong>Participant ID Number:&nbsp;</strong></div></td>
                                <td width="440" class="text"><input name="idnumber2" type="Text" class="text" id="idnumber2" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Last Name:&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="lastname2" type="Text" class="text" id="lastname2" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>First Name:&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="firstname2" type="Text" class="text" id="firstname2" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Middle Name:&nbsp; </strong></div></td>
                                <td><input name="middlename2" type="Text" class="text" id="middlename2" size="50" maxlength="50"></td>
                            </tr>                    
                            <tr>
                                <td class="text"><div align="right"><strong>E-Mail Address: <span class="style5">*</span></strong></div></td>
                                <td><input name="email2" type="Text" class="text" id="email2" size="50" maxlength="50" required="yes">                    
                            <tr>
                                <td height="25" colspan="2" class="text"><span class="style4"> &nbsp;- New Employer Information: </span> </td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Company Name:&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="company" type="Text" class="text" id="company" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Street Address:&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="compaddress" type="Text" class="text" id="compaddress" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>City:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="compcity" type="Text" class="text" id="compcity" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>State:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text">
                                    <select name="compstate" size="1" class="text" id="compstate">
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
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Zip Code:&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="compzip" type="Text" class="text" id="compzip" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Primary Contact :&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="compcontact" type="Text" class="text" id="compcontact" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Phone Number:&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="comphone" type="Text" class="text" id="comphone" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Email Address:&nbsp;</strong></div></td>
                                <td class="text"><input name="compemail" type="Text" class="text" id="compemail" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Upload Job Offer:&nbsp; </strong></div></td>
                                <td class="text">
                                    <input name="UploadFile" type="file" class="text" size="50" required="yes">
                                    <strong><img src="images/pdf.gif" width="15" height="16" border="0"> <a href="../files/Job_Offer_Agreement_Employer.pdf" target="_blank">PDF template </a></strong><br>
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2" class="text"><span class="style4">&nbsp;- New Housing Information: </span></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Street Address:&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="housingaddress" type="Text" class="text" id="housingaddress" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>City:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text"><input name="housingcity" type="Text" class="text" id="housingcity" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>State:&nbsp;<span class="style5">*</span></strong></div></td>
                                <td class="text">
                                    <select name="housingstate" size="1" class="text" id="housingstate">
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
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Zip code:&nbsp;<span class="style5">*</span> </strong></div></td>
                                <td class="text"><input name="housingzip" type="Text" class="text" id="housingzip" size="50" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td class="text"><div align="right"><strong>Phone Number:&nbsp;</strong></div></td>
                                <td class="text"><input name="housingphone" type="Text" class="text" id="housingphone" size="50" maxlength="50"></td>
                            </tr>                                      
                            <tr>
                                <td height="32" colspan="2" align="center" class="text"><input type="Submit" class="text" value="Submit"></td>
                            </tr>
                        </table>
                        </form>
                    </td>
                    <td width="5%">&nbsp;</td>
                </tr>
            </table>
        </td>
	</tr>
    <tr>
    	<td height="52" background="images/bottom.png" align="center"><cfinclude template="bottom.cfm"></td>
    </tr>
</table>

</body>
</html>