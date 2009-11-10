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
 <cfparam name="Attributes.Display" default="No">
 
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
   <table border=2 rules="All">
     <cflock name="TrackMan" type="ReadOnly" timeout="20">
     <cfloop list="#Request.MemberList#" index="ThisUser">
       <cfoutput>
 
         <tr><td>
         <b>#ThisUser#</b>
           is currently viewing page
         <b>#Application.Online[ThisUser][2]#</b>
           and has been inactive since
         <b>#TimeFormat(Application.Online[ThisUser][1])#</b>
         <b>#DateFormat(Application.Online[ThisUser][1])#</b>
         </td></tr>
 
       </cfoutput>
     </cfloop>
     </cflock>
   </table>
 </cfif>