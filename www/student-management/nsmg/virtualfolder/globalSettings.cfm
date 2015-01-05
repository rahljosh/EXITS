
<script src="linked/js/jquery.colorbox.js"></script>
	<!----open window details---->
	<script>

        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            
            $(".iframe").colorbox({width:"60%", height:"60%", iframe:true, 
            
               onClosed:function(){ location.reload(true); } });

        });
    </script>


<!----Default Paramaters---->
<cfparam name="FORM.save" default="0">
<cfparam name="docExists" default="0">
<cfparam name="URL.docID" default="0">



<!----Catagories that are available documents---->
<cfquery name="qCatDoc" datasource="#application.dsn#">
    select vfd.documentType, vfd.id,  vfd.fk_category,   vfd.viewPermissions,  vfd.uploadPermissions, vfd.dateCreated,
    vfc.categoryName, u.firstname, u.lastname
    from virtualfoldercategory vfc
    LEFT OUTER JOIN virtualfolderdocuments vfd on vfd.fk_category = vfc.categoryid 
    LEFT JOIN smg_users u on u.userid = vfd.whoCreated
    where vfc.isActive = <Cfqueryparam cfsqltype="cf_sql_integer" value=1>
    order by categoryName, documentType
</cfquery>


<!----List of UsersTypes---->
<cfquery name="userTypes" datasource="#application.dsn#">
select *
from smg_usertype
where usertypeid <= <cfqueryparam cfsqltype="cf_sql_integer" value="8">
or usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
or usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="14">

</cfquery>


<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">Global Settings Overview</span> 
        <em></em>
    </div>
    
    <div class="rdbox">
    <!--- Form Errors 
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        
      <!--- Form Errors --->
    <gui:displayPageMessages 
        formErrors="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />
		--->
<form method="post" action="index.cfm?curdoc=virtualFolder/createEdit">
<input type="hidden" name="docExists" value="#url.docID#">
<cfset currentCategory = ''>
<cfoutput>

<br>
    <table cellpadding=4 cellspacing="0" width=100%>
    	<Tr>
        	<th align="left">Document Type</th><th align="left">Viewable By</th><th align="left">Uploadable By</th><Th align="left">Created By</Th><th align="left">Created On</Th>
         </Tr>
     <cfloop query="qCatDoc">
     	<cfset viewPerms = ''>
        <cfset upLoadPerms = ''>
        <cfloop list="#qCatDoc.viewPermissions#" index=i>
            <cfquery name="createList" dbtype="query">
            select usertype, shortUserType
            from userTypes
            where usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
            </cfquery>
            <Cfset viewPerms = ListAppend(viewPerms, ' #createList.shortUserType# ')>
        </cfloop>
         <cfloop list="#qCatDoc.uploadPermissions#" index=i>
            <cfquery name="createList" dbtype="query">
            select usertype, shortUserType
            from userTypes
            where usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
            </cfquery>
            <Cfset upLoadPerms = ListAppend(upLoadPerms, ' #createList.shortUserType# ')>
        </cfloop>
     	<cfif currentCategory neq #categoryName#>
        <Cfset currentCategory = '#categoryName#'>
        <tr bgcolor="##CCCCCC">
        	<Td colspan=6 align="left"><strong>#categoryName#</strong></Td>
        </tr>
        </cfif>
 		<Tr>
        	<td> <a class='iframe' href="virtualFolder/createEdit.cfm?docID=#id#">#documentType#</td><td>#viewPerms#</td><td>#upLoadPerms#</td><td>#firstname# #lastname#</td><Td>#DateFormat(dateCreated, 'mmm. d, yyyy')#
     </tr>
     
     </cfloop>
     </table> 
  <div align="center">   <br>
<a class='iframe' href="virtualFolder/createEdit.cfm"><img src="pics/buttons/createNewDoc.png" alt="New Document Type" border=0 value=0></a></div>
</cfoutput>
</form>
    </div>
    
    <div class="rdbottom"></div> <!-- end bottom --> 
    
</div>