<cfquery name="give_axis_access" datasource="mysql">
	INSERT INTO user_access_rights (userid, companyid, usertype)
	VALUES ('#url.userid#', '6', '7')
</cfquery>

<cflocation url="../index.cfm?curdoc=forms/user_info&userid=#url.userid#">