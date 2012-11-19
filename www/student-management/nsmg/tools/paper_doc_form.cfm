<style type="text/css">
<!--
 .imageRight{
		float:right; 
		margin:3px;
 }
 -->
 </style>
<cfif not client.usertype LTE 4>
	<h3>You do not have access to this page.</h3>
    <cfabort>
</cfif>

<cfparam name="form.paper_doc_id" default="">
<cfif form.paper_doc_id EQ "">
	<!--- only global can add a report because you also need to add the ColdFusion template. --->
    <cfif not client.usertype EQ 1>
        you do not have access to add a report.
        <cfabort>
    </cfif>
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(form.paper_doc_id)>
        a numeric paper_doc_id is required to edit a report category.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfset field_list = 'paper_doc_name,paper_doc_description,paper_doc_template,paper_doc_active,fk_usertype,fk_paper_doc_category'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<!--- checkboxes aren't defined if not checked. --->
    <cfparam name="form.paper_doc_active" default="0">

	<cfif trim(form.paper_doc_name) EQ ''>
		<cfset errorMsg = "Please enter the Document Name.">
	<cfelseif trim(form.paper_doc_template) EQ '' and not val(form.paper_doc_id)>
		<cfset errorMsg = "Please select file.">
    <cfelse>
		<cfif new>
            
            <cffile action="upload" destination="#APPLICATION.PATH.uploadedFiles#/documents/#client.companyshort#/"  fileField="paper_doc_template" nameconflict="makeunique">
            
            <cfquery datasource="#application.dsn#">
                INSERT INTO smg_paper_doc (fk_usertype, fk_paper_doc_category, paper_doc_name, paper_doc_description, paper_doc_active, paper_doc_template, fk_company)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_usertype#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_paper_doc_category#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.paper_doc_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.paper_doc_description#" null="#yesNoFormat(trim(form.paper_doc_description) EQ '')#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#form.paper_doc_active#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#file.ServerFile#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.companyshort#">
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
        
			<cfquery datasource="#application.dsn#">
				UPDATE smg_paper_doc SET
                fk_usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_usertype#">,
                fk_paper_doc_category = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_paper_doc_category#">,
                paper_doc_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.paper_doc_name#">,
                paper_doc_description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.paper_doc_description#" null="#yesNoFormat(trim(form.paper_doc_description) EQ '')#">,
                <Cfif paper_doc_template is not ''>
                paper_doc_template = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.paper_doc_template#">,
                </Cfif>
                paper_doc_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.paper_doc_active#">
                
				WHERE paper_doc_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.paper_doc_id#">
			</cfquery>
		</cfif>
        <cflocation url="index.cfm?curdoc=documents/index" addtoken="no">
	</cfif>

<!--- add --->
<cfelseif new>

	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = "">
	</cfloop>
        
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="#application.dsn#">
		SELECT *
		FROM smg_paper_doc
		WHERE paper_doc_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.paper_doc_id#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
</cfif>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

 <div class="rdholder" style="width: 100%;"> 
				<div class="rdtop"><span class="rdtitle">
                Document Maintenance
                          </span> 
          <span class="imageRight"><img src="pics/buttons/pencilBlue23x29.png" width="23" height="23" /></span>
               
   </div> <!-- end top --> 
             <div class="rdbox">


<cfform action="index.cfm?curdoc=tools/paper_doc_form" method="post" enctype="multipart/form-data">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="paper_doc_id" value="#form.paper_doc_id#">

<table width="100%" border=0 cellpadding=4 cellspacing=0>
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Level: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_usertypes" datasource="#application.dsn#">
                SELECT usertypeid, usertype
                FROM smg_usertype
                WHERE usertypeid >= <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
                AND usertypeid <= 9
                ORDER BY usertypeid
            </cfquery>
            Documents Available for
            <cfselect name="fk_usertype" query="get_usertypes" value="usertypeid" display="usertype" selected="#form.fk_usertype#" />
            and Above
        </td>
    </tr>
    <tr>
    	<td class="label">Category: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_categories" datasource="#application.dsn#">
                SELECT *
                FROM smg_paper_doc_categories
                ORDER BY paper_doc_category_name
            </cfquery>
            <cfselect name="fk_paper_doc_category" query="get_categories" value="paper_doc_category_id" display="paper_doc_category_name" selected="#form.fk_paper_doc_category#" />
        </td>
    </tr>
    <tr>
    	<td class="label">Document Name: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="paper_doc_name" value="#form.paper_doc_name#" size="65" maxlength="100" required="yes" validate="noblanks" message="Please enter the document Name."></td>
    </tr>
    <tr>
    	<td class="label">Description:</td>
        <td><cftextarea name="paper_doc_description" value="#form.paper_doc_description#" cols="50" rows="6" /></td>
    </tr>
    <tr>
    	<td class="label">Active:</td>
        <td><cfinput type="checkbox" name="paper_doc_active" value="1" checked="#yesNoFormat(form.paper_doc_active EQ 1)#"></td>
    </tr>

    <tr>
    	<td class="label">File: <cfif not val(form.paper_doc_id)><span class="redtext">*</span></cfif></td>
        <td>
        	<cfif not val(form.paper_doc_id)>
        	<cfinput type="file" name="paper_doc_template" message="Please select the file." validate="noblanks" required="yes" size="20">
            <cfelse>
            <cfinput type="file" name="paper_doc_template" size="20"> (only upload doc if changes are necessary)
            </cfif>
        </td>
    </tr>

</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100%>
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/buttons/submit.png" border=0></td>
	</tr>
</table>

</cfform>


    </div>
     <div class="rdbottom"></div> <!-- end bottom --> 
    
<!--rdholder--->  </div>
<!--- this table is so the form is not 100% width. --->