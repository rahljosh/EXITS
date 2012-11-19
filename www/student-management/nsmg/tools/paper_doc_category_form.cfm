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

<cfparam name="form.paper_doc_category_id" default="">
<cfif form.paper_doc_category_id EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(form.paper_doc_category_id)>
        a numeric paper_doc_category_id is required to edit a document category.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfset field_list = 'paper_doc_category_name'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<cfif trim(form.paper_doc_category_name) EQ ''>
		<cfset errorMsg = "Please enter the category for this document.">
    <cfelse>
		<cfif new>
            <cfquery datasource="#application.dsn#">
                INSERT INTO smg_paper_doc_categories (paper_doc_category_name)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.paper_doc_category_name#">
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE smg_paper_doc_categories SET
                paper_doc_category_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.paper_doc_category_name#">
				WHERE paper_doc_category_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.paper_doc_category_id#">
			</cfquery>
		</cfif>
        <cflocation url="index.cfm?curdoc=tools/paper_doc" addtoken="no">
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
		FROM smg_paper_doc_categories
		WHERE paper_doc_category_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.paper_doc_category_id#">
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
               Document Category
                          </span> 
            <span class="imageRight">
               <span class="imageRight">
               	 <a href="index.cfm?curdoc=tools/report_category_form"><img src="pics/icons/toolsAlone.png" width="23" height="23" /></a>
               </span>
            </span>
            <!----
                <form action=" method="post">
                <input name="Submit" type="image" src="pics/new.gif" alt="Add Report Category" border=0>
                </form>
				---->
   </div> <!-- end top --> 
             <div class="rdbox">
<!--- header of the table --->


<cfform action="index.cfm?curdoc=tools/paper_doc_category_form" method="post">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="paper_doc_category_id" value="#form.paper_doc_category_id#">



<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0 width="50%" align="center">
    <tr>
    	<Td colspan=2>Please enter the new document category that you would like to assign a document to.</Td>
    </tr>
    	<td class="label">Category: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="paper_doc_category_name" value="#form.paper_doc_category_name#" size="65" maxlength="100" required="yes" validate="noblanks" message="Please enter the Category."></td>
    </tr>
    <tr>
    	<td colspan=2 align="right"><input name="Submit" type="image" src="pics/buttons/submit.png" border=0></td>
</table>





</cfform>
    </div>
     <div class="rdbottom"></div> <!-- end bottom --> 
    
<!--rdholder--->  </div>
<!--- this table is so the form is not 100% width. --->