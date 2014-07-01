
<Cfquery name="repInfo" datasource="#application.dsn#">
select firstname, lastname, email,  work_phone as phone
from smg_users
where userid = #client.userid#
</cfquery>

<Cfquery name="regionSite" datasource="#application.dsn#">
select url
from smg_regions
where regionid = #client.regionid#
</cfquery>


<cfdocument format="PDF" margintop=".25" marginbottom=".25" marginright=".25" marginleft=".25" backgroundvisible="yes" overwrite="no" fontembed="yes" bookmark="false" localurl="no" saveasname="scrapbook-ad.pdf" orientation="landscape">

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>ISE Scrapbook Ad</title>

</head>

<body>
<cfoutput>
<div style="width: 3235px; height: 2500px; display: block; background-image:url(scrap-book-ad.jpg); background-repeat:no-repeat; background-position:top; margin-top: -80px; border: 1px solid ##fff;">
<div style="width: 530px; margin-top: 1850px; margin-left: 2470px; display: block;">
<p style="font-family: sans-serif; font-size: 50px; text-align: center; color: ##000; line-height:65px;"><strong>#repInfo.firstname# #repInfo.lastname#</strong><br />
          P: #repInfo.phone#<br />
           #repInfo.email#<br>
           #regionSite.url#</p>

  </div></div>
    </cfoutput>
</body>
</html>
</cfdocument>
