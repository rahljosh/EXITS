<cfif client.usertype gt 1>

<cfelse>


<!---
 PARAMETERLIST
 
 Action
   -ShowAll    (Default) Builds a list of all the logged in
               users, their page, and their last "Active"
               time.
  -ShowPage   Builds a list of all users "on the same page"
   -ShowDir    Builds a list of users in "this" folder
               (like for a forum maybe?)
 
 Display
   -Yes        (Default) Uses the "hard coded" display code
   -No         Stores the information in a "Request" scoped
               list: Request.MemberList
 --->

 
 <!---The tag parameters--->
 <cfparam name="Attributes.Action" default="ShowAll">
 <cfparam name="Attributes.Display" default="yes">
 
 <!---The main "Switch"--->
 <cfswitch Expression="#Attributes.Action#">
 
 <!---Build List of Users on the same page--->
   <cfcase value="ShowPage">
    <cfset Request.MemberList="">
    <cflock name="TrackMan" type="ReadOnly" timeout="10">
      <cfloop collection="#Application.Online#" item="ThisUser">
       <cfif Application.Online[ThisUser][2] IS CGI.CF_Template_Path>
         <cfset 
 Request.MemberList=ListAppend(Request.MemberList,ThisUser)>
       </cfif>
      </cfloop>
    </cflock>
   </cfcase>
 
 <!---Build List of Users in the same folder--->
   <cfcase value="ShowDir">
     <cfset Request.MemberList="">
     <cflock name="TrackMan" type="ReadOnly" timeout="10">
       <cfloop collection="#Application.Online#" item="ThisUser">
        <cfif GetDirectoryFromPath(Application.Online[ThisUser][2])
              IS
              GetDirectoryFromPath(CGI.CF_Template_Path)>
         <cfset 
 Request.MemberList=ListAppend(Request.MemberList,ThisUser)>
        </cfif>
       </cfloop>
     </cflock>
   </cfcase>
 
 <!---Default (all logged in users)--->
   <cfdefaultcase>
     <cfset Request.MemberList="">
     <cflock name="TrackMan" type="ReadOnly" timeout="10">
       <cfloop collection="#Application.Online#" item="ThisUser">
         <cfset 
 Request.MemberList=ListAppend(Request.MemberList,ThisUser)>
       </cfloop>
     </cflock>
   </cfdefaultcase>
 </cfswitch>
 
 
 <!---Display the information if Display="Yes"
      Obviously a little table formatting would go a
      long way here... This table is a little "simple".
      Some pretty colours perhaps?--->
 
 <cfif Attributes.Display is "Yes">
 To see users history, view there account information, then click on View History.

 <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Current Online Users</h2></td>
		<td width=17 background="pics/header_rightcap.gif"></td>
	</tr>
</table>
 
   <table border=0  width=100% class=section rules="rows">
   	<tr>
		<td>Name</td><td>Last Page Viewed</td><td>Last Page Viewed at</td>
	</tr>
     <cflock name="TrackMan" type="ReadOnly" timeout="20">
     <cfloop list="#Request.MemberList#" index="ThisUser">
       <cfoutput>
 
         <tr><td>
     #ThisUser#</td>
          <td>
         #Application.Online[ThisUser][2]#</td>
          <td>
         #TimeFormat(Application.Online[ThisUser][1])#
         #DateFormat(Application.Online[ThisUser][1])#
         </td></tr>
 
       </cfoutput>
     </cfloop>
     </cflock>
   </table>
 </cfif>
 <table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
 </cfif>

