

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<!----Default Paramaters---->
<cfparam name="FORM.subAction" default="">
<cfparam name="FORM.docExists" default="0">
<cfparam name="FORM.documentType" default="">
<cfparam name="URL.docID" default="0">
<Cfparam name="FORM.docName" default="">
<Cfparam name="FORM.fk_category" default="">
<Cfparam name="FORM.viewPermissions" default="1,2">
<Cfparam name="FORM.uploadPermissions" default="1,2">
<Cfparam name="FORM.docCategory" default="">
<!---Close the window if its cancel---->
<cfif FORM.subAction is 'Cancel'>
    <body onLoad="parent.$.fn.colorbox.close();">
    <cfabort>
</cfif>

<Cfif val(url.docID)>
	<cfset form.docExists = "#url.docID#">
</Cfif>

<!----Catagories that are available for documents---->
<cfquery name="qCatagories" datasource="#application.dsn#">
    select *
    from virtualfoldercategory
    where isActive = <Cfqueryparam cfsqltype="cf_sql_integer" value=1>
</cfquery>


<!----List of UsersTypes---->
<cfquery name="userTypes" datasource="#application.dsn#">
select *
from smg_usertype
where usertypeid <= <cfqueryparam cfsqltype="cf_sql_integer" value="8">
or usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
or usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="14">
</cfquery>

<!---Check if able to delete---->
<cfquery name="checkDocCount" datasource="#application.dsn#">
SELECT count(vfid) as docCount 
FROM virtualfolder
where fk_documentType = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(FORM.docExists)#">
</cfquery>

<cfif form.subAction is 'Delete' and checkDocCount.docCount eq 0>
	<cfquery name="deleteCat" datasource="#application.dsn#">
    delete from virtualfolderdocuments
    where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.docExists#">
    
    </cfquery>
     <body onLoad="parent.$.fn.colorbox.close();">
                    <cfabort>
</cfif>
<Cfif len(form.subAction) and form.subAction is not 'Cancel'>

<!---Error Checking---->
         <cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT len(FORM.docName) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate which type of document this is. ");
            }		
			if ( NOT len(FORM.docCategory) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please select the category for this document. ");
            }	
			if (listlen(FORM.viewPermissions) eq 2 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please assign more view permissions. ");
            }	
			if (listlen(FORM.uploadPermissions) eq 2 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please assign more upload permissions. ");
            }
        	</cfscript>
	<cfif NOT SESSION.formErrors.length()>
		<cfif val(form.docExists)>
                <cfquery datasource="#application.dsn#">
                UPDATE virtualfolderdocuments 
                    set documentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.docName#"> , 
                        fk_category = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.docCategory#">,
                        viewPermissions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.viewPermissions#">, 
                        uploadPermissions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uploadPermissions#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.docExists#">
                
                </cfquery>
            <cfelse>
                <cfquery datasource="#application.dsn#">
               insert into virtualfolderdocuments (documentType, fk_category, viewPermissions, uploadPermissions, whoCreated, DateCreated)
                            values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.docName#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.docCategory#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.viewPermissions#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uploadPermissions#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userID#">,
                                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
                
                </cfquery>
        </cfif>
       
   	<cfif FORM.subAction is 'Save and Close'>
    	  <body onLoad="parent.$.fn.colorbox.close();">
                    <cfabort>
    </cfif>
     	<cfif FORM.subAction is 'Save and New'>
         <cfscript>
        // Set Page Message
				SESSION.pageMessages.Add("Document type was successfully created.");
		</cfscript>
    	  <cfscript>
			FORM.docType = '';
			FORM.docID = '';
			FORM.docName= '';
			FORM.viewPermissions = '1,2';
			FORM.uploadPermissions = '1,2';
			FORM.docCategory = '';
	</cfscript>
    </cfif>
  </cfif>
</Cfif>


<cfif val(form.docExists)>
	<cfquery name="qCurrentDoc" datasource="#application.dsn#">
     select *
     from virtualfolderdocuments
     where id = <Cfqueryparam cfsqltype="cf_sql_integer" value = "#form.docExists#"> 
    </cfquery>
    <cfscript>
	FORM.documentType = qCurrentDoc.documentType;
	FORM.fk_category = qCurrentDoc.fk_category;
	FORM.viewPermissions = qCurrentDoc.viewPermissions;
	FORM.uploadPermissions = qCurrentDoc.uploadPermissions;
	FORM.docName = qCurrentDoc.documentType;
	Form.docCategory = qCurrentDoc.fk_category;
	
	</cfscript>
</cfif>
 <cfoutput>

 <gui:pageHeader
        headerType="applicationNoHeader"
    />	
<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">Create/Edit Document</span> 
        <em></em>
    </div>
    
    <div class="rdbox">
     <!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />
<form method="post" action="createEdit.cfm">
<input type="hidden" name="docExists" value="#url.docID#">
<input type="hidden" name="viewPermissions" value="1,2">
<input type="hidden" name="uploadPermissions" value="1,2">
    <table cellpadding=4 cellspacing="0" width=60% align=center>
    	<Tr>
        	<th align="left">Document Type</th><th width=40></th><th align="left">Who Can View</th>
         </Tr>
         <tr>
         	<Td><input type="text" name="docName" placeholder="Name of Document" size=35 value="#FORM.docName#"/></Td>
            <Td></Td>
         	<td>
            <!----table of users who can view---->
            <Table>
            	<tr>
                <cfloop query="userTypes">
                	<Td align="center">#shortUserType#</Td>
            	</cfloop>
                </tr>
                <tr>
                	<cfloop query="userTypes">
                	<Td align="center"><input type="Checkbox" name="viewPermissions" value="#userTypeID#" <cfif listFind(FORM.viewPermissions, userTypeID)>checked</cfif> <cfif usertypeID eq 1 or usertypeid eq 2>disabled</cfif> ></Td>
            	</cfloop>
                </tr>
             </Table>
            </td>
		</tr>
        <tr>
        	<th align="left">Category</th><th></th><Th align="left">Upload Permissions</Th>
        </tr>
        <Tr>
        <Td><select name="docCategory">
        	<option value=0  disabled selected><font color="##CCCCCC">Select a Category</font></option>
            <cfloop query="qCatagories">
            <option value="#categoryID#" <cfif form.docCategory eq categoryID>selected</cfif>>#categoryName#</option>
            </cfloop>
        </Td>
        <Td></Td>
         	<td>
            <!----table of users who can view---->
            <Table>
            	<tr>
                <cfloop query="userTypes">
                	<Td align="center">#shortUserType#</Td>
            	</cfloop>
                </tr>
                <tr>
                <cfloop query="userTypes">
                	<Td align="center"><input type="Checkbox" name="uploadPermissions" value="#userTypeID#" <cfif listFind(#FORM.uploadPermissions#,#userTypeID#)>checked</cfif> <cfif usertypeID eq 1 or usertypeid eq 2>disabled</cfif> > </Td>
            	</cfloop>
                </tr>
             </Table>
            </td>
		</tr>
        <tr>
      </table>
      <br><br>
      <Table align="center"width=60%>
      	<tr>
        	<Td><input name="subAction" id="submitCancel" type="submit" alt="Cancel" border=0 value='Cancel' class="buttonRed"></Td>
            <td><input name="subAction" id="submitClose" type="submit" alt="Save and Close" border=0 value='Save and Close' class="buttonBlue"></td>
            <td><input name="subAction" id="submitNew" type="submit" alt="Save and Create New" border=0 value='Save and New' class="buttonGreen"></td>
            <td>
           
            <cfif not val(checkDocCount.docCount) and val(FORM.docExists)>
            <input name="subAction" id="submitDelete" type="submit" alt="Delete" border=0 value='Delete' class="buttonRed">
            </cfif></td>
         </tr>
        
      </Table>
      
</cfoutput>
</form>
    </div>
    
    <div class="rdbottom"></div> <!-- end bottom --> 
    
</div>
