#!/bin/bash

<<ABOUT_THIS_SCRIPT
-----------------------------------------------------------------------

	Written by:William Smith
	Professional Services Engineer
	Jamf
	bill@talkingmoose.net
	https://gist.github.com/talkingmoose/9faf50deaaefafa9a147e48ba39bb4b0
	Reference: https://developer.apple.com/documentation/devicemanagement/notifications/notificationsettingsitem

	Originally posted: October 5, 2019
	Last updated: October 16, 2019

	Purpose: Create configuration profiles to manage app notifications.
	Upload the configuration profile to Jamf Pro or save to your desktop.

	Instructions: Run the script with help, -h or --usage for help.

	Except where otherwise noted, this work is licensed under
	http://creativecommons.org/licenses/by/4.0/

	"Fortune makes promises to many, keeps them to none.
	Live for each day, live for the hours, since nothing is forever yours."

-----------------------------------------------------------------------
ABOUT_THIS_SCRIPT

# Jamf Pro URL and credentials
URL="https://jamfproserver.talkingmoose.net:8443"
userName="API-Editor"
password="P@55w0rd"

organizationName="Talking Moose Industries"

# -- set some variables for the rest of the script ----------------------------

# regular expression for "help" and "usage"
regHelp="^-?-?[Hh]([Ee][Ll][Pp])?|[Uu]([Ss][Aa][Gg][Ee])?$"

# regular expressions for "true" and "false"
regTrue="^[Tt]([Rr][Uu][Ee])?|[Yy]([Ee][Ss])?$"
regFalse="^[Ff]([Aa][Ll][Ss][Ee])?|[Nn]([Oo])?$"

# regular expressions for "upload" and "save"
regUpload="^[Uu]([Pp][Ll][Oo][Aa][Dd])?$"
regSave="^[Ss]([Aa][Vv][Ee])?$"
regBoth="^[Bb]([Oo][Tt][Hh])?$"

# regular expressions for "none", "banners" and "alerts"
regNone="^[Nn]([Oo][Nn][Ee])?$"
regBanners="^[Bb]([Aa][Nn][Nn][Ee][Rr][Ss])?$"
regAlerts="^[Aa]([Ll][Ee][Rr][Tt][Ss])?$"

# generate two UUIDs for configuration profile payload identifiers
PayloadUUID1=$(/usr/bin/uuidgen)
PayloadUUID2=$(/usr/bin/uuidgen)

appDicts=""

# -- display usage information or parse app path for information --------------

appPath="$1"

if [[ "$appPath" =~ ${regHelp} ]]; then
    echo
    echo "Manage App Notifications

Purpose:       Create configuration profiles to manage app notifications
               Upload the configuration profile to Jamf Pro or save to your desktop

Configuration: To upload to your Jamf Pro server, edit these lines before running the script.
               The API-Editor account needs the Create privilege for macOS Configuration Profiles in Jamf Pro

               URL=\"https://jamfproserver.talkingmoose.net:8443\"
               userName=\"API-Editor\"
               password=\"P@55w0rd\"

               organizationName=\"Talking Moose Industries\"

Usage:         \"$0\" [/path/to/application]

               Questions are followed by allowed responses with [default] responses in brackets.
               Responses are case insensitive and accept the first letter or entire word.
               Press return to accept the default response.

Example:       $ \"$0\"

               Path to managed app (drag app into this Terminal window): /Applications/FaceTime.app

               ...

               or

               $ \"$0\" /Applications/FaceTime.app

               Allow Notifications from FaceTime ( [Yes] No ): Yes

               FaceTime alert style ( None [Banners] Alerts ): A
               Show notifications on lock screen ( [Yes] No ): n
               Show in Notification Center ( [Yes] No ): true
               Badge app icon ( [Yes] No ):
               Play sound for notifications ( [Yes] No ): NO
               Critical Alerts Enabled ( Yes [No] ): FALSE

               Add another app ( [Yes] No ): n

               Upload to Jamf Pro or Save to Desktop? ( Both [Upload] Save ): U

               Your new Notifications configuration profile for FaceTime was uploaded to Jamf Pro and is ready for scoping.

               Would you like to view the profile now? ( [Yes] No ): yes"
    echo
    exit 0
else
    appBundleID=$(/usr/bin/defaults read "$appPath/Contents/Info.plist" CFBundleIdentifier 2>/dev/null)
    appExecutable=$(/usr/bin/defaults read "$appPath/Contents/Info.plist" CFBundleExecutable 2>/dev/null)
    appExecutableString=$(/usr/bin/sed -e 's/ /./g' <<<"$appExecutable")
fi

function getApp {

    # -- request path to managed app if no app path provided ----------------------

    while [[ "$appExecutable" = "" ]]; do
        echo
        read -p "Path to managed app (drag app into this Terminal window): " appPath
        appBundleID=$(/usr/bin/defaults read "$appPath/Contents/Info.plist" CFBundleIdentifier 2>/dev/null)
        appExecutable=$(/usr/bin/defaults read "$appPath/Contents/Info.plist" CFBundleExecutable 2>/dev/null)
        appExecutableString=$(/usr/bin/sed -e 's/ /./g' <<<"$appExecutable")
    done

}

function getNotificationsEnabled {

    # -- choose notificationsEnabled ----------------------------------------------

    while [[ ! "$notificationsEnabled" =~ ${regTrue} && ! "$notificationsEnabled" =~ ${regFalse} ]]; do
        echo
        read -p "Allow Notifications from $appExecutable ( [Yes] No ): " notificationsEnabled # true, false, yes or no; case insensitive, first letter accepted, return to accept default
        notificationsEnabled=${notificationsEnabled:-true}
    done

    if [[ "$notificationsEnabled" =~ ${regTrue} ]]; then
        notificationsEnabled="true"
    else
        notificationsEnabled="false"
    fi
}

function getAlertType {

    # -- choose alertType ---------------------------------------------------------

    while [[ ! "$alertType" =~ ${regNone} && ! "$alertType" =~ ${regBanners} && ! "$alertType" =~ ${regAlerts} && "$notificationsEnabled" = "true" ]]; do
        echo
        read -p "$appExecutable alert style ( None [Banners] Alerts ): " alertType # none, banners or alerts, case insensitive, first letter accepted, return to accept default
        alertType=${alertType:-Banners}
    done

    if [[ "$alertType" =~ ${regNone} ]]; then
        alertType="0"
    elif [[ "$alertType" =~ ${regBanners} ]]; then
        alertType="1"
    else
        alertType="2"
    fi
}

function getShowInLockScreen {

    # -- choose showInLockScreen --------------------------------------------------

    while [[ ! "$showInLockScreen" =~ ${regTrue} && ! "$showInLockScreen" =~ ${regFalse} && "$notificationsEnabled" = "true" ]]; do
        read -p "Show notifications on lock screen ( [Yes] No ): " showInLockScreen # true, false, yes or no; case insensitive, first letter accepted, return to accept default
        showInLockScreen=${showInLockScreen:-true}
    done

    if [[ "$showInLockScreen" =~ ${regTrue} ]]; then
        showInLockScreen="true"
    else
        showInLockScreen="false"
    fi
}

function getShowInNotificationCenter {

    # -- choose showInNotificationCenter ------------------------------------------

    while [[ ! "$showInNotificationCenter" =~ ${regTrue} && ! "$showInNotificationCenter" =~ ${regFalse} && "$notificationsEnabled" = "true" ]]; do
        read -p "Show in Notification Center ( [Yes] No ): " showInNotificationCenter # true, false, yes or no; case insensitive, first letter accepted, return to accept default
        showInNotificationCenter=${showInNotificationCenter:-true}
    done

    if [[ "$showInNotificationCenter" =~ ${regTrue} ]]; then
        showInNotificationCenter="true"
    else
        showInNotificationCenter="false"
    fi
}

function getBadgesEnabled {

    # -- choose badgesEnabled -----------------------------------------------------

    while [[ ! "$badgesEnabled" =~ ${regTrue} && ! "$badgesEnabled" =~ ${regFalse} && "$notificationsEnabled" = "true" ]]; do
        read -p "Badge app icon ( [Yes] No ): " badgesEnabled # true, false, yes or no; case insensitive, first letter accepted, return to accept default
        badgesEnabled=${badgesEnabled:-true}
    done

    if [[ "$badgesEnabled" =~ ${regTrue} ]]; then
        badgesEnabled="true"
    else
        badgesEnabled="false"
    fi
}

function getSoundsEnabled {

    # -- choose soundsEnabled -----------------------------------------------------

    while [[ ! "$soundsEnabled" =~ ${regTrue} && ! "$soundsEnabled" =~ ${regFalse} && "$notificationsEnabled" = "true" ]]; do
        read -p "Play sound for notifications ( [Yes] No ): " soundsEnabled # true, false, yes or no; case insensitive, first letter accepted, return to accept default
        soundsEnabled=${soundsEnabled:-true}
    done

    if [[ "$soundsEnabled" =~ ${regTrue} ]]; then
        soundsEnabled="true"
    else
        soundsEnabled="false"
    fi
}

function getCriticalAlertsEnabled {

    # -- choose criticalAlertsEnabled (does not appear in GUI) --------------------

    while [[ ! "$criticalAlertsEnabled" =~ ${regTrue} && ! "$criticalAlertsEnabled" =~ ${regFalse} && "$notificationsEnabled" = "true" ]]; do
        read -p "Critical Alerts Enabled ( Yes [No] ): " criticalAlertsEnabled # true, false, yes or no; case insensitive, first letter accepted, return to accept default
        criticalAlertsEnabled=${criticalAlertsEnabled:-false}
    done

    if [[ "$criticalAlertsEnabled" =~ ${regTrue} ]]; then
        criticalAlertsEnabled="true"
    else
        criticalAlertsEnabled="false"
    fi
}

function uploadProfile {

    # upload to Jamf Pro
    profilePayload=$(/usr/bin/xmllint --noblanks - <<<"$mobileconfig" | /usr/bin/sed -e 's/</\&lt;/g' -e 's/>/\&gt;/g')
    profileXML="<os_x_configuration_profile>
	  <general>
		<name>Managed Notifications</name>
		<description>
		  <string>Manage Notifications settings.</string>
		</description>
		<site/>
		<category/>
		<distribution_method>Install Automatically</distribution_method>
		<user_removable>false</user_removable>
		<level>computer</level>
		<uuid>$PayloadUUID2</uuid>
		<payloads>$profilePayload</payloads>
	  </general>
	</os_x_configuration_profile>"

    # flatten the XML for the configuration profile to upload to Jamf Pro
    flatXML=$(/usr/bin/xmllint --noblanks - <<<"$profileXML")

    # upload and create configuration profile
    result=$(/usr/bin/curl "$URL/JSSResource/osxconfigurationprofiles/id/0" \
        --silent \
        --insecure \
        --write-out "%{http_code}" \
        --user "$userName":"$password" \
        --header "Content-Type: text/xml" \
        --request POST \
        --data "$flatXML" 2>&1)

    # evaluate HTTP status code
    resultStatus=${result: -3}

    if [[ $resultStatus = 201 ]]; then # 201 is successful
        echo
        echo "Your new Notifications configuration profile for $appExecutable was uploaded to Jamf Pro and is ready for scoping."

        # -- offer to open configuration profile in Jamf Pro ------------------

        while [[ ! "$openProfile" =~ ${regTrue} && ! "$openProfile" =~ ${regFalse} ]]; do
            echo
            read -p "Would you like to view the profile now? ( [Yes] No ): " openProfile # true, false, yes or no; case insensitive, first letter accepted, return to accept default
            openProfile=${openProfile:-true}
        done

        if [[ "$openProfile" =~ ${regTrue} ]]; then
            resultXML=${result%???}
            profileID=$(/usr/bin/xpath '/os_x_configuration_profile/id/text()' <<<"$resultXML" 2>/dev/null)
            /usr/bin/open "$URL/OSXConfigurationProfiles.html?id=$profileID&o=r"
        fi

    else
        echo
        echo "Unable to upload your new Notifications configuration profile for $appExecutable [Response code: $resultStatus]."
        echo
        echo "CODE	DESCRIPTION
	000	Check server URL in script
	200	Request successful
	201	Request to create or update object successful
	400	Bad request. Verify the syntax of the request specifically the XML body.
	401	Authentication failed. Verify the credentials being used for the request.
	403	Invalid permissions. Verify the account being used has the proper permissions for the object/resource you are trying to access.
	404	Object/resource not found. Verify the URL path is correct.
	409	Conflict. Delete existing profile \"Set $appExecutable notifications\" first.
	500	Internal server error. Retry the request or contact Jamf support if the error is persistent."
    fi
}

function saveProfile {
    echo
    echo "$mobileconfig" >"$HOME/Desktop/Managed Notifications.mobileconfig"
    echo "Your new Notifications configuration profile was saved to your desktop."
}

# -- ask for another app --------------------------------------------------

while [[ ! "$addApp" =~ ${regFalse} ]]; do
    getApp

    if [[ $appList = *"$appBundleID"* ]]; then
        echo
        echo "This app is already added to the list."
    else
        getNotificationsEnabled
        getAlertType
        getShowInLockScreen
        getNotificationsEnabled
        getShowInNotificationCenter
        getBadgesEnabled
        getSoundsEnabled
        getCriticalAlertsEnabled

        appDicts="$appDicts
					<dict>
						<key>AlertType</key>
						<integer>$alertType</integer>
						<key>BadgesEnabled</key>
						<$badgesEnabled/>
						<key>BundleIdentifier</key>
						<string>$appBundleID</string>
						<key>CriticalAlertEnabled</key>
						<$criticalAlertsEnabled/>
						<key>NotificationsEnabled</key>
						<$notificationsEnabled/>
						<key>ShowInLockScreen</key>
						<$showInLockScreen/>
						<key>ShowInNotificationCenter</key>
						<$showInNotificationCenter/>
						<key>SoundsEnabled</key>
						<$soundsEnabled/>
					</dict>"

        appList="$appList  $appBundleID"
    fi

    addApp=""

    while [[ ! "$addApp" =~ ${regTrue} && ! "$addApp" =~ ${regFalse} ]]; do
        echo
        read -p "Add another app ( [Yes] No ): " addApp # true, false, yes or no; case insensitive, first letter accepted, return to accept default
        addApp=${addApp:-true}
    done

    if [[ "$addApp" =~ ${regTrue} ]]; then
        addApp="true"
        appExecutable=""
        notificationsEnabled=""
        alertType=""
        showInLockScreen=""
        notificationsEnabled=""
        showInNotificationCenter=""
        badgesEnabled=""
        soundsEnabled=""
        criticalAlertsEnabled=""
    else
        addApp="false"
    fi
done

# -- use this template XML to create a .mobileconfig file --------------------------

mobileconfig="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>PayloadContent</key>
	<array>
		<dict>
			<key>NotificationSettings</key>
			<array>$appDicts
			</array>
			<key>PayloadDescription</key>
			<string>Managed Notifications</string>
			<key>PayloadDisplayName</key>
			<string>Managed Notifications</string>
			<key>PayloadEnabled</key>
			<true/>
			<key>PayloadIdentifier</key>
			<string>$PayloadUUID1</string>
			<key>PayloadOrganization</key>
			<string>$organizationName</string>
			<key>PayloadType</key>
			<string>com.apple.notificationsettings</string>
			<key>PayloadUUID</key>
			<string>$PayloadUUID1</string>
			<key>PayloadVersion</key>
			<integer>1</integer>
		</dict>
	</array>
	<key>PayloadDescription</key>
	<string>Managed Notifications</string>
	<key>PayloadDisplayName</key>
	<string>Managed Notifications</string>
    <key>PayloadEnabled</key>
    <true/>
	<key>PayloadIdentifier</key>
	<string>$PayloadUUID2</string>
	<key>PayloadOrganization</key>
	<string>$organizationName</string>
	<key>PayloadRemovalDisallowed</key>
	<false/>
	<key>PayloadScope</key>
	<string>System</string>
	<key>PayloadType</key>
	<string>Configuration</string>
	<key>PayloadUUID</key>
	<string>$PayloadUUID2</string>
	<key>PayloadVersion</key>
	<integer>1</integer>
</dict>
</plist>"

# -- choose to upload to Jamf Pro or save to Desktop --------------------------

while [[ ! "$chooseOutput" =~ ${regUpload} && ! "$chooseOutput" =~ ${regSave} && ! "$chooseOutput" =~ ${regBoth} ]]; do
    echo
    read -p "Upload to Jamf Pro or Save to Desktop? ( Both [Upload] Save ): " chooseOutput # upload, save or both; case insensitive, first letter accepted, return to accept default
    chooseOutput=${chooseOutput:-upload}
done

if [[ "$chooseOutput" =~ ${regUpload} ]]; then
    uploadProfile
elif [[ "$chooseOutput" =~ ${regSave} ]]; then
    saveProfile
else
    uploadProfile
    saveProfile
fi

exit 0
