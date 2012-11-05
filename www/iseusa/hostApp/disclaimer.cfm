<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Terms for Submission</title>
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<link rel="stylesheet" href="../linked/css/baseStyle.css" />
</head>
<cfparam name="form.signature" default="">
<body>
<cfset season = 10>
<cfset dirPath = "C:/websites/student-management/nsmg/">
<cfif isDefined('form.submitSignature')>
<cfscript>
 if ( NOT LEN(TRIM(FORM.signature)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please type your name in the signature box.");
 }
 </cfscript>

 <cfif NOT SESSION.formErrors.length()>
 <!----Generate PDF of signature page---->
				
                    
                      <cfif DirectoryExists('#dirPath#uploadedfiles/hosts/#client.hostid#/')>
        				<cfelse>
           				 <cfdirectory action = "create" directory = "#dirPath#uploadedfiles/hosts/#client.hostid#/" >
        				</cfif>
                    <cfdocument format="PDF" filename="#dirPath#uploadedfiles/hosts/#client.hostid#/hostApplicationTerms.pdf" overwrite="yes">
                    <!--- form.pr_id and form.report_mode are required for the progress report in print mode.
                    form.pdf is used to not display the logo which isn't working on the PDF. --->
                    <cfset form.report_mode = 'print'>
                    <cfset form.pdf = 1>
                    <table align="center" width=80% cellpadding="4">
	<tr>
    	<Th align="left"><h2>Terms for Submission</h2></Th>
    </tr>
    <tr>
    	<td><hr width=70% /></td>
    </tr>
    <tr>
    	<td>
Applicants and their families certify that all information submitted in the Host Family Application - including the application, the Host Family Letter, any supplements, and any other supporting materials - is honestly presented and accurate; and that these documents will become the property of the exchange organization and will not be returned.         
 <br /><br />
Applicants and their families understand that the signature below constitutes a willingness of all members of the household to host an Exchange Student through the exchange organization and comply with the exchange organization and the Department of State Regulations. Applicants also agree, as per Department of State mandate, to notify the exchange organization if the composition of their household changes and if additional criminal background checks need to be conducted.
<br /><br />Applicants and their families understand and acknowledge that by signing this application the exchange organization maintains jurisdiction over all aspects of the student exchange program.  In the event of any problem between the student and the American host family, the exchange organization reserves the right to remove the student at any time to resolve the situation.
		</Td>
  </tr>
     <tr>
     	<td>Signature: <cfoutput>#form.signature#</cfoutput><br />
        <em>(typing your name above is considered the same as a physical signature)</em></td>
     </tr>
<tr>
	<Td>
                    <br /><Br />
                    <Cfoutput>
                    Electronically Signed<Br />
                    #form.signature#<br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<Br />
                    IP: #cgi.REMOTE_ADDR# 
      </td>
  </tr>
</table>
      
                    </Cfoutput>
                </cfdocument>   
                <cfquery name="insertDocInfo" datasource="mysql">
                insert into smg_documents (fileName, type, dateFiled, filePath, description, shortDesc, userid, userType, hostID, seasonID)
                				values('hostApplicationTerms.pdf', 'pdf', #now()#, 'hosts/#client.hostid#/', 'Terms for Submission of Host Application','Host App Terms',#client.hostid#, 'Family Member', #client.hostID#, #season#)
                </cfquery> 
         <div align="center">
                
                <h1>Succesfully Submited.</h1>
                <em>this window should close shortly</em>
                </div>
            
                 <body onLoad="parent.$.fn.colorbox.close();">
                 
                    <cfabort>
 </cfif>
  </cfif>
<!--- Form Errors --->
 <cfif SESSION.formErrors.length()>
<table align="Center" bgcolor="#FFFFCC">
	<Tr>
    	<td>
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
 </div>
</td>
</tr>
</table>
</cfif>

<table align="center" width=80% cellpadding="4">
	<tr>
    	<Th align="left"><h2>Terms for Submission</h2></Th>
    </tr>
    <tr>
    	<td><hr width=70% /></td>
    </tr>
    <tr>
    	<td>
Applicants and their families certify that all information submitted in the Host Family Application - including the application, the Host Family Letter, any supplements, and any other supporting materials - is honestly presented and accurate; and that these documents will become the property of the exchange organization and will not be returned.         
 <br /><br />
Applicants and their families understand that the signature below constitutes a willingness of all members of the household to host an Exchange Student through the exchange organization and comply with the exchange organization and the Department of State Regulations. Applicants also agree, as per Department of State mandate, to notify the exchange organization if the composition of their household changes and if additional criminal background checks need to be conducted.
<br /><br />Applicants and their families understand and acknowledge that by signing this application the exchange organization maintains jurisdiction over all aspects of the student exchange program.  In the event of any problem between the student and the American host family, the exchange organization reserves the right to remove the student at any time to resolve the situation.
		</Td>
  </tr>
     <tr>
     <form method="post" action="disclaimer.cfm">
     <input type="hidden" name="submitSignature" />
     	<td>Signature: <input type="text" name="signature" size=35 /><br />
        <em>(typing your name above is considered the same as a physical signature)</em><br /><br />
        <input name="Submit" type="image" src="../images/buttons/Next.png" border=0> </td>
        </form>
     </tr>
 </table>

</body>
</html>