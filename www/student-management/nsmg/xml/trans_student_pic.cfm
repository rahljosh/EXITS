<!----Student Picture---->
<cfhttp url='#StudentXMLFile.applications.application[i].page1.student.image.url.xmltext#'  method="get" path="#AppPath.onlineApp.picture#" file="#client.studentid#.jpg" multipart="yes" getasbinary="yes" username="exits" password="34uFka">