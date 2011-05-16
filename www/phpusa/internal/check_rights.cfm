<!----Keep AR's from switching around to other accounts---->
<cfquery name="get_usertype" datasource="MySql">
	SELECT 
    	userid, 
        usertype
	FROM 
    	user_access_rights
	WHERE 
    	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
</cfquery>

<cfoutput>

<cfif NOT ListFind("1,2,3,4", CLIENT.userType) AND URL.userID NEQ CLIENT.userid>
    <table>
        <tr>
            <td>
                <br /><img src="pics/error_exclamation.gif" width="37" height="44"></td><td>You do not have access to view this account.<br><br>
                You can view your account by clicking <a href="?curdoc=forms/user_info&userid=#CLIENT.userid#">here.<a/><br />
            </td>
        </tr>
    </table>
<cfabort>
</cfif>

</cfoutput>