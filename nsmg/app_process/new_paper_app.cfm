<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Application Received</title>
<SCRIPT LANGUAGE="JavaScript">
<!-- Original:  Richard Gorremans (RichardG@spiritwolfx.com) -->
<!-- Web Site:  http://www.spiritwolfx.com -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
// Check browser version
var isNav4 = false, isNav5 = false, isIE4 = false
var strSeperator = "/"; 
// If you are using any Java validation on the back side you will want to use the / because 
// Java date validations do not recognize the dash as a valid date separator.
var vDateType = 1; // Global value for type of date format
//                1 = mm/dd/yyyy
//                2 = yyyy/dd/mm  (Unable to do date check at this time)
//                3 = dd/mm/yyyy
var vYearType = 4; //Set to 2 or 4 for number of digits in the year for Netscape
var vYearLength = 2; // Set to 4 if you want to force the user to enter 4 digits for the year before validating.
var err = 0; // Set the error code to a default of zero
if(navigator.appName == "Netscape") {
if (navigator.appVersion < "5") {
isNav4 = true;
isNav5 = false;
}
else
if (navigator.appVersion > "4") {
isNav4 = false;
isNav5 = true;
   }
}
else {
isIE4 = true;
}
function DateFormat(vDateName, vDateValue, e, dateCheck, dateType) {
vDateType = dateType;
// vDateName = object name
// vDateValue = value in the field being checked
// e = event
// dateCheck 
// True  = Verify that the vDateValue is a valid date
// False = Format values being entered into vDateValue only
// vDateType
// 1 = mm/dd/yyyy
// 2 = yyyy/mm/dd
// 3 = dd/mm/yyyy
//Enter a tilde sign for the first number and you can check the variable information.
if (vDateValue == "~") {
alert("AppVersion = "+navigator.appVersion+" \nNav. 4 Version = "+isNav4+" \nNav. 5 Version = "+isNav5+" \nIE Version = "+isIE4+" \nYear Type = "+vYearType+" \nDate Type = "+vDateType+" \nSeparator = "+strSeperator);
vDateName.value = "";
vDateName.focus();
return true;
}
var whichCode = (window.Event) ? e.which : e.keyCode;
// Check to see if a seperator is already present.
// bypass the date if a seperator is present and the length greater than 8
if (vDateValue.length > 8 && isNav4) {
if ((vDateValue.indexOf("-") >= 1) || (vDateValue.indexOf("/") >= 1))
return true;
}
//Eliminate all the ASCII codes that are not valid
var alphaCheck = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/-";
if (alphaCheck.indexOf(vDateValue) >= 1) {
if (isNav4) {
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
else {
vDateName.value = vDateName.value.substr(0, (vDateValue.length-1));
return false;
   }
}
if (whichCode == 8) //Ignore the Netscape value for backspace. IE has no value
return false;
else {
//Create numeric string values for 0123456789/
//The codes provided include both keyboard and keypad values
var strCheck = '47,48,49,50,51,52,53,54,55,56,57,58,59,95,96,97,98,99,100,101,102,103,104,105';
if (strCheck.indexOf(whichCode) != -1) {
if (isNav4) {
if (((vDateValue.length < 6 && dateCheck) || (vDateValue.length == 7 && dateCheck)) && (vDateValue.length >=1)) {
alert("Invalid Date\nPlease Re-Enter");
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
if (vDateValue.length == 6 && dateCheck) {
var mDay = vDateName.value.substr(2,2);
var mMonth = vDateName.value.substr(0,2);
var mYear = vDateName.value.substr(4,4)
//Turn a two digit year into a 4 digit year
if (mYear.length == 2 && vYearType == 4) {
var mToday = new Date();
//If the year is greater than 30 years from now use 19, otherwise use 20
var checkYear = mToday.getFullYear() + 30; 
var mCheckYear = '20' + mYear;
if (mCheckYear >= checkYear)
mYear = '19' + mYear;
else
mYear = '20' + mYear;
}
var vDateValueCheck = mMonth+strSeperator+mDay+strSeperator+mYear;
if (!dateValid(vDateValueCheck)) {
alert("Invalid Date\nPlease Re-Enter");
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
return true;
}
else {
// Reformat the date for validation and set date type to a 1
if (vDateValue.length >= 8  && dateCheck) {
if (vDateType == 1) // mmddyyyy
{
var mDay = vDateName.value.substr(2,2);
var mMonth = vDateName.value.substr(0,2);
var mYear = vDateName.value.substr(4,4)
vDateName.value = mMonth+strSeperator+mDay+strSeperator+mYear;
}
if (vDateType == 2) // yyyymmdd
{
var mYear = vDateName.value.substr(0,4)
var mMonth = vDateName.value.substr(4,2);
var mDay = vDateName.value.substr(6,2);
vDateName.value = mYear+strSeperator+mMonth+strSeperator+mDay;
}
if (vDateType == 3) // ddmmyyyy
{
var mMonth = vDateName.value.substr(2,2);
var mDay = vDateName.value.substr(0,2);
var mYear = vDateName.value.substr(4,4)
vDateName.value = mDay+strSeperator+mMonth+strSeperator+mYear;
}
//Create a temporary variable for storing the DateType and change
//the DateType to a 1 for validation.
var vDateTypeTemp = vDateType;
vDateType = 1;
var vDateValueCheck = mMonth+strSeperator+mDay+strSeperator+mYear;
if (!dateValid(vDateValueCheck)) {
alert("Invalid Date\nPlease Re-Enter");
vDateType = vDateTypeTemp;
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
vDateType = vDateTypeTemp;
return true;
}
else {
if (((vDateValue.length < 8 && dateCheck) || (vDateValue.length == 9 && dateCheck)) && (vDateValue.length >=1)) {
alert("Invalid Date\nPlease Re-Enter");
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
         }
      }
   }
}
else {
// Non isNav Check
if (((vDateValue.length < 8 && dateCheck) || (vDateValue.length == 9 && dateCheck)) && (vDateValue.length >=1)) {
alert("Invalid Date\nPlease Re-Enter");
vDateName.value = "";
vDateName.focus();
return true;
}
// Reformat date to format that can be validated. mm/dd/yyyy
if (vDateValue.length >= 8 && dateCheck) {
// Additional date formats can be entered here and parsed out to
// a valid date format that the validation routine will recognize.
if (vDateType == 1) // mm/dd/yyyy
{
var mMonth = vDateName.value.substr(0,2);
var mDay = vDateName.value.substr(3,2);
var mYear = vDateName.value.substr(6,4)
}
if (vDateType == 2) // yyyy/mm/dd
{
var mYear = vDateName.value.substr(0,4)
var mMonth = vDateName.value.substr(5,2);
var mDay = vDateName.value.substr(8,2);
}
if (vDateType == 3) // dd/mm/yyyy
{
var mDay = vDateName.value.substr(0,2);
var mMonth = vDateName.value.substr(3,2);
var mYear = vDateName.value.substr(6,4)
}
if (vYearLength == 4) {
if (mYear.length < 4) {
alert("Invalid Date\nPlease Re-Enter");
vDateName.value = "";
vDateName.focus();
return true;
   }
}
// Create temp. variable for storing the current vDateType
var vDateTypeTemp = vDateType;
// Change vDateType to a 1 for standard date format for validation
// Type will be changed back when validation is completed.
vDateType = 1;
// Store reformatted date to new variable for validation.
var vDateValueCheck = mMonth+strSeperator+mDay+strSeperator+mYear;
if (mYear.length == 2 && vYearType == 4 && dateCheck) {
//Turn a two digit year into a 4 digit year
var mToday = new Date();
//If the year is greater than 30 years from now use 19, otherwise use 20
var checkYear = mToday.getFullYear() + 30; 
var mCheckYear = '20' + mYear;
if (mCheckYear >= checkYear)
mYear = '19' + mYear;
else
mYear = '20' + mYear;
vDateValueCheck = mMonth+strSeperator+mDay+strSeperator+mYear;
// Store the new value back to the field.  This function will
// not work with date type of 2 since the year is entered first.
if (vDateTypeTemp == 1) // mm/dd/yyyy
vDateName.value = mMonth+strSeperator+mDay+strSeperator+mYear;
if (vDateTypeTemp == 3) // dd/mm/yyyy
vDateName.value = mDay+strSeperator+mMonth+strSeperator+mYear;
} 
if (!dateValid(vDateValueCheck)) {
alert("Invalid Date\nPlease Re-Enter");
vDateType = vDateTypeTemp;
vDateName.value = "";
vDateName.focus();
return true;
}
vDateType = vDateTypeTemp;
return true;
}
else {
if (vDateType == 1) {
if (vDateValue.length == 2) {
vDateName.value = vDateValue+strSeperator;
}
if (vDateValue.length == 5) {
vDateName.value = vDateValue+strSeperator;
   }
}
if (vDateType == 2) {
if (vDateValue.length == 4) {
vDateName.value = vDateValue+strSeperator;
}
if (vDateValue.length == 7) {
vDateName.value = vDateValue+strSeperator;
   }
} 
if (vDateType == 3) {
if (vDateValue.length == 2) {
vDateName.value = vDateValue+strSeperator;
}
if (vDateValue.length == 5) {
vDateName.value = vDateValue+strSeperator;
   }
}
return true;
   }
}
if (vDateValue.length == 10&& dateCheck) {
if (!dateValid(vDateName)) {
// Un-comment the next line of code for debugging the dateValid() function error messages
//alert(err);  
alert("Invalid Date\nPlease Re-Enter");
vDateName.focus();
vDateName.select();
   }
}
return false;
}
else {
// If the value is not in the string return the string minus the last
// key entered.
if (isNav4) {
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
else
{
vDateName.value = vDateName.value.substr(0, (vDateValue.length-1));
return false;
         }
      }
   }
}
function dateValid(objName) {
var strDate;
var strDateArray;
var strDay;
var strMonth;
var strYear;
var intday;
var intMonth;
var intYear;
var booFound = false;
var datefield = objName;
var strSeparatorArray = new Array("-"," ","/",".");
var intElementNr;
// var err = 0;
var strMonthArray = new Array(12);
strMonthArray[0] = "Jan";
strMonthArray[1] = "Feb";
strMonthArray[2] = "Mar";
strMonthArray[3] = "Apr";
strMonthArray[4] = "May";
strMonthArray[5] = "Jun";
strMonthArray[6] = "Jul";
strMonthArray[7] = "Aug";
strMonthArray[8] = "Sep";
strMonthArray[9] = "Oct";
strMonthArray[10] = "Nov";
strMonthArray[11] = "Dec";
//strDate = datefield.value;
strDate = objName;
if (strDate.length < 1) {
return true;
}
for (intElementNr = 0; intElementNr < strSeparatorArray.length; intElementNr++) {
if (strDate.indexOf(strSeparatorArray[intElementNr]) != -1) {
strDateArray = strDate.split(strSeparatorArray[intElementNr]);
if (strDateArray.length != 3) {
err = 1;
return false;
}
else {
strDay = strDateArray[0];
strMonth = strDateArray[1];
strYear = strDateArray[2];
}
booFound = true;
   }
}
if (booFound == false) {
if (strDate.length>5) {
strDay = strDate.substr(0, 2);
strMonth = strDate.substr(2, 2);
strYear = strDate.substr(4);
   }
}
//Adjustment for short years entered
if (strYear.length == 2) {
strYear = '20' + strYear;
}
strTemp = strDay;
strDay = strMonth;
strMonth = strTemp;
intday = parseInt(strDay, 10);
if (isNaN(intday)) {
err = 2;
return false;
}
intMonth = parseInt(strMonth, 10);
if (isNaN(intMonth)) {
for (i = 0;i<12;i++) {
if (strMonth.toUpperCase() == strMonthArray[i].toUpperCase()) {
intMonth = i+1;
strMonth = strMonthArray[i];
i = 12;
   }
}
if (isNaN(intMonth)) {
err = 3;
return false;
   }
}
intYear = parseInt(strYear, 10);
if (isNaN(intYear)) {
err = 4;
return false;
}
if (intMonth>12 || intMonth<1) {
err = 5;
return false;
}
if ((intMonth == 1 || intMonth == 3 || intMonth == 5 || intMonth == 7 || intMonth == 8 || intMonth == 10 || intMonth == 12) && (intday > 31 || intday < 1)) {
err = 6;
return false;
}
if ((intMonth == 4 || intMonth == 6 || intMonth == 9 || intMonth == 11) && (intday > 30 || intday < 1)) {
err = 7;
return false;
}
if (intMonth == 2) {
if (intday < 1) {
err = 8;
return false;
}
if (LeapYear(intYear) == true) {
if (intday > 29) {
err = 9;
return false;
   }
}
else {
if (intday > 28) {
err = 10;
return false;
      }
   }
}
return true;
}
function LeapYear(intYear) {
if (intYear % 100 == 0) {
if (intYear % 400 == 0) { return true; }
}
else {
if ((intYear % 4) == 0) { return true; }
}
return false;
}
//  End -->
</script>

</head>

<body>
<!----Query for Programs---->
<cfquery name="program_types" datasource="mysql">
	SELECT app_programid, app_program
	FROM smg_student_app_programs 
	WHERE app_type = 'regular'
</cfquery>

<!----Query for Int Reps---->
<cfquery name="int_reps" datasource="mysql">
	select businessname, userid
	from smg_users
	where usertype = 8 and active = 1
	order by businessname
</cfquery>

<!----Query for country---->
<cfquery name="country_list" datasource="MySQL">
	select countryname, countryid
	from smg_countrylist
	ORDER BY countryname
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>Receiving an Application</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput>
<cfform method="post" action="?curdoc=app_process/qr_new_paper_app">
<cfset tid = createuuid()>
<input type="hidden" name="uniqueid" value='#tid#'>
<table width=100% class="section">	
	<tr>
		<td>
				<table>
					<tr>
						<th colspan=2 align="left">1)  Program Choice</th>
					</tr>
					<cfloop query="program_types">
					<Tr>
						<td><cfinput type="radio" name="app_indicated_program" message="Please indicate Program Choice." required="yes" value="#app_programid#"></td><td>#app_program#</td>
					</Tr>
					</cfloop>
				</table>
		</td>
		<td valign="top">
				<table>
				<tr>
						<th colspan=2 align="left">2) International Representative</th>
					</tr>
					<tr>
						<td colpsan=2>
						<cfselect name="intrep" required="yes" message="Please indicate International Representative.">
						<option value=""></option>
						<cfloop query="int_reps">
						<option value="#userid#">#businessname#</option>
						</cfloop>
						</cfselect>
						</td>
					</tr>
				</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
					
				
				<table >
				<tr>
						<th colspan=2 align="left">3) First & Last Name</th>
					</tr>
						<tr>
						<td>Last Name</td>
						<td><cfinput type="text" name="familylastname" size=25 required="yes" message="Please indicate Last Name." />
				</td>
				<tr>	
						<td>
						First Name
						</td>
						<td>
						<cfinput type="text" name="firstname" size=25 required="yes" message="Please indicate First Name."/>
						</td>
						
					</tr>
				
				</table>

			</td>
			<td valign="top">


				
				<table>
				<tr>
						<th colspan=2 align="left">4) Birthday</th>
					</tr>
					<tr>
						<td></td>
							<td><cfinput type="text" name="dob" size='11' maxlength="11" onFocus="javascript:vDateType='1'" onKeyUp="DateFormat(this,this.value,event,false,'1')" onBlur="DateFormat(this,this.value,event,true,'1')" required="yes" message="Please indicate Birthday."> Enter only numbers in mmddyyyy format. 
				
						
						
					</tr>
				
				</table>
				
			</td>
		</tr>
		<tr>
			<td valign="top">		
					<table>
					
					<tr><th colspan=2 align="left">5) Country of Legal Permanent Residence:</td>
					</tr>
					<tr>
									<td><cfselect name="Countryresidence" required="yes" message="Please indicate Country of Legal Permanent Residence.">
										<option value="">Country...</option>
										<cfloop query="country_list">
										  <!--- do not show Serbia and Montenegro SEVIS --->
										  <cfif countryid NEQ 250>						
											<option value="#countryid#">#countryname#</option>
										  </cfif>
										</cfloop>
										</cfselect></td></tr>
					</table>
			</td>
			<td valign="top">

					<table>
						<Tr>
							<th align="left">6) Sex:</td>
						</Tr>
						<tr>	
							<td class="form_text"><cfinput type="radio" name="sex" value="male" required="yes" message="Please indicate Sex.">Male <cfinput type="radio" name="sex" required value="female" message="Please indicate 6) Sex.">Female</td></tr>
						</Tr>
					</table>
					
			</td>
			</tr>
			<tr>
				<td align="center" colspan=6><cfinput type="image" name="submit" value="Submit" src="pics/add-student.gif">
			</tr>
		</table>
</cfform>
</cfoutput>
	<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign=bottom >
				<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
				<td width=100% background="pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
			</tr>
		</table>
</body>
</html>