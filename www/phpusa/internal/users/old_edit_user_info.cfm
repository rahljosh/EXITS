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
.footer { BACKGROUND-IMAGE: url(pics/table-borders/FooterBackground.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #bf0301 }
.errMessageGradientStyle { BACKGROUND-IMAGE: url(pics/error-backgradient.gif); BACKGROUND-REPEAT: repeat-x }
.normRegistrationHeader { BACKGROUND-IMAGE: url(pics/norm-backimage.gif); BACKGROUND-REPEAT: repeat-x }
.redLine { BACKGROUND-POSITION: left 50%; BACKGROUND-IMAGE: url(pics/orange_gradiant.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #ff7e0d }
</style>

</HEAD><cfparam name="deferror" default="none">
<cfif isDefined('session.nuerror')>
  <cfif session.nuerror.errors is 'yes'>
    <cfset deferror = 'inline'>
    <cfelse>
    <cfinclude template="error_struct.cfm">
    <cfset deferror = 'none'>
  </cfif>
  <cfelse>
  <cfinclude template="error_struct.cfm">
  <cfset deferror = 'none'>
</cfif>

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
		showCell("pwWeak", "lightgreen", "lightgreen");
		getObjectStyle("pwMedium").borderRightColor = "silver";
		showCell("pwMedium", "black", "lightgreen");
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
		
<cfquery name="userinfo" datasource="mysql">
	SELECT users.firstname, users.lastname, users.username, users.phone, users.city, users.state, users.zip, users.country, users.dob,
		users.email, users.userid, users.usertype, users.address, users.address2, users.fax, users.password, smg_countrylist.countryname, smg_states.state as st,
	 	users.lastchange,users.datelastlogin, users.datecreated, users.occupation, users.businessname, users.cell_phone, users.work_phone, users.whocreated, users.billing_company, users.billing_contact, users.billing_address, 
		users.php_contact_name, users.php_contact_phone, users.php_contact_email,
		users.billing_address2, users.billing_city, users.active, users.billing_country, users.billing_zip, users.billing_phone, users.billing_fax, 
		users.billing_email
	FROM smg_users users
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = users.country  
	LEFT JOIN smg_states ON smg_states.id = users.state  
	WHERE userid = '#url.id#'
</cfquery>

<cfquery name="get_countrylist" datasource="MySql">
	SELECT countryid, countryname
	FROM smg_countrylist
	ORDER BY countryname
</cfquery>	

<cfquery name="state_list" datasource="mysql">
	select statename, id
	from smg_states
	ORDER BY statename
</cfquery>

<cfif userinfo.recordcount gt 0>
  <cfinclude template="current_user_struct.cfm">
</cfif>

<!----If user entered an invalid email address, recheck it to display what is wrong with it---->
<cfoutput>
<form name="Form1" method="post" action="querys/update_user.cfm<cfif isdefined('url.id')>?id=#url.id#</cfif>" id="Form1">
<input type="hidden" name="usertype" value="#client.usertype#">
<input type="hidden" name="userid" value="#userinfo.userid#">

<TABLE cellSpacing="0" cellPadding="0" align="center" class="regContainer">
	<TR vAlign="top">
		<TD></td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr>
		<td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td>
	</tr>
	<tr>
		<td class="orangeLine" colSpan="3" height="11"><img height=11 src="spacer.gif" width=1></td>
	</tr>
	<tr>
		<td colSpan="3" height="10">&nbsp;</td>
	</tr>
	<tr>
		<td width="10">&nbsp;</td>
		<td>
			<!-- Error Message / Validation Summary -->
			<div id="divInvalidFormMsg" style="DISPLAY: #deferror#">
			<!-- Error Message -->
			<table cellSpacing="0" cellPadding="0" width="100%" border="0">
				<tr>
					<td width="6"><img height=6 src="pics/table-borders/err-lefttopcorner.gif" width=6></td>
					<td bgColor="##fcce7c" height="6"><img height=6 src="spacer.gif" width=1 ></td>
					<td width="6"><img height=6 src="pics/table-borders/err-righttopcorner.gif" width=6></td>
				</tr>
				<tr>
					<td class="errMessageGradientStyle" bgColor="##fee1b5"><img height=45 src="spacer.gif" width=1 ></td>
					<td class="errMessageGradientStyle" bgColor="##fee1b5">
						<table cellSpacing="0" cellPadding="10" width="100%" border="0">
							<tr>
								<td vAlign="middle" align="center"><img src="pics/error-exclamate.gif" ></td>
								<td vAlign="middle" align="left">Unfortunately, one or more fields you have 
									submitted require modification. Please check the highlighted fields and 
									instructions below.<br>
								</td>
							</tr>
						</table>
					</td>
					<td class="errMessageGradientStyle" bgColor="##fee1b5"><img height=45 src="spacer.gif" width=1 ></td>
				</tr>
				<tr>
					<td><img height=6 src="pics/table-borders/err-leftbottcorner.gif" width=6></td>
					<td bgColor="##fee1b5"><img height=6 src="spacer.gif" width=1 ></td>
					<td><img height=6 src="pics/table-borders/err-rightbottcorner.gif" width=6></td>
				</tr>
			</table>
			</div>
			<!-- End error message end -->
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
										<TR>
											<TD colSpan="2" height="1"><IMG height=1 src="" width=1></TD>
											<!----First Name---->
											<TD id="input" align="right" height="1">
												<IMG height=1 src="" width=1>
												<LABEL id="lblFNameReq" class="errorMessage"  #session.nuerror.firstname.display#>Please enter your first name<BR></LABEL>
												<LABEL id="lblFNameValid" class="errorMessage">Please check that you entered a valid first name</LABEL>
											</TD>
											<td <cfif session.nuerror.email.reason is 'invalid'>bgcolor="fcdeb4" rowspan=8</cfif>><IMG src="spacer.gif" width=15 height=0></td>
											<TD height="1" colspan="2" rowspan=8 class="helpmsg" valign="bottom" <cfif session.nuerror.email.reason is 'invalid'>bgcolor="fcdeb4"</cfif>>
												<cfif session.nuerror.email.reason is 'invalid'>
													<cfinclude template="../../../exitgroup/email_verify/emailLib.cfm">													
													<cfif validateEmail(session.nuerror.email.value)>
													<cfelse>
														Syntax Check:  <cfif validateEmailSyntax(session.nuerror.email.value)><font color="green">PASSED</font><cfelse><font color="red">FAILED<br> Format should be user@domain.com</font></cfif></b><br>
														Top Level Domain Check: 
														<cfif validateTopLevelDomain(session.nuerror.email.value)><font color="green">PASSED</font><cfelse><font color="red">FAILED<br>Last three letters of email address are wrong.</font></cfif></b><cfflush><br>
															DNS MX lookup Check: 
														<cfif validateMXRecord(session.nuerror.email.value)><font color="green">PASSED</font><cfelse><font color="red">FAILED<br>#getDomain(session.nuerror.email.value)# is not correct.</font></cfif></b><cfflush><br>
														Domain: <b>#getDomain(session.nuerror.email.value)# </b><br>
														User: <b>#getUser(session.nuerror.email.value)#</b><br>
													</cfif>
												<cfelse>
													The security and privacy of your personal information is very important to us 
													and will be protected under our
													<span class = "hyperlink" onclick="javascript:window.open('http://www.mansion.com/content/legalpopup.aspx?p=LegalPrivacyPolicy', 'privacy', 'height=415, width=615, status=no, scrollbars=yes')">privacy policy</span>.
												</cfif>
											</TD>
										</TR>
										<TR vAlign="middle" height="30">
											<Cfif session.nuerror.firstname.class is 'error'>
											<TD width="20" align="center"><LABEL id="lblTitleInd" class="reqField" style="display:#session.nuerror.firstname.display#"><img src='pics/small-alert.gif' height='16' width='16' border='0'></LABEL></TD>
											<cfelse>
											<TD width="20" align="center"><LABEL id="lblTitleInd" class="reqField" style="display:#session.nuerror.firstname.display#">*</LABEL></TD>
											</cfif>	
											<TD id="label"><span id="lblTitle" class="#session.nuerror.firstname.class#Label">First name:</span></TD>
											<TD id="input"><input name="firstname" type="text" maxlength="225" id="firstname" class="#session.nuerror.firstname.class#Input" <cfif session.nuerror.firstname.value is not ''>value='#session.nuerror.firstname.value#'</cfif>></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!-----Last Name---->
										<TR>
											<TD colSpan="2"><IMG height=0 src="spacer.gif" width=1></TD>
											<TD id="input" align="right"><IMG height=0 src="spacer.gif" width=1><LABEL id="lblLNameReq" class="errorMessage" #session.nuerror.lastname.display#>Please enter your last name<BR></LABEL><LABEL id="lblLNameValid" class="errorMessage">Please check that you entered a valid last name</LABEL></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<TR vAlign="middle" height="30">
											<Cfif session.nuerror.lastname.class is 'error'>
											<TD width="20" align="center"><LABEL id="lblTitleInd" class="reqField" style="display:#session.nuerror.lastname.display#"><img src='pics/small-alert.gif' height='16' width='16' border='0'></LABEL></TD>
											<cfelse>
											<TD width="20" align="center"><LABEL id="lblTitleInd" class="reqField" style="display:#session.nuerror.lastname.display#">*</LABEL></TD>
											</cfif>	
											<TD><span id="lblLName" class="#session.nuerror.lastname.class#Label">Last name:</span></TD>
											<TD id="input"><input name="lastname" type="text" maxlength="225" id="lastname" class="#session.nuerror.lastname.class#Input" <cfif session.nuerror.lastname.value is not ''>value='#session.nuerror.lastname.value#'</cfif>></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!----Date of Birth---->
										<tr vAlign="middle" height="30">
											<td align="center"></td>
											<td><span id="lblDOB" class="normalLabel">Date of birth:</span>&nbsp;</td>
											<td id="input"><input name="dob" size="8" type="text" value="#DateFormat(userinfo.dob)#" maxlength="10" style="COLOR: 646464" /> mm/dd/yyyy</td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Email---->
										<TR vAlign="top" height="30">
											<Cfif session.nuerror.email.class is 'error'>
											<TD width="20" align="center"><LABEL id="lblEmailInd" class="reqField" style="display:#session.nuerror.email.display#"><img src='pics/small-alert.gif' height='16' width='16' border='0'></LABEL></TD>
											<cfelse>
											<TD width="20" align="center"><LABEL id="lblEmailInd"  class="reqField" style="display:#session.nuerror.email.display#">*</LABEL></TD>
											</cfif>	
											<TD><span id="lblEmail" class="#session.nuerror.email.class#Label">Email address:</span></TD>
											<TD id="input" <cfif session.nuerror.email.reason is 'invalid'>bgcolor="fcdeb4"</cfif>><input name="email" type="text" maxlength="225" id="email" class="#session.nuerror.email.class#Input" onchange="javascript:copy()" value="#session.nuerror.email.value#"></TD>
											<TD height="1"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
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
			<!-- Personal Details Group -->
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
						<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<!-----Contact Name ---->
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Contact Name:</span></TD>
											<TD align="left"><input name="php_contact_name" class="normalInput" type="text" maxlength="150" value="#userinfo.php_contact_name#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Phone:</span></TD>
											<TD align="left"><input name="php_contact_phone" class="normalInput" type="text" maxlength="20" value="#userinfo.php_contact_phone#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Email:</span></TD>
											<TD align="left"><input name="php_contact_email" class="normalInput" type="text" maxlength="100" value="#userinfo.php_contact_email#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>										
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
											<td align="center"></td>
											<td><span id="lblDOB" class="normalLabel">Business Name:</span>&nbsp;</td>
											<td id="input"><input name="businessname" type="text" maxlength="60" id="businessname" class="normalInput" value='#userinfo.businessname#'></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----- Phone ---->
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Phone:</span></TD>
											<TD align="left"><input name="phone" class="normalInput" type="text" maxlength="15" value="#userinfo.phone#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!----- Fax ---->
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Fax:</span></TD>
											<TD align="left"><input name="fax" class="normalInput" type="text" maxlength="15" value="#userinfo.fax#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!----Address 1---->
										<TR>
											<TD colSpan="2"><IMG height=5 src="spacer.gif" width=1></TD>
											<TD id="input" align="right"><IMG height=1 src="spacer.gif" width=1><LABEL id="lblAddressReq" class="errorMessage"  #session.nuerror.address.display#>Please enter your residential address<BR></LABEL></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<TR vAlign="middle" height="30">
											<TD width="20" align="center">
												<Cfif session.nuerror.email.class is 'error'>
												<LABEL id="lblAddressInd" class="reqField" style="display:#session.nuerror.address.display#"><img src='pics/small-alert.gif' height='16' width='16' border='0'></LABEL>
												<cfelse>
												<LABEL id="lblAddressInd" class="reqField">*</LABEL>
												</cfif>
											</TD>
											<TD id="label"><span id="lblAddress" class="#session.nuerror.address.class#Label">Address:</span></TD>
											<TD id="input"><input name="address" type="text" maxlength="225" id="address" class="#session.nuerror.address.class#Input" value="#session.nuerror.address.value#"></TD>
											<TD width="20"><IMG height=1 src="spacer.gif" width=20></TD>
											<TD class="helpmsg"><IMG height=1 src="spacer.gif"></TD>
										</TR>
										<TR>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input" align="right"><IMG height=1 src="spacer.gif" width=1><LABEL id="lblAddress2Valid" class="errorMessage">Please check that you entered a valid residential address</LABEL></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----address2---->
										<TR vAlign="middle" height="30">
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input"><input name="address2" type="text" maxlength="225" id="address2" class="normalInput" /></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----City---->
										<TR>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input" align="right"><IMG height=1 src="spacer.gif" width=1><LABEL id="lblCityTownReq" class="errorMessage" #session.nuerror.city.display#>Please enter your city or town of residence<BR></LABEL></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<TR vAlign="middle" height="30">
											<TD align="center">
												<Cfif session.nuerror.city.class is 'error'>
													<LABEL id="lblAddressInd" class="reqField" style="display:#session.nuerror.city.display#"><img src='pics/small-alert.gif' height='16' width='16' border='0'></LABEL>
												<cfelse>
													<LABEL id="lblCityTownInd" class="reqField">*</LABEL>
												</cfif>
											</TD>
											<TD><span id="lblCityTown" class="#session.nuerror.city.class#Label">City / Town:</span></TD>
											<TD id="input"><input name="city" type="text" maxlength="225" id="city" class="#session.nuerror.city.class#Input" value="#session.nuerror.city.value#"></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----State---->
										<TR>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input" align="right"><IMG height=1 src="spacer.gif" width=1><LABEL id="lblRegionStateProvinceValid" class="errorMessage" #session.nuerror.state.display#> Please check that you entered a valid state.</LABEL></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<TR vAlign="middle" height="30">
											<TD align="center">
												<Cfif session.nuerror.state.class is 'error'>
												<LABEL id="lblAddressInd" class="reqField" style="display:#session.nuerror.state.display#"><img src='pics/small-alert.gif' height='16' width='16' border='0'></LABEL>
												<cfelse>
												<LABEL id="lblCityTownInd" class="reqField">*</LABEL>
												</cfif>
											</TD>
											<TD><span id="lblCityTown" class="#session.nuerror.state.class#Label">State</TD>
											<TD id="input">
												<cfquery name="states" datasource="mysql">
													select * 
													from smg_states
												</cfquery>
												<select name="state"  class="#session.nuerror.state.class#Input" value="">
													<option value=''></option>
													<cfloop query="states">
														<option value="#id#" <cfif session.nuerror.state.value eq states.id>selected</cfif>>#statename# - #state#</option>
													</cfloop>
												</select>
											</TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----Zip---->
										<TR>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input" align="right"><IMG height=1 src="spacer.gif" width=1><LABEL id="lblZipCodeReq" class="errorMessage"  #session.nuerror.zip.display#>Please enter your post or zip code<BR></LABEL></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<TR vAlign="middle" height="30">
											<TD align="center">
												<Cfif session.nuerror.zip.class is 'error'>
												<LABEL id="lblAddressInd" class="reqField" style="display:#session.nuerror.zip.display#"><img src='pics/small-alert.gif' height='16' width='16' border='0'></LABEL>
												<cfelse>
												<LABEL id="lblZipCodeInd" class="reqField">*</LABEL>
												</cfif>
											</TD>
											<TD><span id="lblZipCode" class="#session.nuerror.zip.class#Label">Post / ZIP code:</span></TD>
											<TD id="input"><input name="zip" type="text" maxlength="100" id="zip" class="#session.nuerror.zip.class#Input" value="#session.nuerror.zip.value#"></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!--- COUNTRY --->
										<tr vAlign="middle" height="30">
											<td align="center"></td>
											<td><span id="lblCountryCode" class="normalLabel">Country:</span></td>
											<td id="input">
												<select name="country">
													<cfloop query="get_countrylist">
													<option value="#countryid#" <cfif countryid EQ userinfo.country>selected</cfif>>#countryname#</option>
													</cfloop>
												</select>								
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
										<TR>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input" align="right"><IMG height=1 src="spacer.gif" width=1><LABEL id="lblUsernameReq" class="errorMessage"  #session.nuerror.username.display#>Please 
													enter a username to be used for your login<BR></LABEL><LABEL id="lblUsernameValid" class="errorMessage">Username 
													not available<BR></LABEL><LABEL id="lblUsernameValid1" class="errorMessage">Your username contains 
													invalid characters - please try a different username</LABEL>
											</TD>
											<TD colSpan="2"><IMG height=5 src="spacer.gif" width=1></TD>
										</TR>
										<TR vAlign="middle" height="30">
											<TD align="center" width="20">
												<Cfif session.nuerror.username.class is 'error'>
												<LABEL id="lblAddressInd" class="reqField" style="display:#session.nuerror.username.display#"><img src='pics/small-alert.gif' height='16' width='16' border='0'></LABEL>
												<cfelse>
												<LABEL id="lblUsernameInd" class="reqField">*</LABEL>
												</cfif>
											</TD>
											<TD id="label"><span id="lblUsername" class="#session.nuerror.username.class#Label">Username:</span></TD>
											<TD id="input"><input name="username" type="text" maxlength="64" id="username" class="#session.nuerror.username.class#Input" value="#session.nuerror.username.value#" />&nbsp;</TD>
											<TD width="20"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----Password---->
										<TR>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input" align="right"><IMG height=1 src="spacer.gif" width=1>
									  			<cfif session.nuerror.password.reason is 'notsecure'>
									   			<LABEL id="lblPasswordValid2" class="errorMessage" #session.nuerror.password.display#>Your password, unfortunately, is not secure enough - please ensure that it follows our recommended security guidelines</LABEL>
											    <Cfelseif session.nuerror.password.reason is 'blank'>
											    <LABEL id="lblPasswordReq" class="errorMessage"  #session.nuerror.password.display#>Please enter a password<BR></LABEL>
											    <cfelseif session.nuerror.password.reason is 'nomatch'>
											    <LABEL id="lblPasswordValid1" class="errorMessage" #session.nuerror.password.display#>Your passwords did not match. Please reneter your password. <BR></LABEL>
											    </cfif>
											    <LABEL id="lblPasswordValid3" class="errorMessage">Your password can not be same as your username/nickname</LABEL>
											</TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<TR vAlign="top" height="30">
											<TD align="center"><LABEL id="lblPasswordInd" class="reqField">*</LABEL></TD>
											<TD><span id="lblPassword" class="normalLabel">Password:</span>&nbsp; <SPAN class="helpmsg">(6 characters minimum)</SPAN></TD>										
											<input type="hidden" name="passok" value='no'>
											<TD id="input"><input name="password" type="password" maxlength="32" id="Password" value="#session.nuerror.password.value#" class="#session.nuerror.password.class#Input" onkeyup="javascript:passwordChanged(this);" onchange="javascript:passwordChanged(this);" /></TD>
											<TD><IMG height=1 src="spacer.gif" width=1></TD>
											<TD class="helpmsg" vAlign="top" rowSpan="3">We recommend using a strong password:<BR><IMG height=5 src="spacer.gif" width=1>
												<DIV style="MARGIN-LEFT: 15px">- At least 2 letters<LABEL id="lblUsernameInd" class="reqField">*</LABEL><BR>
													- At least 2 numbers<LABEL id="lblUsernameInd" class="reqField">*</LABEL><BR>
													- One or more special characters (e.g. !, $, ##)
												</DIV>
											</TD>
										</TR>
										<!----Password Indicator---->
										<TR vAlign="top">
											<TD colSpan="2" height="8"><IMG height=8 src="spacer.gif" width=1></TD>
											<TD id="input" height="20">Password strength indicator:</TD>
											<TD height="8"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<TR vAlign="top" height="30">
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input">
												<TABLE id="pwOuterTable" cellSpacing="0" cellPadding="1">
													<TR>
														<TD>
															<TABLE id="pwTable" cellSpacing="0" cellPadding="3" width="100%">
																<TR>
																	<TD id="pwWeak" title="Has at least 2 letters but less than 2 numbers" align="center" width="34%">Unacceptable</TD>
																	<TD id="pwMedium" title="Has at least 2 letters and 2 numbers and at least 6 characters in length" align="center" width="33%">Acceptable</TD>
																	<TD id="pwStrong" title="Has at least 2 letters, 2 numbers and either 10 characters in length or has at least one special characters" align="center" width="33%">Strong</TD>
																</TR>
															</TABLE>
														</TD>
													</TR>
												</TABLE>
											</TD>
											<TD><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----Confirm Passoword---->
										<TR>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input" align="right"><IMG height=1 src="spacer.gif" width=1><LABEL id="lblConfirmPwdReq" class="errorMessage"  #session.nuerror.password.value#>Please 
												  confirm your password<BR></LABEL><LABEL id="lblConfirmPwdValid" class="errorMessage">Unfortunately, your 
												  passwords do not match - please ensure that they do</LABEL>
											</TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<TR vAlign="middle" height="30">
											<TD align="center"><LABEL id="lblConfirmPwdInd" class="reqField">*</LABEL></TD>
											<TD><span id="lblConfirmPwd" class="normalLabel">Confirm password:</span></TD>
											<TD id="input"><input name="password2" type="password" maxlength="32" value="#session.nuerror.password.value#" id="ConfirmPwd" class="normalInput" /></TD>
											<TD><IMG height=1 src="spacer.gif" width=1></TD>
											<TD class="helpmsg"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
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
		</TD>
		<td width="10">&nbsp;</td>
	</TR>
	<tr>
		<td><IMG height=55 src="spacer.gif" width=1></td>
        <td align="center"><input type="image" name="imgSubmit"  src="pics/update.gif" alt="Submit" border="0" /></td>
		<td>&nbsp; 
			<!-- Personal Details -->
			<!-- Address Details -->
			<!-- Account Details -->
		</td>
	</tr>
	<tr>
		<td class="footer" colSpan="3"></td>
	</tr>
</TABLE>

</TD>
</TR>
</TBODY>
</TABLE> 

</form>
</cfoutput>
</body></HTML>