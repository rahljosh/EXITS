<!--- Kill Extra Output --->
<cfsilent>

	<cfinclude template="../querys/get_student_info.cfm">

	<cfscript>
		// Set up image path
		if ( IsDefined('url.curdoc') OR IsDefined('url.path') ) {
			path = "";
		} else if ( IsDefined('url.exits_app') )  {
			path = "nsmg/student_app/";
		} else {
			path = "../";
		}
		
		// These are used to print regular / blank agreements
		if ( ListFindNoCase(CGI.SCRIPT_NAME, "print_blankApplication.cfm", "/") ) {
			studentInfo = '&nbsp;';
		} else {
			// Print regular application
			studentInfo = '&nbsp; #get_student_info.firstname# #get_student_info.familylastname# &nbsp;';
		}
	</cfscript>

	<!--- Public High School Travel Authorization --->
    <cfsavecontent variable="publicAgreement">
        <p>
            We, as Parents of the Undersigned Student, do hereby authorize the exchange organization, the exchange organization's Area Representative, and the American Host parents as agents of the 
            Undersigned Parents, to make the determination for student travel for the duration of students participation in the Academic Year Program.
        </p>
        <p>
            It is understood that this Authorization is given in advance only when the Student is traveling and supervised by an exchange program Representative, Host Parent or by a Representative of 
            a school program, or with tours sponsored by the exchange organization. We understand that the Student may not travel unsupervised.
        </p>
	</cfsavecontent>
    
    <!--- Canada Travel Authorization --->
	<cfsavecontent variable="canadaAgreement">
        <p>
            We, as Parents of the Undersigned Student, do hereby authorize the exchange organization, the exchange organization's Area Representative, and Host parents as agents of the 
            Undersigned Parents, to make the determination for student travel for the duration of students participation in the Academic Year Program.
        </p>
        <p>
            It is understood that this Authorization is given in advance only when the Student is traveling and supervised by an exchange program Representative, Host Parent or by a Representative of 
            a school program, or with tours sponsored by the exchange organization. We understand that the Student may not travel unsupervised.
        </p>
    </cfsavecontent>
    
</cfsilent>

<cfoutput>

<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr>
		<td width="110" style="padding-left:10px;"><em>Student's Name</em></td>
		<td width="560">#studentInfo#<br><img src="#path#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
	</tr>
</table> <br />

<table width="660" cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td style="text-align:justify">

            <cfif ListFind("14,15,16", get_student_info.app_indicated_program)>            	
				<!--- Canada Agreement --->
                #canadaAgreement#
            <cfelse>
		        <!--- Public High School Agreement --->
                #publicAgreement#
            </cfif>            
                
		</td>
	</tr>
</table> <br />

<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td width="210" style="padding-left:10px;"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
		<td width="5"></td>
		<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>		
		<td width="40"></td>
		<td width="210"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
		<td width="5"></td>
		<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td style="padding-left:10px;">Signature of Parent</td>
		<td></td>
		<td>Date</td>
		<td></td>
		<td>Signature of Student</td>
		<td></td>
		<td>Date</td>	
	</tr>
</table> <br /> <br />

</cfoutput>

