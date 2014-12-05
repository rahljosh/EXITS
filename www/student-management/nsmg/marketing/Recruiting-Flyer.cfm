
<Cfquery name="repInfo" datasource="#application.dsn#">
select firstname, lastname, email, work_phone 
from smg_users
where userid = #client.userid#
</cfquery>

<cfdocument format="PDF" pagetype="letter" pageheight="200" pagewidth="200" margintop=".25" marginbottom=".25" marginright=".20" marginleft=".20" backgroundvisible="yes" bookmark="false" localurl="no" saveasname="Recruiting-Flyer.pdf" >

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>ISE Recruiting Flyer</title>

</head>

<body>
<Cfoutput>
<div style="height: 3235px; width: 2500px; display: block; background-image:url(Recruiting-Flyer.jpg); background-repeat:no-repeat; background-position:top; border: 1px solid ##ccc;">
<div style="width: 600px; display: block; margin-top: 3050px; margin-left: 1700px;">

<p style="font-family: sans-serif; font-size: 65px; text-align: left; color: ##fff;"><strong>#repInfo.work_phone#</strong></p>

      </div>
    </div>
    </Cfoutput>
</body>
</html>
</cfdocument>
