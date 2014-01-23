<!--- ------------------------------------------------------------------------- ----
	
	File:		messageQueue.cfc
	Author:		Marcus Melo
	Date:		June 25, 2010
	Desc:		This holds the functions used to store a list of messages.

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="pageMessages" 
	output="no"
	hint="Stores a list of messages">

	
	<!--- Set up the properties of this component --->
	<cfproperty 
		name="My" 
		type="struct" 
		hint="A structure containing internal variables for this message queue" 
		/>
	
	<cfproperty 
		name="My.Messages" 
		type="array" 
		hint="Keeps track of the messages" 
		/>
		
	<cfscript>
		// Instance variables
		VARIABLES.My = StructNew();
		VARIABLES.My.Messages = ArrayNew(1);
	</cfscript>
	

	<!--- BEGIN: Public Methods ----------------------------------------------- --->
	
	
	<!--- Returns and initialized message queue object --->
	<cffunction name="Init" access="public" returntype="MessageQueue" output="no" hint="Returns an initialized message queue object">
		
        <cfscript>
			// Set up the variables
			VARIABLES.My = StructNew();
			VARIABLES.My.Messages = ArrayNew(1);
		
			// Return this object
        	return this;
        </cfscript>
		
	</cffunction>
	
	
	<!--- Adds a message to the list --->
	<cffunction name="Add" access="public" returntype="void" output="no" hint="Adds a message to the message queue object">
		<cfargument name="Message" type="string" required="yes" />

        <cfscript>
			// Add the message to the array 
			ArrayAppend(VARIABLES.My.Messages, ARGUMENTS.Message);
		</cfscript>			
		
	</cffunction>
		
		
	<!--- Clears the messages --->
	<cffunction name="Clear" access="public" returntype="void" output="no" hint="Clears the message queue of all its messages">
		
        <cfscript>
			// Clear the message array
			ArrayClear(VARIABLES.My.Messages);
		</cfscript>			

	</cffunction>
	
	
	<!--- Returns the collection of messages --->
	<cffunction name="GetCollection" access="public" returntype="array" output="no" hint="Returns the collection of messages">

        <cfscript>
			// Returns Messages
			return VARIABLES.My.Messages;
		</cfscript>			

	</cffunction>
	
	
	<!--- Gets the number of messages --->
	<cffunction name="Length" access="public" returntype="numeric" output="no" hint="Returns the number of messages">
		
        <cfscript>
			return ArrayLen(VARIABLES.My.Messages);
		</cfscript>			
        
	</cffunction>
	
</cfcomponent>