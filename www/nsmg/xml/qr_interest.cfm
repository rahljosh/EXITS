<Cfoutput>
<!----Get the number of interests to loop through---->
<cfset count_activity_list = ArrayLen(#StudentXMLFile.applications.application[i].page2.activities.activity#)>
<!----First set a text list to null, so we can append to it.  With out first declaring it, you get an error.  Then loop through the XML file and create a list of words---->
<cfset word_interest_list =''>
<cfloop index="j" from="1" to="#count_activity_list#">
	<cfset word_interest_list = ListAppend(word_interest_list, '#StudentXMLFile.applications.application[i].page2.activities.activity[j].XmlText#')>
</cfloop>



<!----Loop through list and create a number list corosponding to interests---->
<cfset interestidlist = ''>
<cfloop list=#word_interest_list# index='k'>
	<cfquery name="get_interestid" datasource="mysql">
	select interestid
	from smg_interests
	where interest = '#k#'
	</cfquery>
<!----Appned List---->
	<cfset interestidlist = ListAppend(interestidlist, #get_interestid.interestid#)>
</cfloop>

<!----Update student record with list of interests---->
	<cfquery name="update_students_interests" datasource="mysql">
	update smg_students
	set interests = '#interestidlist#'
	where studentid = #client.studentid#
	</cfquery>
</Cfoutput>
	


	


