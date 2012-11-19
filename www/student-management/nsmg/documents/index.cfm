<style type="text/css">
<!--
.usertype {
	font-size: 13px;
	font-weight: bold;
	background-color: #ccc;
	line-height: 25px;
}
.fav_no {
	font-size: 27px;
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	color: #cccccc;
}
.fav_yes {
	font-size: 27px;
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	color: #F60;
}
 .rdholder {

  height:auto;
  width:auto;
  margin-bottom:25px;

 } 


 .rdholder .rdbox {
	border-left:1px solid #c6c6c6;
	border-right:1px solid #c6c6c6;
	padding:10px 15px;
	margin:0;
	display: block;
	min-height: 137px;
 } 

 .rdtop {
	width:auto;
	height:30px;
	border: 1px solid #c6c6c6;
	/* -webkit for Safari and Google Chrome */

  -webkit-border-top-left-radius:12px;
	-webkit-border-top-right-radius:12px;
	/* -moz for Firefox, Flock and SeaMonkey  */

  -moz-border-radius-topright:12px;
	-moz-border-radius-topleft:12px;
	background-color: #FFF;
	color: #006699;
 } 

 .rdtop .rdtitle {
	margin:0;
	line-height:30px;
	font-family:Arial, Geneva, sans-serif;
	font-size:20px;
	padding-top: 5px;
	padding-right: 10px;
	padding-bottom: 0px;
	padding-left: 10px;
	color: #006699;
	
 }
 
 .imageRight{
		float:right; 
		margin:3px;
 }

 .rdbottom {

  width:auto;
  height:10px;
  border-bottom: 1px solid #c6c6c6;
  border-left:1px solid #c6c6c6;
  border-right:1px solid #c6c6c6;
   /* -webkit for Safari and Google Chrome */

  -webkit-border-bottom-left-radius:12px;
  -webkit-border-bottom-right-radius:12px;


 /* -moz for Firefox, Flock and SeaMonkey  */

  -moz-border-radius-bottomright:12px;
  -moz-border-radius-bottomleft:12px; 
 
 }

.clearfix {
	display: block;
	height: 5px;
	width: 100%;
}

.alert{
	width:auto;
	height:35px;
	border:#666;
	background-color:#FFC;
	text-align:center;
	-moz-border-radius: 15px; 
	border-radius: 15px;
	vertical-align:center;

}
-->
</style>

<!--- add favorite --->
<cfif isDefined("url.add_fav")>
	<!--- if they click twice they can add the favorite twice and get two reports on the list. --->
    <cfquery name="check_fav" datasource="#application.dsn#">
        SELECT *
        FROM smg_paper_doc_favorites
        WHERE fk_paper_doc = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.add_fav#">
        AND fk_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
    <cfif check_fav.recordCount EQ 0>
        <cfquery datasource="#application.dsn#">
            INSERT INTO smg_paper_doc_favorites (fk_paper_doc, fk_user)
            VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#url.add_fav#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            )  
        </cfquery>
    </cfif>
<!--- remove favorite --->
<cfelseif isDefined("url.remove_fav")>
    <cfquery datasource="#application.dsn#">
        DELETE FROM smg_document_favorites
        WHERE fk_paper_doc = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.remove_fav#">
        AND fk_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
</cfif>

<!--- this is turned on/off on the tools/reports page. --->
<cfparam name="client.paper_doc_maintenance" default="0">

<cfparam name="submitted" default="0">
<cfparam name="favorite" default="Yes">
<cfparam name="usertype_category" default="">
<cfparam name="keyword" default="">
<cfparam name="paper_doc_active" default="1">
<cfparam name="recordsToShow" default="25">

<cfif client.paper_doc_maintenance>
    <div class="alert">
     
             <table align="center" width= 50%>
            
            <tr>
               <td> <h2>Document Maintenance is turned on.</h2></td><td> <a href="index.cfm?curdoc=tools/paper_doc"><img src="pics/buttons/tools.png" height=30 /></a></td><td><a href="index.cfm?curdoc=tools/paper_doc_form"><img src="pics/buttons/document.png" height=30/></a></td>
            </tr>
            </table> 
     </div>
</cfif>
<br />


 <div class="rdholder" style="width: 100%;"> 
				<div class="rdtop"><span class="rdtitle">
                Documents
                          </span> 
           
               
   </div> <!-- end top --> 
             <div class="rdbox">


<cfform action="index.cfm?curdoc=documents/index" method="post">
<input name="submitted" type="hidden" value="1">


<table border=0 cellpadding=4 cellspacing=0  width=100%>
    <tr>
        <td>
        <input type="image" src="pics/buttons/submit.png" name="send" />
        </td>
        <td>
            Favorite<br />
            <select name="favorite">
            	<option value="">All</option>
                <option <cfif favorite EQ 'Yes'>selected</cfif>>Yes</option>
                <option <cfif favorite EQ 'No'>selected</cfif>>No</option>
            </select>            
        </td>
        <td>
            <cfquery name="get_usertype_category" datasource="#application.dsn#">
                SELECT DISTINCT smg_usertype.usertypeid, smg_usertype.usertype AS usertypename,
                	smg_paper_doc_categories.paper_doc_category_id, smg_paper_doc_categories.paper_doc_category_name
                FROM smg_paper_doc
                INNER JOIN smg_usertype ON smg_paper_doc.fk_usertype = smg_usertype.usertypeid
                INNER JOIN smg_paper_doc_categories ON smg_paper_doc.fk_paper_doc_category = smg_paper_doc_categories.paper_doc_category_id
                WHERE smg_paper_doc.paper_doc_active = 1
                AND smg_paper_doc.fk_usertype >= <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
                ORDER BY smg_paper_doc.fk_usertype, smg_paper_doc_categories.paper_doc_category_name
            </cfquery>
            Level - Category<br />
			<select name="usertype_category">
                <option value="">All</option>
            	<cfoutput query="get_usertype_category" group="usertypeid">
                  <option value="#usertypeid#" <cfif usertype_category EQ '#usertypeid#'>selected</cfif>>Reports Available for #usertypename# and Above</option>
                    <cfoutput>
                   		<option value="#usertypeid#,#paper_doc_category_id#" <cfif usertype_category EQ '#usertypeid#,#paper_doc_category_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#paper_doc_category_name#</option>
                    </cfoutput>
                </cfoutput>
			</select>
			<!---<cfquery name="get_categories" datasource="#application.dsn#">
                SELECT *
                FROM smg_report_categories
                ORDER BY report_category_name
            </cfquery>
            Category<br />
			<cfselect name="report_category_id" query="get_categories" value="report_category_id" display="report_category_name" selected="#report_category_id#" queryPosition="below">
				<option value="">All</option>
			</cfselect>--->
        </td>
        <td>
            Keyword<br />
			<cfinput type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
        </td>
        <cfif client.paper_doc_maintenance>
            <td>
                Active<br />
                <select name="report_active">
                    <option value="">All</option>
                    <option value="1" <cfif paper_doc_active EQ 1>selected</cfif>>Yes</option>
                    <option value="0" <cfif paper_doc_active EQ 0>selected</cfif>>No</option>
                </select>            
            </td>
        </cfif>
        <td>
            Records Per Page<br />
            <select name="recordsToShow">
                <option <cfif recordsToShow EQ 25>selected</cfif>>25</option>
                <option <cfif recordsToShow EQ 50>selected</cfif>>50</option>
                <option <cfif recordsToShow EQ 100>selected</cfif>>100</option>
                <option <cfif recordsToShow EQ 250>selected</cfif>>250</option>
                <option <cfif recordsToShow EQ 500>selected</cfif>>500</option>
            </select>            
        </td>
    </tr>
</table>
</cfform>

<cfquery name="getResults" datasource="#application.dsn#">
    SELECT smg_paper_doc.*, smg_usertype.usertype AS usertypename, smg_paper_doc_categories.paper_doc_category_name, smg_paper_doc_favorites.fk_paper_doc AS isfavorite
    FROM smg_paper_doc
    INNER JOIN smg_usertype ON smg_paper_doc.fk_usertype = smg_usertype.usertypeid
    INNER JOIN smg_paper_doc_categories ON smg_paper_doc.fk_paper_doc_category = smg_paper_doc_categories.paper_doc_category_id
    LEFT JOIN smg_paper_doc_favorites ON (
        smg_paper_doc.paper_doc_id = smg_paper_doc_favorites.fk_paper_doc
        AND smg_paper_doc_favorites.fk_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    )
    WHERE smg_paper_doc.fk_usertype >= <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
    <!--- if report maintenance is turned on they're using the active selection, else hard coded for active. --->
    <cfif client.paper_doc_maintenance>
        <cfif paper_doc_active NEQ ''>
            AND smg_paper_doc.paper_doc_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#paper_doc_active#">
        </cfif>
    <cfelse>
        AND smg_paper_doc.paper_doc_active = 1
    </cfif>
    <cfif favorite NEQ ''>
        <cfif favorite EQ 'Yes'>
            AND smg_paper_doc_favorites.fk_paper_doc IS NOT NULL
        <cfelseif favorite EQ 'No'>
            AND smg_paper_doc_favorites.fk_paper_doc IS NULL
        </cfif>
    </cfif>
    <cfif usertype_category NEQ ''>
        AND smg_paper_doc.fk_usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#listFirst(usertype_category)#">
        <cfif listLen(usertype_category) EQ 2>
            AND smg_paper_doc.fk_paper_doc_category = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(usertype_category)#">
        </cfif>
    </cfif>
    <cfif trim(keyword) NEQ ''>
        AND (
            smg_paper_doc.paper_doc_name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
            OR smg_paper_doc.paper_doc_description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
        )
    </cfif>
    	AND fk_company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.companyshort#">
    ORDER BY smg_paper_doc.fk_usertype, smg_paper_doc_categories.paper_doc_category_name, smg_paper_doc.paper_doc_name
</cfquery>
<Cf dump var="#getResults#">
<cfif getResults.recordCount GT 0>

    <cfif client.paper_doc_maintenance>
        <cfquery name="count_favorites" datasource="#application.dsn#">
            SELECT fk_paper_doc, COUNT(*) AS fav_count
            FROM smg_paper_doc_favorites
            GROUP BY fk_paper_doc
        </cfquery>
    </cfif>

    <cfparam name="url.startPage" default="1">
    <cfset totalPages = ceiling(getResults.recordCount / recordsToShow)>
    <cfset startrow = 1 + ((url.startPage - 1) * recordsToShow)>
    <cfif getResults.recordCount GT url.startPage * recordsToShow>
        <cfset isNextPage = 1>
        <cfset endrow = url.startPage * recordsToShow>
    <cfelse>
        <cfset isNextPage = 0>
        <cfset endrow = getResults.recordCount>
    </cfif>
    <cfset urlVariables = "submitted=1&favorite=#favorite#&usertype_category=#usertype_category#&keyword=#urlEncodedFormat(keyword)#&paper_doc_active=#paper_doc_active#&recordsToShow=#recordsToShow#">

    <cfoutput>

    <table border=0 cellpadding=4 cellspacing=0  width=100%>
        <tr align="center">
            <td>
                <cfif totalPages GT 1>
                    <cfif url.startPage NEQ 1>
                        <a href="index.cfm?curdoc=documents/index&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                    </cfif>
                    <cfloop from="1" to="#totalPages#" index="i">
                        <cfif i is url.startPage>#i#<cfelse><a href="index.cfm?curdoc=documents/index&startPage=#i#&#urlVariables#">#i#</a></cfif>
                    </cfloop>
                    <cfif isNextPage>
                        &nbsp; <a href="index.cfm?curdoc=documents/index&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                    </cfif>
                    <br>
                </cfif>
                Displaying #startrow# to #endrow# of #getResults.recordCount#
            </td>
        </tr>
    </table>

    <table width=100% cellspacing="0" cellpadding="4">
        <cfset myCurrentRow = 0>
        <cfset current_usertype = ''>
        <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
            <cfset myCurrentRow = myCurrentRow + 1>
            <cfif fk_usertype NEQ current_usertype>
                <cfset myCurrentRow = 1>
                <cfset current_usertype = fk_usertype>
                <tr align="left">
                    <th colspan="7" class="usertype">&nbsp;Reports Available for #usertypename# and Above</th>
                </tr>
                <tr align="left">
                    <cfif client.paper_doc_maintenance>
                        <th>&nbsp;</th>
                    </cfif>
                    <th align="center">Favorite</th>
                    <th>Category</th>
                    <th>Report Name</th>
                    <th>Description</th>
                    <cfif client.paper_doc_maintenance>
                        <th>Active</th>
                        <th>Number of Favorites</th>
                    </cfif>
                </tr>
            </cfif>
            <tr bgcolor="#iif(myCurrentRow MOD 2 ,DE("edeff4") ,DE("white") )#">
                <cfif client.paper_doc_maintenance>
                    <td align="center">
                        <!--- edit report --->
                        <form action="index.cfm?curdoc=tools/paper_doc_form" method="post">
                        <input type="hidden" name="paper_doc_id" value="#paper_doc_id#">
                        <input name="Submit" type="image" src="pics/buttons/pencilBlue23x29.png" alt="Edit Report" border=0>
                        </form>
                    </td>
                </cfif>
                <td align="center">
                	<!--- old buttons: <font class="fav_yes">*</font> <font class="fav_no">*</font> --->
                    <cfif isfavorite NEQ ''>
                        <a href="index.cfm?curdoc=documents/index&remove_fav=#paper_doc_id#&startPage=#url.startPage#&#urlVariables#" title="Remove Favorite" onClick="return confirm('Are you sure you want to remove this Favorite?')"><img src="pics/star.png" border="0" height=20 /></a>
                    <cfelse>
                        <a href="index.cfm?curdoc=documents/index&add_fav=#paper_doc_id#&startPage=#url.startPage#&#urlVariables#" title="Add Favorite"><img src="pics/greyStar.png" border="0" height=20 /></a>
                    </cfif>
                </td>
                <td><strong>#paper_doc_category_name#</strong></td>
                <td><a href="uploadedfiles/documents/#client.companyshort#/#paper_doc_template#" target="_new">#paper_doc_name#</a></td>
                <td>#replaceList(paper_doc_description, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</td>
                <cfif client.paper_doc_maintenance>
                    <cfquery name="get_count" dbtype="query">
                        SELECT fav_count
                        FROM count_favorites
                        WHERE fk_paper_doc = <cfqueryparam cfsqltype="cf_sql_integer" value="#paper_doc_id#">
                    </cfquery>
                    <td>#yesNoFormat(paper_doc_active)#</td>
                    <td>#numberFormat(get_count.fav_count)#</td>
                </cfif>
            </tr>
        </cfloop>
    </table>
           
    </cfoutput>
<cfelse>
    <table border=0 cellpadding=4 cellspacing=0width=100%>
        <tr>
            <th><br />
            	<!--- since favorites is the default search selection, give special message to users coming here for the first time who would get no results. --->
                <cfif favorite NEQ '' and usertype_category EQ '' and trim(keyword) EQ ''>
                	You have no favorites selected.  Select Favorite=All and click Submit, then click the Favorites column to add favorites.
                <cfelse>
                    No reports matched your criteria.
                </cfif>
            </th>
        </tr>
    </table>
</cfif>

    </div>
     <div class="rdbottom"></div> <!-- end bottom --> 
    
<!--rdholder--->  </div>