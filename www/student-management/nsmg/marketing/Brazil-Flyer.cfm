
<Cfquery name="repInfo" datasource="#application.dsn#">
select firstname, lastname, email, work_phone as phone
from smg_users
where userid = #client.userid#
</cfquery>

<Cfquery name="regionSite" datasource="#application.dsn#">
select url
from smg_regions
where regionid = #client.regionid#
</cfquery>

<cfdocument format="PDF" margintop=".20" marginbottom=".20" marginright=".20" marginleft=".20" backgroundvisible="yes" overwrite="no" fontembed="yes" bookmark="false" localurl="no" saveasname="Brazil-Flyer.pdf" >
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Brazil Flyer</title>

</head>

<body>
<Cfoutput>
<div style="height: 3235px; width: 2500px; display: block; background-image:url(Brazil-print.jpg); background-repeat:no-repeat; background-position:center; border: 1px solid ##fff;">
<div style="width: 2400px; display: block; margin-top: 3115px; margin-left: 140px; font-family: sans-serif; font-size: 60px; text-align: left; color: ##fff; line-height:65px;">

<div style="float: left; width: 300px;" ><strong>#regionSite.url#</strong></div>
<div style="width: 500px; float: left;  margin-left: 1260px;">
<div><strong>#repInfo.phone#</strong></div>

 </div>
</div>
   </div>
    </Cfoutput>
</body>
</html>
</cfdocument>
