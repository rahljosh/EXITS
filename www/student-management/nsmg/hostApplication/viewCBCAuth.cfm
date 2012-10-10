
<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<link href="http://ise.111cooper.com/hostApp/css/hostApp.css" rel="stylesheet" type="text/css" />
<link href="http://ise.exitsapplication.com/nsmg/linked/css/baseStyle.css" rel="stylesheet" type="text/css" />

<cfinclude template="approveDenyInclude.cfm">

<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        />
<h2>CBC Authorizations<br /></h2>
<hr width=80% align="center" height=1px />
<cfdirectory directory="uploadedfiles/hosts/#client.hostid#" name="cbcAuthForms">


<!----CBC Shit---->



<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<cfparam name="submitForm" default=0>
<cfquery name="qHostParentsMembers" datasource="mysql">
select h.fatherfirstname, h.fatherdob, h.fatherlastname, h.motherfirstname, h.motherlastname, h.motherdob, h.fatherssn, h.motherssn, h.companyid, h.regionid, h.email
from smg_hosts h
where h.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
</cfquery>

<cfquery name="qHostParentsCBC" datasource="mysql">
select * 
from smg_documents
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
</cfquery>

<cfquery name="checkFatherCBC" dbtype="query">
select *
from qHostParentsCBC
where shortDesc = 'Father CBC Auth'

</cfquery>

<cfquery name="checkMotherCBC" dbtype="query">
select *
from qHostParentsCBC
where shortDesc = 'Mother CBC Auth'
</cfquery>
    
    	
<cfquery name="qHostFamilyMembers" datasource="mysql">
select k.name, k.lastname, k.birthdate, k.cbc_form_received, k.childid, k.membertype, k.ssn, k.liveathome
from smg_host_children k
where k.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#"> 
</cfquery>
<cfquery name="qActiveSeasons" datasource="mysql">
select s.seasonid, s.season 
from smg_seasons s
where active = 1
</cfquery>
 
<h2>Criminal Background Check</h2>
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />


<cfform method="post" action="viewCBCAuth.cfm?itemID=#url.itemID#&usertype=#url.usertype#">

<cfoutput>


<h3>Family Members</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr>
   	<Th align="left">Name</Th><Th align="left">Relation</th><Th align="left">Date of Birth</th><Th align="left">Age</th><Th align="left">Authorization</th>
    </Tr>
   <Cfif qHostParentsMembers.recordcount eq 0>
    <tr>
    	<td>Currently, no family members require a backgroundcheck.</td>
    </tr>
    <cfelse>
    <Cfloop query="qHostParentsMembers">
    <cfif fatherfirstname is not ''>
        <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
            <Td><p class=p_uppercase>#fatherfirstname# #fatherlastname#</Td>
            <Td><p class=p_uppercase>Host Father</Td>
            <Td><cfif fatherdob is ''>N/A<cfelse>#DateFormat(fatherdob, 'mmm d, yyyy')#</cfif></Td>
            <td><cfif fatherdob is ''>N/A<cfelse>#DateDiff('yyyy',fatherdob,now())#</cfif></td> 
             <input type="hidden" value="#fatherfirstname#" name="fatherfirstname" />
            <td>
            
          	<a href="../uploadedfiles/#checkFatherCBC.filePath##checkFatherCBC.fileName#">View CBC Authoriaztion</a>
            
            </td>
      </tr>
    </cfif>
    <cfif motherfirstname is not ''>
        <tr >
            <Td><p class=p_uppercase>#motherfirstname# #motherlastname#</Td>
            <Td><p class=p_uppercase>Host Mother</Td>
            <Td><cfif motherdob is ''>N/A<cfelse>#DateFormat(motherdob, 'mmm d, yyyy')#</cfif></Td>
            <td><cfif motherdob is ''>N/A<cfelse>#DateDiff('yyyy',motherdob,now())#</cfif></td> 
           <input type="hidden" value="#motherfirstname#" name="motherfirstname" />
           
            <td>
            
            <a href="../uploadedfiles/#checkMotherCBC.filePath##checkMotherCBC.fileName#">View CBC Authoriaztion</a>
            
            	
            </td>

        </tr>
    </cfif>
    </Cfloop>
    <tr>
    	<Td colspan=7><hr width=60% align="center"></Td>
    </tr>
    <cfset famMembersList =''>
    <Cfloop query="qHostFamilyMembers">
     <cfquery name="cbcInfo" datasource="mysql">
            select *
            from smg_documents
            where userid = #qHostFamilyMembers.childID#
            </cfquery>
    <Cfif #DateDiff('yyyy',birthdate,now())# gte 18>
		<cfset famMembersList = #ListAppend(famMembersList,#qHostFamilyMembers.childid#)#>
	</Cfif>
        <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
            <Td><p class=p_uppercase>#name# #lastname#</Td>
            <td><p class=p_uppercase>#membertype#</td>
            <Td>#DateFormat(birthdate, 'mmm d, yyyy')#</Td>
            <td>#DateDiff('yyyy',birthdate,now())#</td> 
			<Cfif #DateDiff('yyyy',birthdate,now())# gte 18 and liveathome is 'yes'>
                
                <td>
                <input type="hidden" name="#qHostFamilyMembers.childid#_name" value="#name#" />
              <Cfif ssn is not ''>
              	<a href="http://ise.exitsapplication.com/nsmg/uploadedfiles/#cbcInfo.filePath##cbcInfo.fileName#">View CBC Authoriaztion</td>
              <cfelse>
               Missing Information
               </td>
              </Cfif>	
            <cfelse>
                <td colspan=2 >Background check is not required for #name#.</td>
            </Cfif> 
        </tr>

    </Cfloop>
    <input type="hidden" name="famList" value="#famMembersList#" />
    </cfif>
   </table>
      <br />
<hr width=80% align="center" height=1px />
<br />
<cfinclude template="approveDenyButtonsInclude.cfm">
   
   </cfoutput>
</cfform>


