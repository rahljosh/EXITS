<cfsetting enablecfoutputonly="yes">
<!---

    Document:        /extensions/customtags/gui/auctiontimer.cfm
    Author:            Steve Withington | www.stephenwithington.com
    Creation Date:    August 15, 2008
    Copyright:        (c) 2008 Stephen Withington | www.stephenwithington.com
    
    Purpose:        Outputs an ebay-esque count down timer.

    Instructions:    Place this template in your custom tags folder. Simply call the custom tag using
                    whatever method you're comfortable with and pass in at least a valid date for the
                    ATTRIBUTES.dateEnd variable.

                    Accepts 2 ATTRIBUTES:
                    1) dateStart    (optional, DATETIME)
                    2) dateEnd        (optional, DATETIME) - typically passed in with a query DATETIME value.

                    Example Usage:    <cf_auctiontimer dateEnd="8/15/2008 9:40 AM">
                    
    
    Revision Log:    
    12/4/2008 - sjw - Added code to a) ensure the dateStart occurs prior to dateEnd and b) if dateStart has
    already passed, then adjust dateStart to now().
    05/14/2010 - sjw - Hopefully squashed an annoying bug with the 'hours2go' var.

--->
<cfsetting enablecfoutputonly="no">
<!--- if defined <style>'s haven't been output yet --->
<cfif NOT isDefined("REQUEST.localStyle")>
<style type="text/css">
<!--
.boldred { 
    font-weight: bold;
    color: #FF0000;
}
-->
</style>
<!--- remember the <style>'s have been output so we don't output it again --->
<cfset REQUEST.localStyle = "true" />
</cfif>
<cfsetting enablecfoutputonly="yes">
<cfparam name="ATTRIBUTES.dateStart" default="#now()#" />
<cfparam name="ATTRIBUTES.dateEnd" default="#now()#" />

<!--- I prefer to throw a friendly error message instead of using 'type' in the cfparams for this tag --->
<cfif NOT isValid("date", ATTRIBUTES.dateStart)>
    <cfthrow message="dateStart must be a valid DATE" detail="The value #ATTRIBUTES.dateStart# is not a valid DATE. For example, #dateformat(now(), 'mm/dd/yyyy')# #timeformat(now(), 'h:mm:ss tt')# is a valid DATETIME value." />
</cfif>
<cfif NOT isValid("date", ATTRIBUTES.dateEnd)>
    <cfthrow message="dateEnd must be a valid DATE" detail="The value #ATTRIBUTES.dateEnd# is not a valid DATE. For example, #dateformat(now(), 'mm/dd/yyyy')# #timeformat(now(), 'h:mm:ss tt')# is a valid DATETIME value." />
</cfif>

<!--- if the start date is greater than the end date, throw an error 
<cfset compareGivenDates = DateCompare(ATTRIBUTES.dateStart, ATTRIBUTES.dateEnd, "s")>
<cfif compareGivenDates eq 1>
    <cfthrow message="Ooops! dateStart must occur before dateEnd." detail="The value #ATTRIBUTES.dateStart# should be a valid DATE that occurs before #ATTRIBUTES.dateEnd#." />
</cfif>
--->
<!--- if the start date has already past, if so, then start date should be rightNow --->
<cfset rightNow = dateformat(now(), "mm/dd/yyyy") & " " & timeformat(now(), "hh:mm:ss tt") />
<cfset compareNow = DateCompare(rightNow, ATTRIBUTES.dateStart, "s") />
<cfswitch expression="#compareNow#">
    <cfcase value="-1">
        <cfthrow message="Bidding hasn't started yet!" detail="Whoa there buddy ... the bidding will open soon. Come back later, ok?" />
    </cfcase>
    <cfcase value="1">
        <cfset ATTRIBUTES.dateStart = rightNow />
    </cfcase>
</cfswitch>

<!--- scope the final return variable --->
<cfset returnTimeRemaining="" />

<cfset dateStart = dateformat(ATTRIBUTES.dateStart, "mm/dd/yyyy") & " " & timeformat(ATTRIBUTES.dateStart, "hh:mm:ss tt") />
<cfset dateEnd = dateformat(ATTRIBUTES.dateEnd, "mm/dd/yyyy") & " " & timeformat(ATTRIBUTES.dateEnd, "hh:mm:ss tt") />

<cfset hdif = Abs(DateDiff("h", dateEnd, dateStart)) />
<cfset ndif = Abs(DateDiff("n", dateEnd, dateStart)) />
<cfset sdif = Abs(DateDiff("s", dateEnd, dateStart)) />

<cfset years2go = Abs(DateDiff("yyyy", dateEnd, dateStart)) />
<cfset months2go = Abs(DateDiff("m", dateEnd, dateStart)) />
<cfset weeks2go = Abs(DateDiff("ww", dateEnd, dateStart)) />
<cfset days2go = Abs(DateDiff("d", dateEnd, dateStart)) />

<cfif datepart('h', now()) lt 12 or days2go eq 1>
    <cfset h = 'h' />
<cfelse>
    <cfset h = 'H' />
</cfif>
<cfset hours2go = TimeFormat(dateEnd-dateStart, h) />
<cfset min2go = TimeFormat("#dateEnd-dateStart#", "m") />
<cfset sec2go = TimeFormat("#dateEnd-dateStart#", "s") />

<!--- some modified calculations are needed if there is more than 1 month to go --->
<cfset newmonths = months2go-(years2go*12) />
<cfset tempDate = dateadd("m", months2go, ATTRIBUTES.dateStart) />
<cfset newweeks = Abs(DateDiff("ww", ATTRIBUTES.dateEnd, tempDate)) />
<cfset tempdays = Abs(DateDiff("d", ATTRIBUTES.dateEnd, tempDate)) />
<cfset newdays = tempdays-(newweeks*7) />

<!--- compare the dateStart to dateEnd down to the SECOND --->
<cfset comparison = DateCompare(dateStart, dateEnd, "s") />

<cfswitch expression="#comparison#">
    <!--- Time still remaining --->
    <cfcase value="-1">
        <!--- YEARS TO GO --->
        <cfif years2go GT 1>
            <cfset returnTimeRemaining = returnTimeRemaining & "#years2go#y #newmonths#m #newweeks#w #newdays#d #hours2go#h <!----#min2go#m #sec2go#s---->" />
        <!--- MONTHS TO GO --->
        <cfelseif months2go GT 1>
            <cfset returnTimeRemaining = returnTimeRemaining & "#months2go#m #newweeks#w #newdays#d #hours2go#h <!----#min2go#m #sec2go#s---->" />
        <!--- WEEKS TO GO --->
        <cfelseif weeks2go GT 1>
            <!---<cfset newdays = days2go-(weeks2go*7) />--->
            <cfset returnTimeRemaining = returnTimeRemaining & "#weeks2go#w #newdays#d #hours2go#h <!----#min2go#m #sec2go#s---->" />
        <!--- DAYS TO GO --->
        <cfelseif hdif GT 24>
            <cfset returnTimeRemaining = returnTimeRemaining & "#days2go#d #hours2go#h <!----#min2go#m #sec2go#s---->" />
        <!--- HOURS TO GO --->
        <cfelseif ndif GT 60>
            <cfset returnTimeRemaining = returnTimeRemaining & "#hours2go#h <!----#min2go#m #sec2go#s---->" />
        <!--- MINUTES TO GO --->
        <cfelseif sdif GT 60>
            <cfset returnTimeRemaining = returnTimeRemaining & "<span class=""boldred"">#min2go#m #sec2go#s</span>" />
        <!--- SECONDS TO GO --->
        <cfelseif sdif GT 01>
            <cfset returnTimeRemaining = returnTimeRemaining & "<span class=""boldred"">< 1m</span> <em>or #sec2go#s to be exact</em>" />
        <!--- TIME HAS ENDED --->
        <cfelse>
            <cfset returnTimeRemaining = "<strong>Pending...</strong>" />
    </cfif>
    </cfcase>
    <!--- Times are the same. --->
    <cfcase value="0">
        <cfset returnTimeRemaining = "<strong>Pending...</strong>" />
    </cfcase>
    <!--- Time has expired. --->
    <cfcase value="1">
        <cfset returnTimeRemaining = "<strong>Pending...</strong>" />
    </cfcase>
</cfswitch>

<!--- FINAL OUTPUT --->
<cfoutput>#returnTimeRemaining#</cfoutput>

<cfsetting enablecfoutputonly="no">