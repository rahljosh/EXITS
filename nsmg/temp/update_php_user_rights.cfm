<cfquery name="old_php" datasource="mysql">
select *
from user_access_rights_bu
</cfquery>
<cfdump var="#old_php#">
<cfloop query="old_php">
    <cfquery name="update_php" datasource="mysql">
    update user_access_rights
    set usertype = #usertype# 
    where userid = #userid# and companyid = #companyid#
    </cfquery>
    #userid#<br>
</cfloop>