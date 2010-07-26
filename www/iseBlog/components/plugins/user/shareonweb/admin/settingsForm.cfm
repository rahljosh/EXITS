<cfoutput>
<cfset blog = request.blogManager.getBlog() />
<form method="post" action="#cgi.script_name#">
	<p>
		<label for="username">Addthis.com Username (Optional)</label>
		<span class="hint">You can get username from <a href="addthis.com">Addthis.com</a><br/>
		Username only used if you want to manage analytics on addthis.com</span>
		<span class="field">
		<input id="username" name="username" value="#variables.username#" size="30"/>
		</span>
	</p>
	<fieldset>
		<legend><input type="checkbox" name="shareLink" value="1" <cfif variables.shareLink EQ 1>checked="true"</cfif>/>Choose Bookmark & Sharing button</legend>
		<p>
			<span class="field">
				<input type="radio" name="buttonstyle" value="1" <cfif variables.buttonstyle EQ 1>checked="true"</cfif>/> <img src="#blog.Url#assets/plugins/shareonweb/button1.gif" border="0"/><br/>
				<input type="radio" name="buttonstyle" value="2" <cfif variables.buttonstyle EQ 2>checked="true"</cfif>/> <img src="#blog.Url#assets/plugins/shareonweb/button2.gif" border="0"/><br/>
				<input type="radio" name="buttonstyle" value="3" <cfif variables.buttonstyle EQ 3>checked="true"</cfif>/> <img src="#blog.Url#assets/plugins/shareonweb/button3.gif" border="0"/><br/>
				<input type="radio" name="buttonstyle" value="4" <cfif variables.buttonstyle EQ 4>checked="true"</cfif>/> <img src="#blog.Url#assets/plugins/shareonweb/button4.gif" border="0"/><br/>
				<input type="radio" name="buttonstyle" value="5" <cfif variables.buttonstyle EQ 5>checked="true"</cfif>/> I got custom code from Addthis.com<br/>
				<textarea id="shareonwebcode" name="shareonwebcode" rows="5" cols="70"><cfif buttonstyle EQ 5>#variables.shareonwebcode#</cfif></textarea>
			</span>
		</p>
	</fieldset>
	<fieldset>
		<legend><input type="checkbox" name="rssFeed" value="1" <cfif variables.rssFeed EQ 1>checked="true"</cfif>/>RSS Feed button</legend>
		<p>
			<span class="field">
				<input type="radio" name="rssbuttonstyle" value="1" <cfif variables.rssbuttonstyle EQ 1>checked="true"</cfif>/> <img src="#blog.Url#assets/plugins/shareonweb/rssbutton1.gif" border="0"/><br/>
				<input type="radio" name="rssbuttonstyle" value="2" <cfif variables.rssbuttonstyle EQ 2>checked="true"</cfif>/> <img src="#blog.Url#assets/plugins/shareonweb/rssbutton2.gif" border="0"/><br/>
				<input type="radio" name="rssbuttonstyle" value="3" <cfif variables.rssbuttonstyle EQ 3>checked="true"</cfif>/> <img src="#blog.Url#assets/plugins/shareonweb/rssbutton3.gif" border="0"/><br/>
				<input type="radio" name="rssbuttonstyle" value="4" <cfif variables.rssbuttonstyle EQ 4>checked="true"</cfif>/> <img src="#blog.Url#assets/plugins/shareonweb/rssbutton4.gif" border="0"/><br/>
				Feed URL :<input id="feedurl" name="feedurl" class="url" value="#variables.feedurl#" size="80"/>
			</span>
		</p>
	</fieldset>
	<fieldset>
		<legend><input type="checkbox" name="addThisSharebar" value="1" <cfif variables.addThisSharebar EQ 1>checked="true"</cfif>/>Add ShareBar on Blog</legend>
		<p>
			<label for="openSearchShortName">Choose Bookmark & Sharing button:</label>
			<span class="hint">Bar will display at bottom of window with search capiblity. Relace YOUR_BLOG_ADDRESS 
				with your blog URL. This bar is configurable as per your need. Visit http://www.addthis.com for more
				configuration details.
			</span>
			<span class="field">
				<textarea id="sidebarDiv" name="sidebarDiv" rows="5" cols="70">#variables.sidebarDiv#</textarea>
			</span>
		</p>
	</fieldset>
	<p class="actions">
	<input type="submit" class="primaryAction" value="Submit"/>
	<input type="hidden" value="event" name="action" />
	<input type="hidden" value="showshareOnWebSettings" name="event" />
	<input type="hidden" value="true" name="apply" />
	<input type="hidden" value="showshareOnWebSettings" name="selected" />
	</p>
</form>
</cfoutput>
