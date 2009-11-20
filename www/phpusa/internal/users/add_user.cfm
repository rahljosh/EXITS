<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Add User</title>
<link rel="stylesheet" type="text/css" href="forms/phpcss.css">
<style>
.vline { BACKGROUND-IMAGE: url(pics/table-borders/left-vert-line.gif); BACKGROUND-REPEAT: repeat-y }
.grouptopleft { BACKGROUND-POSITION: 50% bottom; BACKGROUND-IMAGE: url(pics/table-borders/topleft.gif); BACKGROUND-REPEAT: no-repeat }
.groupTop { BACKGROUND-POSITION: 50% bottom; BACKGROUND-IMAGE: url(pics/table-borders/top.gif); BACKGROUND-REPEAT: repeat-x }
.groupTopRight { BACKGROUND-POSITION: left bottom; BACKGROUND-IMAGE: url(pics/table-borders/topright.gif); BACKGROUND-REPEAT: no-repeat }
.groupLeft { BACKGROUND-POSITION-X: right; BACKGROUND-IMAGE: url(pics/table-borders/left-vert-line.gif); BACKGROUND-REPEAT: repeat-y }
.groupRight { BACKGROUND-IMAGE: url(pics/table-borders/right.gif); BACKGROUND-REPEAT: repeat-y }
.groupBottomLeft { BACKGROUND-POSITION: right top; BACKGROUND-IMAGE: url(pics/table-borders/bottomleft.gif); BACKGROUND-REPEAT: no-repeat }
.groupBottom { BACKGROUND-POSITION: 50% top; BACKGROUND-IMAGE: url(pics/table-borders/bottom.gif); BACKGROUND-REPEAT: repeat-x }
.groupBottomRight { BACKGROUND-POSITION: left top; BACKGROUND-IMAGE: url(pics/table-borders/bottomright.gif); BACKGROUND-REPEAT: no-repeat }
.header { BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #000000  }
.footer { BACKGROUND-IMAGE: url(pics/table-borders/footerBackground.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #bf0301 }
.errMessageGradientStyle { BACKGROUND-IMAGE: url(pics/error-backgradient.gif); BACKGROUND-REPEAT: repeat-x }
.normRegistrationHeader { BACKGROUND-IMAGE: url(pics/norm-backimage.gif); BACKGROUND-REPEAT: repeat-x }
.redLine { BACKGROUND-POSITION: left 50%; BACKGROUND-IMAGE: url(pics/orange_gradiant.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #ff7e0d }
</style>
</head>

<body>

<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function checkCapsLock( e ) {
	var myKeyCode=0;
	var myShiftKey=false;
	var myMsg='Caps Lock is On.\n\nTo prevent entering your password incorrectly,\nyou should press Caps Lock to turn it off.';

	// Internet Explorer 4+
	if ( document.all ) {
		myKeyCode=e.keyCode;
		myShiftKey=e.shiftKey;

	// Netscape 4
	} else if ( document.layers ) {
		myKeyCode=e.which;
		myShiftKey=( myKeyCode == 16 ) ? true : false;
s
	// Netscape 6
	} else if ( document.getElementById ) {
		myKeyCode=e.which;
		myShiftKey=( myKeyCode == 16 ) ? true : false;

	}

	// Upper case letters are seen without depressing the Shift key, therefore Caps Lock is on
	if ( ( myKeyCode >= 65 && myKeyCode <= 90 ) && !myShiftKey ) {
		alert( myMsg );

	// Lower case letters are seen while depressing the Shift key, therefore Caps Lock is on
	} else if ( ( myKeyCode >= 97 && myKeyCode <= 122 ) && myShiftKey ) {
		alert( myMsg );

	}
}
//  End -->
</script>

<script language="javascript">

	var ieDOM = false, nsDOM = false;
	var stdDOM = document.getElementById; 
	
	function getObject(objectId)
	{
		if (stdDOM) return document.getElementById(objectId);
		if (ieDOM) return document.all[objectId];
		if (nsDOM) return document.layers[objectId];
	}

	function getObjectStyle(objectId)
	{

		if (nsDOM) return getObject(objectId);
		var obj = getObject(objectId);
		return obj.style;
	}

	function showDefault(objectId)
	{
		showCell(objectId, "silver", "white");
	}

	function showCell(objectId, foreColor, backColor)
	{
		getObjectStyle(objectId).color = foreColor;
		getObjectStyle(objectId).backgroundColor = backColor;
	}

	function showUnacceptable()
	{
		getObjectStyle("pwOuterTable").borderWidth = "0";
		getObjectStyle("pwTable").borderWidth = "1";
		getObjectStyle("pwWeak").borderRightColor = "silver";
		showCell("pwWeak", "white", "red");
		getObjectStyle("pwMedium").borderRightColor = "silver";
		showDefault("pwMedium");
		getObjectStyle("pwStrong").fontWeight = "normal";
		showDefault("pwStrong");
		document.Form1.passok.value = 'no';
	}

	function showAcceptable()
	{
		getObjectStyle("pwOuterTable").borderWidth = "0";
		getObjectStyle("pwTable").borderWidth = "1";
		getObjectStyle("pwWeak").borderRightColor = "lightgreen";
		showCell("pwWeak", "lightgreen", "yellow");
		getObjectStyle("pwMedium").borderRightColor = "silver";
		showCell("pwMedium", "black", "yellow");
		getObjectStyle("pwStrong").fontWeight = "normal";
		showDefault("pwStrong");
		document.Form1.passok.value = 'yes';
	}

	function showStrong()
	{
		getObjectStyle("pwOuterTable").borderWidth = "1";
		getObjectStyle("pwTable").borderWidth = "0";
		getObjectStyle("pwWeak").borderRightColor = "#29C72A";
		showCell("pwWeak", "29C72A", "#29C72A");
		getObjectStyle("pwMedium").borderRightColor = "#9C72A";
		showCell("pwMedium", "29C72A", "#29C72A");
		getObjectStyle("pwStrong").fontWeight = "bold";
		showCell("pwStrong", "white", "#29C72A");
		document.Form1.passok.value = 'yes';
	}

	function showUndetermined()
	{
		getObjectStyle("pwOuterTable").borderWidth = "0";
		getObjectStyle("pwTable").borderWidth = "1";
		getObjectStyle("pwWeak").borderRightColor = "silver";
		showDefault("pwWeak");
		getObjectStyle("pwMedium").borderRightColor = "silver";
		showDefault("pwMedium");
		getObjectStyle("pwStrong").fontWeight = "normal";
		showDefault("pwStrong");
		document.Form1.passok.value = 'yes';
	}

	function passwordChanged(obj)
	{
		var pwd = obj.value;

		if( pwd.length < 6 )
		{
			showUndetermined();
			getObjectStyle('lblPasswordValid3').display='none';
		}
		else if ( pwd.toLowerCase() == getObject('username').value.toLowerCase()  )
		{
			showUnacceptable();
			getObjectStyle('lblPasswordReq').display='none';
			getObjectStyle('lblPasswordValid1').display='none';
			getObjectStyle('lblPasswordValid2').display='none';
			getObjectStyle('lblPasswordValid3').display='inline';
		}
		else if( isStrong(pwd) )
		{
			showStrong();
			getObjectStyle('lblPasswordValid3').display='none';
			
		}
		else if( isAcceptable( pwd ) )
		{
			showAcceptable();
			getObjectStyle('lblPasswordValid3').display='none';
			
		}                
		else
		{
			showUnacceptable();
			getObjectStyle('lblPasswordValid3').display='none';
			
		
		}
	}
	
	function isStrong(str) {
		if (numDigits(str) >= 2 && numChars(str) >= 2 && (str.length >= 10 || numSpecialChars(str) >= 1))
			return true;
		else
			return false;
	}
	
	function isAcceptable(str) {
		if (numDigits(str) >= 2 && numChars(str) >= 2)
			return true;
		else
			return false;
	}

	function numChars(str) {
		var charCount=0;
		
		for (i=0; i < str.length; i++)
			if (isChar(str.charAt(i)))
				charCount ++;
		
		return charCount;
	}
	
	function numDigits(str) {
		var charCount=0;
		
		for (i=0; i < str.length; i++)
			if (isDigit(str.charAt(i)))
				charCount ++;
		
		return charCount;
	}

	function numSpecialChars(str) {
		var charCount=0;
		
		for (i=0; i < str.length; i++)
			if (isSpecialChar(str.charAt(i)))
				charCount ++;
		
		return charCount;
	}

	function isChar(ch)
	{
		var  regExText, regExp;

		regExText  = '[A-Za-z]';
		regExp    = new RegExp(regExText);
		return regExp.test(ch);
	}
	
	function isDigit(ch) {
		var  regExText, regExp;

		regExText  = '[0-9]';
		regExp    = new RegExp(regExText);
		return regExp.test(ch);
	}
	
	function isSpecialChar(ch){
		if (!isDigit(ch) && !isChar(ch))
			return true;
		else
			return false;
	}
	
	function trim(str)
	{
		return str.replace(/^\s*|\s*$/g,"");
	}
</script>
	
<SCRIPT LANGUAGE="javascript">
   function copy()
   {
	document.Form1.username.value = document.Form1.email.value;
	}
</SCRIPT>

<cfquery name="usertype" datasource="MySQL">
	SELECT *
	FROM smg_usertype
	WHERE usertypeid = '7'
		<cfif client.usertype LTE '4'>
			OR usertypeid = '3' 
			OR usertypeid = '8'	
		</cfif>
</cfquery>

<cfquery name="get_countrylist" datasource="MySql">
	SELECT countryid, countryname
	FROM smg_countrylist
	ORDER BY countryname
</cfquery>								

<cfoutput>

<cfform name="Form1" method="post" action="index.cfm?curdoc=users/add_user_qr" id="Form1">
<br />
<TABLE cellSpacing="0" cellPadding="0" align="center" class="regContainer">
	<tr><td class="header" colSpan="3"></td></tr>
	<tr vAlign="top">
		<td></td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr><td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td></tr>
	<tr><td class="orangeLine" colSpan="3" height="11"><img height=11 src="spacer.gif" width=1></td></tr>
	<tr><td colSpan="3" height="10">&nbsp;</td></tr>
	<tr>
		<td width="10">&nbsp;</td>
		<td>
			<table cellSpacing="0" cellPadding="0" border="0">
				<tr>
					<td width="20">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td width="20">&nbsp;</td>
					<td><span class="reqField">*</span> Indicates a required field.</td>
				</tr>
				<tr>
					<td width="20" height="5"><img height=5 src="spacer.gif" width=1 ></td>
					<td><img height=5 src="spacer.gif" width=1 ></td>
				</tr>
			</table>
		</td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr borderColor="##d3d3d3">
		<td width="10">&nbsp;</td>
		<td>
			<!-- Personal Details Group -->
			<table cellspacing="0" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="groupTopLeft">&nbsp;</td>
					<td class="groupCaption" nowrap="true">Personal Details</td>
					<td class="groupTop" width="95%">&nbsp;</td>
					<td class="groupTopRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupLeft">&nbsp;</td>
					<td colspan="2">
						<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<TBODY>
										<!--- Usertype --->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"><span class="reqField">*</span></td>
											<td id="label"><span id="lblTitle" class="normalLabel">Usertype:</span></td>
											<td id="input">
												<cfloop query="usertype">
													<input type="radio" name="usertype" value="#usertypeid#">#usertype#
												</cfloop>
											</td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!--- FIRST NAME --->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"><span class="reqField">*</span></td>
											<td id="label"><span id="lblTitle" class="normalLabel">First name:</span></td>
											<td id="input"><input name="firstname" type="text" maxlength="225" id="firstname"></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!-----Last Name---->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"><span class="reqField">*</span></td>
											<td><span id="lblTitle" class="normalLabel">Last name:</span></td>
											<td id="input"><input name="lastname" type="text" maxlength="225" id="lastname"></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Date of Birth---->
										<tr vAlign="middle" height="30">
											<td align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Date of birth:</span>&nbsp;</td>
											<td id="input"><input name="dob" size="8" type="text" maxlength="10"/> <em>mm/dd/yyyy</em></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Email---->
										<tr vAlign="top" height="30">
											<td width="20" align="center"><span class="reqField">*</span></td>
											<td><span id="lblTitle" class="normalLabel">Email address:</span></td>
											<td id="input"><input name="email" type="text" maxlength="225" id="email" onchange="javascript:copy()"></td>
											<td height="1"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Phone---->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Phone:</span></td>
											<td id="input"><input name="phone" type="text" maxlength="20"></td>
											<td height="1" colspan="2"><span id="lblTitle" class="normalLabel">Ext. </span> <cfinput type="text" name="phone_ext" size="5"> <em>only numbers</em> <IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Cell---->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Cell Phone:</span></td>
											<td id="input"><input name="cell_phone" type="text" maxlength="20"></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Work---->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Work Phone:</span></td>
											<td id="input"><input name="work_phone" type="text" maxlength="20"></td>
											<td height="1" colspan="2"><span id="lblTitle" class="normalLabel">Ext. </span> <cfinput type="text" name="work_ext" size="5"> <em>only numbers</em> <IMG height=1 src="spacer.gif" width=20></td>
										</tr>										
										<!----- Fax ---->
										<tr vAlign="middle" height="30">
											<td align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Fax:</span></td>
											<td align="left"><input name="fax" type="text" maxlength="15"></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>										
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td class="groupRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td>
					<td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td>
					<td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
				</tr>
			</table> 
			<!--- End of Personal Details --->
			
			<!--- PHP CONTACT --->
			<table cellspacing="0" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="groupTopLeft">&nbsp;</td>
					<td class="groupCaption" nowrap="true">PHP Contact Information</td>
					<td class="groupTop" width="95%">&nbsp;</td>
					<td class="groupTopRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupLeft">&nbsp;</td>
					<td colspan="2">
						<table id="rgbAddressDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<TBODY>
										<!-----Contact Name ---->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"></td>
											<td id="label"><span id="lblTitle" class="normalLabel">Contact Name:</span></td>
											<td id="input"><input name="php_contact_name" type="text" maxlength="150"></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Phone---->
										<tr vAlign="middle" height="30">
											<td align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Phone:</span></td>

											<td id="input"><input name="php_contact_phone" type="text" maxlength="20"></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Email---->
										<tr vAlign="top" height="30">
											<td align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Email Address:</span></td>
											<td id="input"><input name="php_contact_email" type="text" maxlength="100"></td>
											<td height="1"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td class="groupRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td>
					<td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td>
					<td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
				</tr>
			</table> 	
			
			<!--- Address details --->
			<table cellspacing="0" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="groupTopLeft">&nbsp;</td>
					<td class="groupCaption" nowrap="true">Address Details</td>
					<td class="groupTop" width="95%">&nbsp;</td>
					<td class="groupTopRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupLeft">&nbsp;</td>
					<td colspan="2">
						<table id="rgbAddressDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<!----Businessname---->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Business Name:</span>&nbsp;</td>
											<td id="input"><input name="businessname" type="text" maxlength="60" id="businessname"></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Address 1---->
										<tr vAlign="middle" height="30">
											<td><LABEL id="lblAddressInd" class="reqField">*</LABEL></td>
											<td id="label"><span id="lblTitle" class="normalLabel">Address:</span></td>
											<td id="input"><input name="address" type="text" maxlength="150" id="address"></td>
											<td width="20"><IMG height=1 src="spacer.gif" width=20></td>
											<td class="helpmsg"><IMG height=1 src="spacer.gif"></td>
										</tr>
										<!----address2---->
										<tr vAlign="middle" height="30">
											<td colSpan="2"><IMG height=1 src="spacer.gif" width=1></td>
											<td id="input"><span id="lblTitle" class="normalLabel"><input name="address2" type="text" maxlength="150" id="address2"/></td>
											<td colSpan="2"><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
										<!----City---->
										<tr vAlign="middle" height="30">
											<td align="center"><LABEL id="lblCityTownInd" class="reqField">*</LABEL></td>
											<td><span id="lblTitle" class="normalLabel">City / Town:</span></td>
											<td id="input"><input name="city" type="text" maxlength="225" id="city"></td>
											<td colSpan="2"><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
										<!----State---->
										<tr vAlign="middle" height="30">
											<td align="center"><LABEL id="lblCityTownInd" class="reqField">*</LABEL></td>
											<td><span id="lblTitle" class="normalLabel">State</span></td>
											<td id="input">
												<cfquery name="states" datasource="mysql">
													select * 
													from smg_states
												</cfquery>
												<select name="state">
													<option value='0'>Select State</option>
													<cfloop query="states">
														<option value="#id#">#statename# - #state#</option>
													</cfloop>
												</select>
											</td>
											<td colSpan="2"><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
										<!----Zip---->
										<tr vAlign="middle" height="30">
											<td align="center"><LABEL id="lblZipCodeInd" class="reqField">*</LABEL></td>
											<td><span id="lblTitle" class="normalLabel">Post / ZIP code:</span></td>
											<td id="input"><input name="zip" type="text" maxlength="100" id="zip"></td>
											<td colSpan="2"><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
										<!--- COUNtrY --->
										<tr vAlign="middle" height="30">
											<td align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Country:</span></td>
											<td id="input">
												<cfselect name="country" query="get_countrylist" display="countryname" value="countryid" queryPosition="below">
													<option value="0">Select Country</option>
												</cfselect>								
											</td>
											<td colSpan="2"><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
									</TABLE>
								</td>
							</tr>
						</table>
					</td>
					<td class="groupRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td><td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td><td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
				</tr>
			</table>
			<!--- End of Address details --->
			<!--- Account Details --->
			<table cellspacing="0" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="groupTopLeft">&nbsp;</td>
					<td class="groupCaption" nowrap="true">Account Details</td>
					<td class="groupTop" width="95%">&nbsp;</td>
					<td class="groupTopRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupLeft">&nbsp;</td>
					<td colspan="2">
						<table id="rgbAccountDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<!----Username---->
										<tr vAlign="middle" height="30">
											<td align="center" width="20"><LABEL id="lblUsernameInd" class="reqField">*</LABEL></td>
											<td id="label"><span id="lblTitle" class="normalLabel">Username:</span></td>
											<td id="input"><input name="username" type="text" maxlength="64" id="username"/>&nbsp;</td>
											<td width="20"><IMG height=1 src="spacer.gif" width=1></td>
											<td><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
										<!----Password---->
										<cfset temp_password = "temp#RandRange(100000, 999999)#">
										<tr vAlign="top" height="30">
											<td align="center"><LABEL id="lblPasswordInd" class="reqField">*</LABEL></td>
											<td><span id="lblTitle" class="normalLabel">Password:</span>&nbsp; <SPAN class="helpmsg">(6 characters minimum)</SPAN></td>										
											<td id="input"><input name="password" type="password" value="#temp_password#" maxlength="32" id="Password" onkeyup="javascript:passwordChanged(this);" onchange="javascript:passwordChanged(this);" /></td>
											<td><IMG height=1 src="spacer.gif" width=1></td>
											<td class="helpmsg" vAlign="top" rowSpan="3">We recommend using a strong password:<BR><IMG height=5 src="spacer.gif" width=1>
												<DIV style="MARGIN-LEFT: 15px">- At least 2 letters<LABEL id="lblUsernameInd" class="reqField">*</LABEL><BR>
													- At least 2 numbers<LABEL id="lblUsernameInd" class="reqField">*</LABEL><BR>
													- One or more special characters (e.g. !, $, ##)
												</DIV>
											</td>
										</tr>
										<!----Password Indicator---->
										<tr vAlign="top">
											<td colSpan="2" height="8"><IMG height=8 src="spacer.gif" width=1></td>
											<td id="input" height="20">Password strength indicator:</td>
											<td height="8"><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
										<tr vAlign="top" height="30">
											<td colSpan="2"><IMG height=1 src="spacer.gif" width=1></td>
											<td id="input">
												<TABLE id="pwOuterTable" cellSpacing="0" cellPadding="1">
													<tr>
														<td>
															<TABLE id="pwTable" cellSpacing="0" cellPadding="3" width="100%">
																<tr>
																	<td id="pwWeak" title="Has at least 2 letters but less than 2 numbers" align="center" width="34%">Unacceptable</td>
																	<td id="pwMedium" title="Has at least 2 letters and 2 numbers and at least 6 characters in length" align="center" width="33%">Acceptable</td>
																	<td id="pwStrong" title="Has at least 2 letters, 2 numbers and either 10 characters in length or has at least one special characters" align="center" width="33%">Strong</td>
																</tr>
															</TABLE>
														</td>
													</tr>
												</TABLE>
											</td>
											<td><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
										<!----Confirm Passoword---->
										<tr vAlign="middle" height="30">
											<td align="center"><LABEL id="lblConfirmPwdInd" class="reqField">*</LABEL></td>
											<td><span id="lblConfirmPwd" class="normalLabel">Confirm password:</span></td>
											<td id="input"><input name="password2" type="password" value="#temp_password#" maxlength="32" id="ConfirmPwd" /></td>
											<td><IMG height=1 src="spacer.gif" width=1></td>
											<td class="helpmsg"><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
									</TABLE>
								</td>
							</tr>
						</table>
					</td>
					<td class="groupRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td><td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td><td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
				</tr>
			</table>
		</td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr>
		<td><IMG height=55 src="spacer.gif" width=1></td>
        <td align="center"><input type="image" name="imgSubmit"  src="pics/next.gif" alt="Submit" border="0" /></td>
		<td>&nbsp;</td>
	</tr>
	<tr><td class="footer" colSpan="3"></td></tr>
</TABLE>
<br />

</td>
</tr>
</TBODY>
</TABLE> 
</cfform>
</cfoutput>
</body>
</HTML>