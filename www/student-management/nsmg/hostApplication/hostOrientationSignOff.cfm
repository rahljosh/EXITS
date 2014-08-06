
<Cfquery name="hostInfo" datasource="#application.dsn#">
select smg_hosts.hostid, smg_hosts.fatherFirstName, smg_hosts.motherFirstName, smg_hosts.familyLastName,  
smg_hosts.fatherLastName, smg_hosts.motherLastName, max(history.facilitatorDateStatus) as dateApproved
from smg_hosts
left join smg_host_app_history history on history.hostid = smg_hosts.hostid
where smg_hosts.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.hostid#">
</cfquery>

<Cfquery name="seasonName" datasource="#application.dsn#">
select season
from smg_seasons
where seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.seasonid#">
</Cfquery>


<cfdocument format="PDF" margintop=".45" marginbottom=".25" marginright=".25" marginleft=".25" backgroundvisible="yes" overwrite="no" fontembed="yes" bookmark="false" localurl="no" saveasname="Host-Family-Orientation-Sign-Off.pdf" >
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Host Orientation Sign Off</title>
</head>

<body style="font-family: sans-serif; font-size: 40px; line-height: auto;">
<div style="width: 2500px; height: 3235px; border: 1px solid #fff; display: block;">
<div style="background-image:url(https://ise.exitsapplication.com/nsmg/pics/<cfif ListFind(#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#, #client.companyid#)>1-form-header.png<cfelse><cfoutput>#client.companyid#</cfoutput>-form-header.jpg</cfif>); width: 2550px; height: 500px; display: block; background-repeat: no-repeat; background-position: center;" >
<div align="center"><h1 style="padding-top: 180px;">Host Family Orientation Sign-Off</h1></div>
</div>
<div style="height: 50px; background-color: #1F4A79; width: 100%; display: block; margin-bottom: 50px;"></div>
<div>
<table width="95%" style="font-size: 35px;" border="0" cellpadding="10" align="center"  >
  <tr>
    <td colspan="2" style="border: 1px solid #ccc;"><h2>Host Family: <cfoutput>#hostInfo.familyLastName#</cfoutput></h2></td>
    <td width="21%" style="border: 1px solid #ccc;"><h2>ID# <cfoutput>#hostInfo.hostID#</cfoutput></h2></td>
  </tr>
  <tr>
    <td width="55%" style="border: 1px solid #ccc;" ><h2>Host Application Approved by Compliance:</h2></td>
    <td width="30%" style="border: 1px solid #ccc;"><h2><cfoutput>#DateFormat(hostInfo.dateApproved, 'mmm. d, yyyy')#</cfoutput></h2></td>
    <td rowspan="2" align="left" valign="top" style="border: 1px solid #ccc;"><h2>Season:</h2>
    <div align="center"><strong><cfoutput>#seasonName.season#</cfoutput></strong></div>
    </td>
  </tr>
  <tr>
    <td style="border: 1px solid #ccc;"><h2>Date of Orientation (must be after <cfoutput>#DateFormat(hostInfo.dateApproved, 'mmm. d, yyyy')#</cfoutput>):</h2></td>
    <td style="border: 1px solid #ccc;">&nbsp;</td>
    </tr>
</table>
</div>
<div style="width: 95%; margin: 50px auto; font-size: 45px;">
<p>By signing this form you are verifying that the rules of the exchange program have been explained to you during your
host family orientation and you have received a copy of the 
<cfif CLIENT.companyid eq 10> CASE <cfif CLIENT.companyid eq 14> ESI <cfelse> ISE </cfif>host family rules, the US DOS Secondary School
Program regulations and the DOS Host Family Welcome letter.</p>
<p>All policies are detailed in the ISE Host Family rules document and specific highlights of the program rules include:</p>
<ul><li style="margin-bottom: 30px;">Exchange students are not allowed to possess or consume alcoholic beverages, illegal drugs or prescription
drugs that have not been prescribed to them by a physician.</li>
<li style="margin-bottom: 30px;">Exchange students may not operate a motorized vehicle while on the exchange program except when
accompanied by a licensed professional driving instructor. Students may never operate a family vehicle.</li>
<li style="margin-bottom: 30px;">Exchange students may not travel overnight without host parent accompaniment unless the trip is part of an
ISE, school or other trip authorized in advance by ISE.</li>
<li style="margin-bottom: 30px;">Exchange student's finances should be kept entirely separate from the host family and host family members
may not lend money to, nor borrow money from exchange students. The host family may not have access to
an exchange student's bank card, credit card or bank PIN.</li>
<li style="margin-bottom: 30px;">Visits from natural family members are prohibited.</li>
<li style="margin-bottom: 30px;">Exchange students must have their own permanent bed and may share a room with only one other person of
the same gender.</li>
<li style="margin-bottom: 30px;">Exchange students may not be deprived of reasonable access to their phone.</li>
<li style="margin-bottom: 30px;">Exchange students may never be threatened with being sent home. Only ISE headquarters staff can decide
to terminate a student's program.</li></ul>
<p>*I agree to immediately notify my Area Representative of any violation of the program rules.</p>
</div>
<table width="95%" border="0" cellpadding="10" align="center" style="font-size: 35px;">
  <tr>
    <td width="67%" align="left" valign="top" style="border: 1px solid #ccc;"><h2>Primary Host Parent Signature:<br> <br> &nbsp;</h2></td>
    <td width="33%" align="left" valign="top" style="border: 1px solid #ccc;"><h2>Date:</h2></td>
  </tr>
  <tr>
    <td align="left" valign="middle" style="border: 1px solid #ccc;"><h2>Print Name:  <cfoutput>#hostInfo.fatherFirstName# #hostInfo.fatherLastName#</cfoutput></h2></td>
    <td align="left" valign="top" >&nbsp;</td>
  </tr>
  <tr>
    <td align="left" valign="top" style="border: 1px solid #ccc;"><h2>Other Host Parent Signature:<br>  <br> &nbsp;</h2></td>
    <td align="left" valign="top" style="border: 1px solid #ccc;"><h2>Date:</h2></td>
  </tr>
  <tr>
    <td align="left" valign="middle" style="border: 1px solid #ccc;"><h2>Print Name: <cfoutput>#hostInfo.motherFirstName# #hostInfo.motherLastName#</cfoutput></h2></td>
    <td align="left" valign="top" >&nbsp;</td>
  </tr>
</table>
<div style="height: 50px; background-color: #1F4A79; width: 100%; display: block; margin-top: 50px;"></div>

</div>
</body>
</html>
</cfdocument>