<!--- ------------------------------------------------------------------------- ----
	
	File:		disclaimer.cfm
	Author:		Marcus Melo
	Date:		December 7, 2012
	Desc:		Disclaimer / Submission Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
    
    <!--- PARAM FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.signature" default="">

    <!--- Process Form Submission --->
    <cfif VAL(FORM.submitted)>
    
		<cfscript>
			// Data Validation
			
            // First Name
            if ( NOT LEN(TRIM(FORM.signature)) ) {
                SESSION.formErrors.Add("Please type your name in the signature box.");
            }			
		</cfscript>

		<!--- No Errors Found --->
		<cfif NOT SESSION.formErrors.length()>
        
			<cfscript>
                FORM.report_mode = 'print';
                FORM.pdf = 1;
            </cfscript>
        
            <cfdocument format="PDF" filename="#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS#hostApplicationTerms.pdf" overwrite="yes">
                <cfoutput>
                    <table align="center" width="80%" cellpadding="4">
                        <tr>
                            <th align="left"><h2>Terms for Submission</h2></th>
                        </tr>
                        <tr>
                            <td><hr width="70%" /></td>
                        </tr>
                        <tr>
                            <td>
                                <p>
                                    Applicants and their families certify that all information submitted in the Host Family Application - including the application, 
                                    the Host Family Letter, any supplements, and any other supporting materials - is honestly presented and accurate; and that these documents 
                                    will become the property of the exchange organization and will not be returned.         
                                </p>        
                                
                                <p>
                                    Applicants and their families understand that the signature below constitutes a willingness of all members of the household to host an Exchange Student 
                                    through the exchange organization and comply with the exchange organization and the Department of State Regulations. 
                                    Applicants also agree, as per Department of State mandate, to notify the exchange organization if the composition of their household changes and if additional 
                                    criminal background checks need to be conducted.
                                </p>
                                
                                <p>
                                    Applicants and their families understand and acknowledge that by signing this application the exchange organization maintains jurisdiction over all aspects 
                                    of the student exchange program.  In the event of any problem between the student and the American host family, the exchange organization reserves the right to 
                                    remove the student at any time to resolve the situation.
                                </p>        
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Signature: #FORM.signature#<br />
                                <em>(typing your name above is considered the same as a physical signature)</em> <br /><br />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Electronically Signed<br />
                                #FORM.signature#<br />
                                #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<br />
                                IP: #cgi.REMOTE_ADDR# 
                            </td>
                        </tr>
                    </table>
                </cfoutput>                
            </cfdocument>  
             
            <cfquery datasource="#APPLICATION.DSN.Source#">
                INSERT INTO
                    smg_documents 
                (
                    hostID, 
                    userID, 
                    seasonID,
                    userType,
                    fileName, 
                    type, 
                    dateFiled, 
                    filePath, 
                    description, 
                    shortDesc 
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#">,                                
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Host Family">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="hostApplicationTerms.pdf">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="pdf">, 
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Terms for Submission of Host Application">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Host Application Terms">
                )
            </cfquery> 
            
            <cfscript>
				// Set Page Message
				SESSION.pageMessages.Add("Host Family Application Succesfully Submited");
				SESSION.pageMessages.Add("This window should close shortly");
			</cfscript>
        
        </cfif>
        
    </cfif>        
    
</cfsilent>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><cfoutput>#SESSION.COMPANY.pageTitle#</cfoutput></title>
<link href="linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="linked/chosen/chosen.css" />
<link rel="stylesheet" href="linked/css/wiki.css" />
<link rel="stylesheet" href="linked/css/colorbox.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="linked/chosen/chosen.jquery.js" type="text/javascript"></script>
<script src="linked/js/jquery.colorbox-min.js"></script>
</head>

<cfoutput>

	<!--- No Errors Found --->
    <cfif FORM.submitted AND NOT SESSION.formErrors.length()>

        <script type="text/javascript">
            // Close Window After 1.5 Seconds
            setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
        </script>
        
    </cfif>

    <div id="subPages">
    
        <div class="whtTop"></div>
        
        <div class="whtMiddle">
        
            <div class="hostApp">
            
                <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
                    <input type="hidden" name="submitted" value="1" />
                    
                    <h2 align="center">Terms for Submission</h2>
                    
                    <hr width="90%" />
                
                    <!--- Page Messages --->
                    <gui:displayPageMessages 
                        pageMessages="#SESSION.pageMessages.GetCollection()#"
                        messageType="section"
                        width="90%"
                        />

                    <!--- Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="section"
                        width="90%"
                        />
                        
                    <table align="center" width="100%" cellpadding="4">
                        <tr>
                            <td>
                                <p>
                                    Applicants and their families certify that all information submitted in the Host Family Application - including the application, 
                                    the Host Family Letter, any supplements, and any other supporting materials - is honestly presented and accurate; and that these documents 
                                    will become the property of the exchange organization and will not be returned.         
                                </p>        
                                
                                <p>
                                    Applicants and their families understand that the signature below constitutes a willingness of all members of the household to host an Exchange Student 
                                    through the exchange organization and comply with the exchange organization and the Department of State Regulations. 
                                    Applicants also agree, as per Department of State mandate, to notify the exchange organization if the composition of their household changes and if additional 
                                    criminal background checks need to be conducted.
                                </p>
                                
                                <p>
                                    Applicants and their families understand and acknowledge that by signing this application the exchange organization maintains jurisdiction over all aspects 
                                    of the student exchange program.  In the event of any problem between the student and the American host family, the exchange organization reserves the right to 
                                    remove the student at any time to resolve the situation.
                                </p>        
                            </td>
                        </tr>
                        <tr>                
                            <td align="center">
                                Signature: <input type="text" name="signature" class="xLargeField" /> <br />
                                <em>(typing your name above is considered the same as a physical signature)</em>
                            </td>            
                        </tr>
                        <tr>                
                            <td align="center">
                                <input name="Submit" type="image" src="images/buttons/Next.png" border="0"> 
                            </td>            
                        </tr>
                    </table>
                    
                </form>
                    
            </div><!-- hostApp -->
            
            <div id="main" class="clearfix"></div>
            
        </div><!-- end whtMiddle -->
        
        <div class="whtBottom"></div>
        
    </div><!-- end subPages -->
    
</cfoutput>

</body>
</html>