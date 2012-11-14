<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Terms for Submission</title>
<cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
<link rel="stylesheet" href="linked/css/baseStyle.css" />
</head>
<cfparam name="FORM.signature" default="">
<body>
<cfset season = 10>
<cfif isDefined('FORM.submitSignature')>
<cfscript>
 if ( NOT LEN(TRIM(FORM.signature)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please type your name in the signature box.");
 }
 </cfscript>

 <cfif NOT SESSION.formErrors.length()>
 <!----Generate PDF of signature page---->
				
                    
                    <cfdocument format="PDF" filename="#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS#hostApplicationTerms.pdf" overwrite="yes">
                    <cfset FORM.report_mode = 'print'>
                    <cfset FORM.pdf = 1>
                    <table align="center" width=80% cellpadding="4">
	<tr>
    	<Th align="left"><h2>Terms for Submission</h2></th>
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
		</td>
  </tr>
     <tr>
     	<td>Signature: <cfoutput>#FORM.signature#</cfoutput><br />
        <em>(typing your name above is considered the same as a physical signature)</em></td>
     </tr>
<tr>
	<td>
                    <br /><Br />
                    <Cfoutput>
                    Electronically Signed<Br />
                    #FORM.signature#<br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<Br />
                    IP: #cgi.REMOTE_ADDR# 
      </td>
  </tr>
</table>
      
                    </Cfoutput>
                </cfdocument>   
                <cfquery name="insertDocInfo" datasource="#APPLICATION.DSN.Source#">
                insert into smg_documents (fileName, type, dateFiled, filePath, description, shortDesc, userid, userType, hostID, seasonID)
                				values('hostApplicationTerms.pdf', 'pdf', #now()#, 'hosts/#APPLICATION.CFC.SESSION.getHostSession().ID#/', 'Terms for Submission of Host Application','Host App Terms',#APPLICATION.CFC.SESSION.getHostSession().ID#, 'Family Member', #APPLICATION.CFC.SESSION.getHostSession().ID#, #season#)
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
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        
</cfif>

<table align="center" width=80% cellpadding="4">
	<tr>
    	<Th align="left"><h2>Terms for Submission</h2></th>
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
		</td>
  </tr>
     <tr>
     <form method="post" action="disclaimer.cfm">
     <input type="hidden" name="submitSignature" />
     	<td>Signature: <input type="text" name="signature" size=35 /><br />
        <em>(typing your name above is considered the same as a physical signature)</em><br /><br />
        <input name="Submit" type="image" src="/images/buttons/Next.png" border="0"> </td>
        </form>
     </tr>
 </table>

</body>
</html>