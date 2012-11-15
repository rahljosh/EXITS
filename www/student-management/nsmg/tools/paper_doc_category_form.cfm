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

<cfparam name="form.report_category_id" default="">
<cfif form.report_category_id EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(form.report_category_id)>
        a numeric report_category_id is required to edit a report category.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfset field_list = 'report_category_name'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<cfif trim(form.report_category_name) EQ ''>
		<cfset errorMsg = "Please enter the Category.">
    <cfelse>
		<cfif new>
            <cfquery datasource="#application.dsn#">
                INSERT INTO smg_report_categories (report_category_name)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_category_name#">
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE smg_report_categories SET
                report_category_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_category_name#">
				WHERE report_category_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.report_category_id#">
			</cfquery>
		</cfif>
        <cflocation url="index.cfm?curdoc=tools/reports" addtoken="no">
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
		FROM smg_report_categories
		WHERE report_category_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.report_category_id#">
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
               Report Category
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


<cfform action="index.cfm?curdoc=tools/report_category_form" method="post">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="report_category_id" value="#form.report_category_id#">



<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0 width="100%">
    <tr>
    	<Td colspan=2>Please enter the new report category that you would like to assign a report to.</Td>
    </tr>
    	<td class="label">Category: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="report_category_name" value="#form.report_category_name#" size="65" maxlength="100" required="yes" validate="noblanks" message="Please enter the Category."></td>
    </tr>
    <tr>
    	<td colspan=2 align="right"><input name="Submit" type="image" src="pics/buttons/submit.png" border=0></td>
</table>





</cfform>
    </div>
     <div class="rdbottom"></div> <!-- end bottom --> 
    
<!--rdholder--->  </div>
<!--- this table is so the form is not 100% width. --->