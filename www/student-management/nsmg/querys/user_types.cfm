<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="user_types" datasource="MySQL">
Select usertype, usertypeid
from smg_usertype
</cfquery>