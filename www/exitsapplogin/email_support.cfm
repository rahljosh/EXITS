<cfmail to="support@exitgroupinc.zendesk.com" from="#session.email#" Subject="#session.companyname# Help">
User: #client.name#<br />
Email: #client.email#<br />
Company: #client.companyname#<br />
Browser: #cgi.http_user_agent#<Br />
IP: #cgi.REMOTE_ADDR#
<br />
#form.support_info#
</cfmail>
<cflocation url="support?sent"