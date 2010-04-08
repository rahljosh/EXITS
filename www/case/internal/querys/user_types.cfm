<CFQUERY name="selectdb" datasource="caseusa">
USE smg
</CFQUERY>
<cfquery name="user_types" datasource="caseusa">
Select usertype, usertypeid
from smg_usertype
</cfquery>