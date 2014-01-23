<cfset client.companyid = 1>
<cfif client.companyid eq 1>
	<cfset companycolor='0054A0'>
<cfelseif client.companyid eq 2>
	<cfset companycolor='0054A0'>
 <cfelseif client.companyid eq 3>
	<cfset companycolor='0054A0'>
 <cfelseif client.companyid eq 4>
	<cfset companycolor='0054A0'>
 <cfelseif client.companyid eq 10>
	<cfset companycolor='98012E'>
<cfelseif client.companyid eq 11>
	<cfset companycolor='00b3d9'>
<cfelse>
	<cfset companycolor='0054A0'> 
</cfif>
<style type="text/css">
<!--
table,tr,td					{font-family:Arial, Helvetica, sans-serif;}
.smlink         		{font-size: 10px;}
.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #ffffff;}
.sideborders				{ border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6; background: #ffffff;}
.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionSubHead			{font-size:11px;font-weight:bold;}
.thin-border{ border: 4px solid ##000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
-->
</style>
<cfoutput>
<div class="thin-border">
<table background="http://www.iseusa.com/images/email_textured_background.png" width=600>
	<Tr >
    
     	<td width=94><img src="http://www.iseusa.com/images/logos/#client.companyid#_header_logo.png"></td>
    <cfif client.companyid lte 5>
        <td><strong><font size=+2>INTERNATIONAL <font color="#companycolor#">STUDENT EXCHANGE</font></font></strong></td>
     <cfelse>
     	<td><strong><font size=+2>#client.companyname#</font></font></strong></td>
     </cfif>
     </Tr>	
   
     	<td colspan=2><img src="http://www.iseusa.com/images/logos/#client.companyid#_px.png" height=12 width=100%></td>
	</tr>
</table>

<Table width=600>
	<Tr>
    	<td>
 </cfoutput>