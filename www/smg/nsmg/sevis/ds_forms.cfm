<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<!-----Company Information----->
<Cfquery name="get_company" datasource="MySQL">
	select companyid, companyname, companyshort, sevis_userid, iap_auth
	from smg_companies
	where companyid = #client.companyid#
</Cfquery>

<cfquery name="get_batches" datasource="MySql">
	SELECT s.batchid, s.type
	FROM smg_sevis s
	WHERE s.companyid = '#client.companyid#'
		<cfif IsDefined('batch_type')>AND type = '#batch_type#'</cfif>
	ORDER BY datecreated DESC
</cfquery>

<!--- https://egov.ice.gov/sbtsevis BETA WEBSITE--->
<!--- https://egov.ice.gov/sbtsevisbatch/action/batchUpload  BETA SERVER--->


<!--- https://egov.ice.gov/sbtsevisbatch/action/batchDownload BETA SERVER--->

<cfoutput>
<table cellpadding=6 cellspacing="0" align="center" width="98%">
<tr><td width="50%">
	<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="100%">
		<th align="center" bgcolor="ededed">DS-2019 - Upload XML File to DS</th></tr>
		<td><form method="post" enctype="multipart/form-data" action="https://egov.ice.gov/sevisbatch/action/batchUpload">
			XML: <Span Style="Width:10"></Span><input type="file" name="xml" id="xml=" size="18"><br>
			Batch ID: <span style="width:24"></span>
				<select name="batchid" id="batchid=">
					<cfloop query="get_batches">
						<cfset add_zeros = 13 - len(#get_batches.batchid#) - len(#get_company.companyshort#)>
						<option value="#get_company.companyshort#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#batchid#">#get_company.companyshort#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#batchid# &nbsp;</option>
					</cfloop>
				</select><br>			
			<!--- Batch ID: <Span Style="Width:25"></Span>  <input type="text" name="batchid" id="batchid=" maxlength="14" --->
			Orgid: <Span Style="Width:42"></Span> <input type="text" name="orgid" id="orgid=" value="#get_company.iap_auth#"><br>
			Username: <Span Style="Width:12"></Span> <input type="text" name="userid" id="userid=" value="#get_company.sevis_userid#"><br>
			<Span Style="Width:80"></Span><input type="submit" value="Upload XML File">
			</form>
		</td>
	</table>
</td>
<td width="50%" valign="top">
	<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="100%">
		<th align="center" bgcolor="ededed">DS-2019 - Download ZIP File from DS</th></tr>
		<td><form method="get" enctype="multipart/form-data" action="https://egov.ice.gov/sevisbatch/action/batchDownload"/>
			Batch ID: <span style="width:24"></span>
				<select name="batchid" id="batchid=">
					<cfloop query="get_batches">
						<cfset add_zeros = 13 - len(#get_batches.batchid#) - len(#get_company.companyshort#)>
						<option value="#get_company.companyshort#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#batchid#">#get_company.companyshort#-<cfloop index = "ZeroCount" from = "1" to = #add_zeros#>0</cfloop>#batchid# &nbsp;</option>
					</cfloop>
				</select><br>
			Orgid: <span style="width:40"></span><input type="text" name="orgid" id="orgid=" value="#get_company.iap_auth#"><br>
			Username: <span style="width:13"></span><input type="text" name="userid" id="userid=" value="#get_company.sevis_userid#"><br>
			<Span Style="Width:80"></Span><input type="submit" value="Download ZIP File">
			</form>
		</td>
	</table><br><br>
</td>
</tr>
</table><br>
</cfoutput>