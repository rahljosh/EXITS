<cfinclude template="includes/page_top.cfm">
<cfif isDefined('form.process')>
	<cfif form.religious_affiliation gt 0 and not isDefined('form.church_activity')>
    	<cfset errorMsg = 'You have indicated a religious belief but have not answered the question: How often do you go to your religious estableshment?'>
    <Cfelseif (form.church_activity eq 4 or form.church_activity eq 3 or form.church_activity eq 2) and not isDefined('form.stu_attend')>
        <cfset errorMsg = 'You have indicated that you go attend religious services, but did not answer: Would you expect your exchange student to attend services with your family?'>
             
    <cfelse>    
       <cfquery datasource="mysql">
        update smg_hosts
            set religious_participation = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.church_Activity#">,
               <cfif isDefined('form.stu_Attend')> churchfam =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stu_attend#">, </cfif>
                churchtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stu_trans#">,
                religion =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.religious_affiliation#">
            where hostid = #client.hostid#
        </cfquery>
     <cfif form.church_activity gt 1>
          <Cflocation url="index.cfm?page=churchInfo" addtoken="no">
     <cfelse>
     	  <cflocation url="index.cfm?page=communityProfile" addtoken="no">
     </cfif>
    </cfif>
	<cfif isDefined("errorMsg")>
			<script language="JavaScript">
                alert('<cfoutput>#errorMsg#</cfoutput>');
            </script>
        </cfif>        
</cfif>

<cfquery name="religion" datasource="MySQL">
select *
from smg_religions
</cfquery>
<cfquery name="get_host_religion" datasource="MySQL">
select religion, religious_participation, churchfam,  churchtrans
from smg_hosts
where hostid = #client.hostid#
</cfquery>

<cfif get_host_religion.religion is ''>
	<cfparam name="form.religious_affiliation" default="">
<cfelse>
	<cfparam name="form.religious_affiliation" default="#get_host_religion.religion#">
</cfif>
<cfif get_host_religion.churchtrans is ''>
	<cfparam name="form.stu_trans" default="">
<cfelse>
	<cfparam name="form.stu_trans" default="#get_host_religion.churchtrans#">
</cfif>
<cfif get_host_religion.religious_participation is ''>
	<cfparam name="form.church_activity" default="">
<cfelse>
	<cfparam name="form.church_activity" default="#get_host_religion.religious_participation#">
</cfif>
<cfif get_host_religion.churchfam is ''>
	<cfparam name="form.stu_attend" default="">
<cfelse>
	<cfparam name="form.stu_attend" default="#get_host_religion.churchfam#">
</cfif>




<cfform action="index.cfm?page=religionPref">
<cfinput type="hidden" name="process"> 
<h2>Religious Preference</h2>
What religions beliefs do you follow?
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<tr bgcolor="#deeaf3">
    	<td>
 <select name="religious_affiliation" onChange="ShowHide();" >
			<option value="00" selected>Non-Religious
			<cfoutput query="religion">
			<cfif #form.religious_affiliation# is #religionid#><option value=#religionid# selected>#religionname#<cfelse><option value=#religionid#>#religionname#</cfif>
			</cfoutput>
			<option value=999999>Other</option>
			</select>
	</td>
   </tr>
</table>
<cfif form.religious_Affiliation eq 0 or form.religious_affiliation eq 00>
<div id="slidingDiv" display:"none">
</cfif>

<h2>Religious Attendance</h2>
How often do you go to your religious establishment?
<table width=100% cellspacing=0 cellpadding=2 class="border">

    <tr bgcolor="#deeaf3">
    	<td colspan=2><cfinput type="radio"
         onclick="document.getElementById('showname').style.display='table-row';"
         name="church_Activity" 
         checked='#get_host_religion.religious_participation eq 4#'
         value="4" 
         
        > Active (2+ times a week)</td>
    </tr>
    <tr >
    	<Td colspan=2>
		<cfinput type="radio" 
        name="church_Activity" 
        onclick="document.getElementById('showname').style.display='table-row';"
        value="3" 
        checked='#get_host_religion.religious_participation eq 3#'
       >Average (1-2x a week) 
</td>
    </tr>
    <tr bgcolor="#deeaf3" >
    	<Td colspan=2>
		<cfinput type="radio" 
        onclick="document.getElementById('showname').style.display='table-row';"
        name="church_Activity" 
        value="2" 
        checked='#get_host_religion.religious_participation eq 2#'
        >Little Interest (occasionally)
</td>
    </tr>
    <tr >
    	<Td colspan=2>
		<cfinput type="radio" 
        name="church_Activity" 
        value="1" 
        onclick="document.getElementById('showname').style.display='none';"
        checked='#get_host_religion.religious_participation eq 1#'
        >Inactive (Never attend)
        </td>
    </tr>
    <tr bgcolor="#deeaf3" >
    	<Td colspan=2>
		<cfinput type="radio" 
        name="church_Activity" 
        onclick="document.getElementById('showname').style.display='none';"
        value="0" 
        checked='#get_host_religion.religious_participation eq 0#'
        >No Interest
		</td>
    </tr>
        <tr  colspan=2 id="showname" <cfif form.church_Activity lte 1> style="display: none;"</cfif> >
    	<td>Would you expect your exchange student to attend services with your family? </td>
        <td> <label>
            <cfinput type="radio" name="stu_attend" value="1" checked='#get_host_religion.churchfam eq 1#'
              />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="stu_attend" value="0" checked='#get_host_religion.churchfam eq 0#'
             />
            No
            </label>
		</td>
      </tr>
 </Table>
 <cfif form.religious_Affiliation eq 0 or form.religious_affiliation eq 00>
</div>    
</cfif>
<h2>Transportation</h2>
<table width=100% cellspacing=0 cellpadding=2 class="border">

      <tr bgcolor="#deeaf3">
    	<td>Would you provide transportation to the student's religious services<Br /> if they are different from your own? </td>
        <td> <label>
            <cfinput type="radio" name="stu_trans" value="1" checked='#get_host_religion.churchtrans eq 1#'
             required="yes" message="Please answer: Would you provide transportation to the student's religious services if they are different from your own?" 
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="stu_trans" value="0" checked='#get_host_religion.churchtrans eq 0#'
            required="yes" message="Please answer: Would you provide transportation to the student's religious services if they are different from your own?" />
            No
            </label>
		</td>
      </tr>
	

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
</cfform>


