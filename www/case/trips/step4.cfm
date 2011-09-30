<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Tour FAQs</title>
<link href="../css/maincss.css" rel="stylesheet" type="text/css" />
 <script type="text/javascript">
//<![CDATA[
	function ShowHide(){
	$("#slidingDiv").animate({"height": "toggle"}, { duration: 1000 });
	}
//]]>
</script>
<Cfset verified = 0>
<cfsilent>
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    <cfparam name="FORM.otherTravelers" default="">
    <cfparam name="FORM.nationality" default="">
    <cfparam name="FORM.stunationality" default="">
    <cfparam name="FORM.person1" default="">
    <cfparam name="FORM.person2" default="">
    <cfparam name="FORM.person3" default="">
</cfsilent>

<Cfquery name="HostInfo" datasource="mysql">
select h.familylastname, h.email, h.address, h.address2, h.city, h.state, h.zip, h.email, h.phone
from smg_hosts h
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.verifiedHost#"> 
</cfquery>
<Cfquery name="studentInfo" datasource="mysql">
select s.firstname, s.familylastname, s.email, s.uniqueid, s.med_allergies, s.other_allergies, sch.schoolname, sch.address, sch.address2, sch.city, sch.state, sch.zip, sch.principal, sch.phone, sch.phone_ext,
u.firstname as repfirst, u.lastname as replast, u.email as repemail, u.phone as repphone
from smg_students s
left join smg_schools sch on sch.schoolid = s.schoolid
left join smg_users u on u.userid = s.arearepid
where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.verifiedStudent#"> 
</cfquery>

</head>
<Cfif IsDefined('url.c')>
	     <Cfset form.stunationality = client.stunationality>
         <cfset form.person1 = client.person1>
         <cfset form.person2 = client.person2>
         <cfset form.person3 = client.person3>
         <cfset form.med = client.medical>
         <cfset form.nationality = client.nationality>
</Cfif>
<cfif isDefined('form.submitPref')>
	 <cfscript>
                // roommates
              if ( NOT LEN(TRIM(FORM.nationality)) ) {
                            // Get all the missing items in a list
                            SESSION.formErrors.Add("Please answer the question: Would you prefer roomates of the same nationality as yourself?");
                        }	
                // nationality
              if ( NOT LEN(TRIM(FORM.stunationality)) ) {
                            // Get all the missing items in a list
                            SESSION.formErrors.Add("Please answer the question: What is your nationality?");
                        }	
     </cfscript>
        <cfif NOT SESSION.formErrors.length()>
         <Cfset client.stunationality = form.stunationality>
         <cfset client.person1 = form.person1>
         <cfset client.person2 = form.person2>
         <cfset client.person3 = form.person3>
         <cfset client.medical = form.med>
         <cfset client.nationality = form.nationality>
        	<cflocation url="step5.cfm">
        </cfif>
 </cfif>
<style type="text/css">
<!--
a:link {
	color: #003;
	text-decoration: none;
}
a:visited {
	color: #003;
	text-decoration: none;
}
a:hover {
	color: #003;
	text-decoration: none;
}
a:active {
	color: #003;
	text-decoration: none;
}
a {
	font-weight: bold;
}
.lightGreen {
	color: #000;
	background-repeat: repeat;
	text-align: center;
	background-color: #a5aac7;
}
h1 {
	font-family: Arial, Helvetica, sans-serif;
	border-bottom-width: medium;
	border-bottom-style: double;
	border-bottom-color: #999;
}
-->
</style></head>

<body>

<div id="wrapper">
<cfinclude template="../includes/header.cfm">
<div id="mainbody">
<cfinclude template="../includes/leftsidebar.cfm">
<div id="trip">
   
   <cfform method="post" action="step4.cfm">
<input type="hidden" name="submitPref" /> 
<cfoutput>
           <h1>Preferences</h1>
          
           	<gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
		
				<em>Couple of things to help make your trip better</em>
          <Table width=100% cellspacing=0 cellpadding=2 class="border">
          	<tr>
            	<td colspan=2><h3>Would you prefer roommates <br /> &nbsp;&nbsp;&nbsp;of the same nationality as yourself?</h3></td>
    		
            	<td> <h3><input type=radio name="nationality"  value='Same' <cfif form.nationality is 'Same'>checked</cfif> /> Same 
                <input type=radio name="nationality" value='Different' <cfif form.nationality is 'Different'>checked</cfif> /> Different 
                <input type=radio name="nationality" value='No Preference' <cfif form.nationality is 'No Preference'>checked</cfif>/> No Preference</h3></td>
                
            </tr>
             <Tr bgcolor="##deeaf3">
          	 <td colspan=3><h3>What is your nationality? &nbsp;&nbsp;<cfinput type="text" name="stunationality" size=30 value="#FORM.stunationality#"/></h3></td>
             </Tr>
        	 <T>
          	 <td colspan=3><h3>Anyone in particular?
             &nbsp;&nbsp; ##1<input type="Text" name="person1" size=17 value="#form.person1#"/> ##2<input type="text" name="person2" value="#form.person2#" size=17/> ##3<input type="text" name="person3" value="#form.person3#" size=17/></h3></td>
             </Tr>
             <Tr r bgcolor="##deeaf3">
          	 <td colspan=3><h3>Medical Information: <font size=-2>List allergies, medical conditions or limitations (vegitarian, etc), and any prescription medications.<br />
             &nbsp;&nbsp;&nbsp; If you are currently being treated for a medical condition, include your physicians name and phone number.  <em><strong>Please remember you &nbsp;&nbsp;&nbsp;must cary your card while on tour.</strong><em></h3>
             <textarea cols=80 rows=5 name="med"><Cfif studentInfo.med_allergies is not ''>Medical Allergies: #studentInfo.med_allergies#;</Cfif><cfif studentInfo.other_Allergies is not ''>Other Allergies: #studentInfo.other_allergies#</cfif></textarea></td>
             </Tr>
          
          
          </Table>
</cfoutput>
 <br>
           <div align="Center"><input type="image" src="../images/buttons/next.png" /></div>
</cfform>

    <!-- trips --></div>
    <!-- mainbody --> </div>
    <div class="clearfix"></div>
<cfinclude template="../includes/footer.cfm">
<!-- wrapper --></div>


</body>
</html>
