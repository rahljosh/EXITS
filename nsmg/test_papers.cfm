<cfquery name="ar_paperword" datasource="mysql">
select ar_info_sheet, ar_ref_quest1, ar_ref_quest2, ar_cbc_auth_form,ar_agreement, ar_training, userid
from smg_users
</cfquery>
<cfoutput>

<Cfloop query="ar_paperword">
	#ar_info_sheet#, #ar_ref_quest1#, #ar_ref_quest2#, #ar_cbc_auth_form#,#ar_agreement#, #ar_training#, #userid#<br />
</Cfloop>

</cfoutput>