
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

<cfparam name="form.r_action" default="">
<cfswitch expression="#form.r_action#">
    <!--- turn report maintenance on. --->
    <cfcase value="paper_doc_maintenance_on">
        <cfset client.paper_doc_maintenance = 1>
    </cfcase>
    <!--- turn report maintenance off. --->
    <cfcase value="report_maintenance_off">
        <cfset client.paper_doc_maintenance = 0>
    </cfcase>
    <!--- delete category. --->
    <cfcase value="delete_category">
        <cfquery datasource="#application.dsn#">
            DELETE FROM smg_paper_doc_categories
            WHERE paper_doc_category_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.paper_doc_category_id#">
        </cfquery>
    </cfcase>
</cfswitch>

<cfparam name="client.paper_doc_maintenance" default="0">


 <div class="rdholder" style="width: 100%;"> 
				<div class="rdtop"><span class="rdtitle">
               Document Maintenance
                          </span> 
            <span class="imageRight"><img src="pics/icons/toolsAlone.png" height=25/></span>
               
   </div> <!-- end top --> 
             <div class="rdbox">

<table border=0 cellpadding=4 cellspacing=0  width=100%>
    <tr>
        <td>
        
        <p>To edit documents, turn Document Maintenance on here, and then go to the <a href="index.cfm?curdoc=documents/index">documents page</a>.</p>
        
		<p>When turned on, the following will be available on the documents page:</p>
        <ul>
        	<li>Edit links.</li>
        	<li><em>Active</em> column and search selection.</li>
        	<li><em>Number of Favorites</em> column, indicating how many users have each document selected as a favorite.</li>
		</ul>
        </td>
        <td>
        <cfif client.report_maintenance>
        	
            <center>
            <form action="index.cfm?curdoc=tools/paper_doc" method="post">
            <input type="hidden" name="r_action" value="report_maintenance_off">
            <input type="image" src= "pics/buttons/reportMain_on.png" value="Turn Report Maintenance Off" />
            </form>
            </center>
        <cfelse>
        	
            <center>
            <form action="index.cfm?curdoc=tools/paper_doc" method="post">
            <input type="hidden" name="r_action" value="report_maintenance_on">
            <input type="image" src= "pics/buttons/reportMain_off.png" value="Turn Report Maintenance On" />
            </form>
            </center>
        </cfif>
        
        </td>
    </tr>
</table>
    </div>
     <div class="rdbottom"></div> <!-- end bottom --> 
    
<!--rdholder--->  </div>

<br />
 <div class="rdholder" style="width: 100%;"> 
				<div class="rdtop"><span class="rdtitle">
               Report Category Maintenance
                          </span> 
            <span class="imageRight">
               <span class="imageRight">
               	 <a href="index.cfm?curdoc=tools/report_category_form"><img src="pics/buttons/new23x23.png" width="23" height="23" /></a>
               </span>
            </span>
            <!----
                <form action=" method="post">
                <input name="Submit" type="image" src="pics/new.gif" alt="Add Report Category" border=0>
                </form>
				---->
   </div> <!-- end top --> 
             <div class="rdbox">


<cfquery name="getResults" datasource="#application.dsn#">
    SELECT paper_doc_category_id, paper_doc_category_name, COUNT(fk_paper_doc_category) AS count
    FROM smg_paper_doc_categories
    LEFT JOIN smg_paper_doc_doc ON smg_paper_doc_categories.paper_doc_category_id = smg_reports.fk_paper_doc_category
    GROUP BY paper_doc_category_id, paper_doc_category_name
    ORDER BY paper_doc_category_name
</cfquery>

<cfif getResults.recordCount GT 0>

    <table width=100% cellpadding="4" cellspacing="0">
        <tr align="left">
            <th>&nbsp;</th>
            <th>&nbsp;</th>
            <th>Category</th>
            <th>Number of Reports</th>
        </tr>
        <cfoutput query="getResults">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("edeff4") ,DE("white") )#">
                <td width=30>
                	<!--- only allow delete if this category isn't assigned to any reports. --->
                    <cfif count EQ 0>
						<!--- delete category --->
                        <form action="index.cfm?curdoc=tools/paper_doc" method="post" onclick="return confirm('Are you sure you want to delete this Category?')">
                        <input type="hidden" name="r_action" value="delete_category">
                        <input type="hidden" name="paper_doc_category_id" value="#paper_doc_category_id#">
                        <input name="Submit" type="image" src="pics/buttons/delete23x28.png" alt="Delete Document Category" border=0>
                        </form>
                    </cfif>
                </td>
                <td width=30>
                	<!--- edit category --->
                    <form action="index.cfm?curdoc=tools/paper_doc_category_form" method="post">
                    <input type="hidden" name="paper_doc_category_id" value="#paper_doc_category_id#">
                    <input name="Submit" type="image" src="pics/buttons/pencilBlue23x29.png" alt="Edit Document Category" border=0>
                    </form>
                </td>
                <td>#report_category_name#</td>
                <td>#count#</td>
            </tr>
        </cfoutput>
        <tr>
        	<td align="Center" colspan=4><br />
            <a href="index.cfm?curdoc=tools/paper_doc_category_form"><img src="pics/buttons/addCat.png" height=40/></a>
            </td>
        </tr>
    </table>
           
<cfelse>
    <table border=0 cellpadding=4 cellspacing=0  width=100%>
        <tr>
            <td>There are no document categories.</td>
        </tr>
    </table>
</cfif>

    </div>
     <div class="rdbottom"></div> <!-- end bottom --> 
    
<!--rdholder--->  </div>