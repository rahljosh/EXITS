<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Step 1 - Find Account</title>

<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<link href="../css/trips.css" rel="stylesheet" type="text/css" />
 <link rel="stylesheet" media="all" type="text/css"href="../css/baseStyle.css" />
</head>

<body class="oneColFixCtr">
<cfsilent>
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    <!----Set Default Properties---->
    <Cfparam name="FORM.studentid" default="">
    <Cfparam name="FORM.studentLast" default="">
    <cfparam name="FORM.dob" default="">
    <cfparam name="FORM.hostLast" default="">
    <cfparam name="FORM.hostZip" default="">
    <cfparam name="FORM.hostCity" default="">
    <cfparam name="FORM.hostEmail" default="">
    <cfparam name="CLIENT.verifiedStudent" default="">
    <cfparam name="CLIENT.verifiedHost" default="">
</cfsilent>

<Cfif isDefined('FORM.process')>
 <Cfset primaryCount = 0>
 <cfset secondaryCount = 0>
 <Cfset verified = 0>
 <!----Check number of primary items using---->
 <Cfif form.studentid is not ''>
 	<Cfset primaryCount = #primaryCount# + 1>
 </Cfif>
 <Cfif form.studentLast is not ''>
 	<Cfset primaryCount = #primaryCount# + 1>
 </Cfif>
 <Cfif form.dob is not ''>
 	<Cfset primaryCount = #primaryCount# + 1>
 </Cfif>
 
 <Cfif form.hostLast is not ''>
 	<Cfset secondaryCount = #secondaryCount# + 1>
 </Cfif>
 <Cfif form.hostZip is not ''>
 	<Cfset secondaryCount = #secondaryCount# + 1>
 </Cfif>
 <Cfif form.hostCity is not ''>
 	<Cfset secondaryCount = #secondaryCount# + 1>
 </Cfif>
 <Cfif form.hostEmail is not ''>
 	<Cfset secondaryCount = #secondaryCount# + 1>
 </Cfif> 
 <cfoutput>

 </cfoutput>
  <cfscript>
    		// Primary
            if (primaryCount lt 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You must specify at least two (2) piece of information from the Primary Information section.");
            }			
    		// Secondary
            if (secondaryCount lt 2 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You must specify at least two (2) piece of information from the Secondary Information section.");
            }			

			
  </cfscript>
    <cfif NOT SESSION.formErrors.length()>
    <!----Check to see if there is a student based on the info.---->
        <Cfquery name="checkStudent" datasource="mysql">
        select studentid
        from smg_students
        where 1 = 1 
            <cfif form.studentid is not ''>
            AND studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.studentid#">
            </cfif>
            <cfif form.studentLast is not ''>
            AND familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(studentLast)#%">
            </cfif>
            <cfif form.dob is not ''>
            AND  dob = <cfqueryparam cfsqltype="cf_sql_date" value="#form.dob#"> 
            </cfif>
        </Cfquery>
		<Cfif checkStudent.recordcount neq 0>
                
                <!-----Check to see if there is host associted with this student---->
                    <cfquery name="checkHost" datasource="mysql">
                        select smg_hosts.hostid 
                        from smg_hosts
                        
                        where 1 =1
                            <cfif form.hostLast is not ''>
                             AND smg_hosts.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.hostLast)#%">
                            </cfif>
                            <cfif form.hostCity is not ''>
                             AND smg_hosts.city= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hostCity#">
                            </cfif>
                            <cfif form.hostZip is not ''>
                             AND smg_hosts.zip= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hostZip#">
                            </cfif>
                            <cfif form.hostEmail is not ''>
                            AND smg_hosts.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hostEmail#">
                            </cfif>            
                        
                    </cfquery>
                   
                    <cfloop query="checkHost">
                        <Cfquery name="checkCombined" datasource="mysql">
                        select hostid, studentid
                        from smg_students
                        where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkStudent.studentid#">
                        AND hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostid#">
                        </cfquery>
                        
                            <cfif checkCombined.recordcount eq 1>
                                <Cfset client.verifiedStudent = #checkCombined.studentid#>
                                <cfset client.verifiedHost = #checkCombined.hostid#>
                                    <Cflocation url="step2.cfm" addtoken="no">
                            </cfif>
                          
                    </cfloop>

        </Cfif>
    
        	<cfscript>
    		// No combined
            if (1 eq 1 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("No records were found based on the information  you provided.  Please verify the information you have submitted.");
            }			
			</cfscript>

    

       
	</cfif>
</Cfif>

<div id="topBar">
<cfinclude template="../topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="../images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="titleTrips.cfm"><!-- end title --></div>
<div class="tabsBar">
  <cfinclude template="../tabsBar.cfm">
  <!-- end tabsBar --></div>
<div id="mainContent">
<div id="subPages">
      <div class="whtTop"></div>
  <div class="whtMiddletours2">
        <div class="tripsTours">


  <h2 align="Center">Let's get you registered.</h2>
  <cfoutput>    
  
         <h2>Account Lookup</h2>
        <span class="yellowHighlight">Please provide ALL Primary Information and 2 pieces of Secondary Information.</span><br /><br />
     	<!--- Form Errors --->
    	<gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />

          <Cfform method="post" action="step1.cfm">
       
          <input name="process" type="hidden" />
        
		  <Table width=100% cellspacing=0 cellpadding=8 class="border">
     		<tr  >
            	<th colspan=2 align="center"><h2>Primary Information</h2>
                 <span class="yellowHighlight">You must provide all three pieces of the following information.</span></th>
            </tr>
          	<Tr bgcolor="##deeaf3">
            	<td><strong>Student ID Number</strong> </td>
                <td>
                
                <cfinput type="text" name="studentid" size=20 value="#form.studentid#"><br /><em></em>
              
                </td>
            </Tr>
          	<Tr>
            	<td><strong>Student Last Name</strong> </td>
                <td>
                
                <cfinput type="text" name="studentLast" size=20 value="#form.studentLast#"><br /><em></em>
               
                </td>
            </Tr>
            <tr  bgcolor="##deeaf3"  >
           		 <Td><strong>Student Date of Birth</strong> </Td>
                 <td>
                
                 <cfinput type="text" name="dob"  size=20 value="#dateFormat(form.dob, 'mm/dd/yyyy')#" mask="99/99/9999"> MM/DD/YYYY
                 
                 </td>
            </tr>
           <tr>
            	<th colspan=2 align="center"><h2>Secondary Information</h2>
                <span class="yellowHighlight">You only need to provide 2 pieces of the following information.</span></th>
            </tr>
                        <tr bgcolor="##deeaf3">
           		 <Td><strong>Host Last Name</strong> </Td>
                 <td>
           
                 <cfinput type="text" name="hostLast" value="#form.hostLast#" size=20>
            
                 </td>
            </tr>
            <tr>
           		 <Td><strong>Host Email</strong> </Td>
                 <td>
                
                 <cfinput type="text" name="hostEmail"  size=20 value="#form.hostEmail#">
                
                 </td>
            </tr>
            <tr bgcolor="##deeaf3">
           	 <Td><strong>Host City</strong> </Td>
                 <td>

                 <cfinput type="text" name="hostCity"  size=20 value="#form.hostCity#">
                 </td>

            </tr>
            <tr>
            	 <Td><strong>Host Zip/Postal Code</strong> </Td>
                 <td>
           
                 <cfinput type="text" name="hostZip" value="#form.hostZip#" size=20>
            
                 </td>
            </tr>
            <Tr>
            	<td colspan=2><div align="Center"><input type="image" src="../images/buttons/Next.png" width="89" height="33" /></div></td>
          </Table>
      </Cfform>
</cfoutput>
</div>
      
      <div id="main" class="clearfix"></div>
      <!-- end whtMiddle --></div>
      <div class="whtBottom"></div>
      <!-- end subpages --></div>
    <!-- end mainContent --></div>
<!-- end container --></div>
<div id="main" class="clearfix"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="../bottomLinks.cfm">
<!-- end footer --></div>
</body>
</html>
