<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [04] - Family Photo Album</title>
</head>
<body>

<cftry>

<script>
function areYouSure() { 
   if(confirm("You are about to delete this picture and description. Click OK to confirm and continue.")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
function GetFile() { 
   document.upload.file_name.value = document.upload.family_pic.value;
}
</script>

<!---
var newwindow;
function OpenDesc(url) {
	newwindow=window.open(url, 'App-Desc', 'height=300, width=600, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
<a class="nav_bar" href="javascript:OpenDesc('section1/add_description.cfm?img=#name#');">
--->

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section1/page4print&id=1&p=4" addtoken="no">
</cfif>

<cfsilent>
	<cfsavecontent variable="buttonStyle">
	   corner-radius: 2;
		borderThickness: 0;
	   fill-colors: #B4E055, #9FD32E;
	   color: #ffffff;
	</cfsavecontent>
	<cfsavecontent variable="progressBarStyle">
	   border-thickness:0;
	   corner-radius: 0;
		 fill-colors: #ffffff, #DEEC6A;
		 theme-color: #A2DA2C;
		 border-color:#A2DA2C;
		 color:#ffffff;
	</cfsavecontent>
	<cfsavecontent variable="outputStyle">
		borderStyle:none;
		disabledColor:#333333;
		backgroundAlpha:0;
	</cfsavecontent>
	<cfsavecontent variable="contentPanelStyle">
		panelBorderStyle:'roundCorners';
		backgroundColor:#EFF7DF;
		headerColors:#CBEC84, #B0D660;
	</cfsavecontent>	
</cfsilent>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [04] - Family Photo Album</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page4print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<cfset nsmg_directory = '/var/www/html/student-management/nsmg/uploadedfiles/online_app/picture_album/#client.studentid#'>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>  
		<td> 
			<cfoutput>
			<cfdirectory action="list" name="fam_pics" directory="#nsmg_directory#">
			Please upload recent pictures (within 2 years) of you, your family, and friends.  
			Describe each photo in the space provided. <br> 
			<strong>PICTURES SHOULD BE EITHER JPEG, JPG OR GIF. </strong><br>
			Please make sure the size of each photo is 2mb or less. You can upload up to ten (10) photos.<br><br>
			<b>Rename photos so file name <strong>ONLY</strong> contains letters or numbers.  <strong>DO NOT</strong> use symbols or letters with accent marks.<br>
			<br>
			<!----Upload Pic---->
			
			<cfif fam_pics.recordcount GTE 10>
				<b>You have reached the limit of ten (10) uploaded photos. <br>
				You are not able to upload more photos unless you decide to delete one of the photos below.<br><br></b>
			<cfelse>
				<div align="center">
					<a href="" onClick="javascript: win=window.open('http://upload.student-management.com/form_upload_album.cfm?studentid=#client.studentid#', 'UploadPics', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/uploadpic.gif" border=0></a>
				</div>
				<br><br>
			</cfif>
			</cfoutput>
			Below are the pictures currently in your family album.<br><br>

			<cfif fam_pics.recordcount eq 0>
				No pictures have been uploaded<br><br>
			<cfelse>
				<cfoutput query="fam_pics">
					<cfquery name="pic_description" datasource="MySQL">
						SELECT description 
						FROM smg_student_app_family_album
						WHERE studentid = #client.studentid# and filename = '#name#'
					</cfquery>
					<table>
						<tr>
							<td><img src="../uploadedfiles/online_app/picture_album/#client.studentid#/#name#" width=200></td>
							<td width=250 align="left">&nbsp; #pic_description.description#</td>
						</tr>
						<tr>
							<td colspan="2"> 
								<a href="querys/qr_delete_album.cfm?studentid=#client.studentid#&img=#URLEncodedFormat(name)#" onClick="return areYouSure(this);"><img src="../pics/button_drop.png" border=0> Delete</a>
								<a href="" onClick="javascript: win=window.open('section1/add_description.cfm?img=#name#', 'Settings', 'height=350, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="../pics/notes.gif" border=0> Add / Edit Description</a>
							</td>
						</tr>
					</table>
					<br><hr class="bar"></hr><br>
				</cfoutput>
			</cfif>
		</td>
	</tr>
</table>
</div>

<table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
	<tr>
		<td align="center" valign="bottom" class="buttontop">
			<form action="?curdoc=section1/page5&id=1&p=5" method="post">
			<input name="Submit" type="image" src="pics/next_page.gif" border=0 alt="Go to the next page">
			</form>
		</td>
	</tr>
</table>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>