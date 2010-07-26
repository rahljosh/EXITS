<cfoutput>

<cfset f = getAssetPath() & "assets/">
<cfset p = GetDirectoryFromPath(ExpandPath(f)) & "tweet.css">
<cffile action="read" file="#p#" variable="s">

<form method="post" action="#cgi.script_name#">
	<fieldset>
		<legend>Tweet Settings</legend>

		<!--- title --->
		<p>
			<label for="title">Pod Title:</label>
			<span class="hint">Title to display over the tweets. Default is "Twitter Updates".</span>
			<span class="field">
				<input name="title" id="title" type="text" value="#getSetting('title')#" size="30" class="required" />
			</span>
		</p>

		<!--- loadingtext --->
		<p>
			<label for="counterLimit">Loading Text:</label>
			<span class="hint">Text to display while tweets are being loaded. Default is "loading tweets...".</span>
			<span class="field">
				<input name="loadingtext" id="loadingtext" type="text" value="#getSetting('loadingtext')#" size="30" />
			</span>
		</p>

		<!--- username --->
		<p>
			<label for="username">Username:</label>
			<span class="hint">Your Twitter username. Default is "seaofclouds".</span>
			<span class="field">
				<input name="username" id="username" type="text" value="#getSetting('username')#" size="30" class="required" />
			</span>
		</p>

		<!--- avatarsize --->
		<p>
			<label for="avatarsize">Avatar Size:</label>
			<span class="hint">Height and width of avatar (48px max). If left blank, avatar will not display. Default is "32".</span>
			<span class="field">
				<input name="avatarsize" id="avatarsize" type="text" value="#getSetting('avatarsize')#" size="10" />
			</span>
		</p>

		<!--- count --->
		<p>
			<label for="count">Tweet Count:</label>
			<span class="hint">Number of tweets to display. Default is "3".</span>
			<span class="field">
				<input name="count" id="count" type="text" value="#getSetting('count')#" size="10" class="required" />
			</span>
		</p>

		<!--- introtext --->
		<p>
			<label for="introtext">Intro:</label>
			<span class="hint">Text you want to display BEFORE your tweets. Default is "".</span>
			<span class="field">
				<input name="introtext" id="introtext" type="text" value="#getSetting('introtext')#" size="30" />
			</span>
		</p>

		<!--- outrotext --->
		<p>
			<label for="outrotext">Outro:</label>
			<span class="hint">Text you want to display AFTER your tweets. Default is "".</span>
			<span class="field">
				<input name="outrotext" id="outrotext" type="text" value="#getSetting('outrotext')#" size="30" />
			</span>
		</p>

		<!--- jointext --->
		<p>
			<label for="jointext">Connector:</label>
			<span class="hint">Optional text to display in between date and tweet. Set this to "auto" to use connector text strings below. Default is "".</span>
			<span class="field">
				<input name="jointext" id="jointext" type="text" value="#getSetting('jointext')#" size="30" />
			</span>
		</p>

		<!--- autojointextdefault --->
		<p>
			<label for="autojointextdefault">Non-Verb Connector:</label>
			<span class="hint">Optional text to display in between date and tweet for non-verbs. "dammit" would become "i said dammit". This is only used if connector is set to "auto". Default is "i said".</span>
			<span class="field">
				<input name="autojointextdefault" id="autojointextdefault" type="text" value="#getSetting('autojointextdefault')#" size="30" />
			</span>
		</p>

		<!--- autojointexted --->
		<p>
			<label for="autojointexted">Past Tense Connector:</label>
			<span class="hint">Optional text to display in between date and tweet for past tense. "surfed" would become "i surfed". This is only used if connector is set to "auto". Default is "i".</span>
			<span class="field">
				<input name="autojointexted" id="autojointexted" type="text" value="#getSetting('autojointexted')#" size="30" />
			</span>
		</p>

		<!--- autojointexting --->
		<p>
			<label for="autojointexting">Present Tense Connector:</label>
			<span class="hint">Optional text to display in between date and tweet for present tense. "surfing" would become "i am surfing". This is only used if connector is set to "auto". Default is "i am".</span>
			<span class="field">
				<input name="autojointexting" id="autojointexting" type="text" value="#getSetting('autojointexting')#" size="30" />
			</span>
		</p>

		<!--- autojointextreply --->
		<p>
			<label for="autojointextreply">Reply Connector:</label>
			<span class="hint">Optional text to display in between date and tweet for replies. If you reply to someones tweet with "yeah right" it would become "i replied to @someone with yeah right". This is only used if connector is set to "auto". Default is "i replied to".</span>
			<span class="field">
				<input name="autojointextreply" id="autojointextreply" type="text" value="#getSetting('autojointextreply')#" size="30" />
			</span>
		</p>

		<!--- autojointexturl --->
		<p>
			<label for="autojointexturl">URL Connector:</label>
			<span class="hint">Optional text to display in between date and tweet for URLs. If you tweet a URL it would become "i am looking at http://something.com". This is only used if connector is set to "auto". Default is "i am looking at".</span>
			<span class="field">
				<input name="autojointexturl" id="autojointexturl" type="text" value="#getSetting('autojointexturl')#" size="30" />
			</span>
		</p>

		<!--- query --->
		<p>
			<label for="query">Query Sttring:</label>
			<span class="hint">Optional search query. Default is "".</span>
			<span class="field">
				<input name="query" id="query" type="text" value="#getSetting('query')#" size="30"  />
			</span>
		</p>

		<!--- style --->
		<p>
			<label for="style">CSS Styles:</label>
			<span class="hint">CSS styles to use for the the tweets.</span>
			<span class="field">
				<textarea name="style" id="style" cols="80" rows="25">#s#</textarea>
			</span>
		</p>
	</fieldset>

	<p class="actions">
		<input type="submit" class="primaryAction" value="Submit" />
		<input type="hidden" value="event" name="action" />
		<input type="hidden" value="true" name="apply" />
		<input type="hidden" value="showTweetSettings" name="event" />
		<input type="hidden" value="tweet" name="selected" />
	</p>

</form>

</cfoutput>