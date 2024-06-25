#Requires -RunAsAdministrator
#Requires -Version 7.3

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[string[]]
	$Functions
)

Clear-Host

$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 11 v6.6.7 (PowerShell 7) | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) farag, Inestic & lowl1f3, 2014$([System.Char]0x2013)2024"

Remove-Module -Name Sophia -Force -ErrorAction Ignore

# PowerShell 7 doesn't load en-us localization automatically if there is no localization folder in user's language which is determined by $PSUICulture
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-localizeddata?view=powershell-7.3
# https://github.com/PowerShell/PowerShell/pull/19896
try
{
	Import-LocalizedData -BindingVariable Global:Localization -UICulture $PSUICulture -BaseDirectory $PSScriptRoot\Localizations -FileName Sophia -ErrorAction Stop
}
catch
{
	Import-LocalizedData -BindingVariable Global:Localization -UICulture en-US -BaseDirectory $PSScriptRoot\Localizations -FileName Sophia
}

# Check whether script is not running via PowerShell (x86)
try
{
	Import-Module -Name $PSScriptRoot\Manifest\Sophia.psd1 -PassThru -Force -ErrorAction Stop
}
catch [System.InvalidOperationException]
{
	Write-Warning -Message $Localization.PowerShellx86Warning

	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

	exit
}

<#
	.SYNOPSIS
	Run the script by specifying functions as an argument
	Запустить скрипт, указав в качестве аргумента функции

	.EXAMPLE
	.\Sophia.ps1 -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

	.NOTES
	Use commas to separate funtions
	Разделяйте функции запятыми
#>
if ($Functions)
{
	Invoke-Command -ScriptBlock {InitialActions}

	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}

	# The "PostActions" and "Errors" functions will be executed at the end
	Invoke-Command -ScriptBlock {PostActions; Errors}

	exit
}







#region Protection

# Obligatorische Kontrollen. Um die Warnung bei der Einrichtung der Voreinstellungsdatei zu deaktivieren, löschen Sie das Argument "-Warning".
InitialActions -Warning

# Aktiviert die Protokollierung der Skriptoperationen. Das Protokoll wird in den Skriptordner geschrieben. Um die Protokollierung zu beenden, schließen Sie die Konsole oder geben Sie "Stop-Transcript" ein.
# Logging

# Erstellt einen Wiederherstellungspunkt.
CreateRestorePoint

#endregion Protection


#region Privacy & Telemetry

# Deaktiviert den Dienst "Connected User Experiences and Telemetry" (DiagTrack), und blockiert die Verbindung für den ausgehenden Verkehr des Unified Telemetry Client. Das Deaktivieren des Dienstes "Benutzererfahrungen und Telemetrie im verbundenen Modus" (DiagTrack) kann dazu führen, dass Sie keine Xbox-Erfolge mehr erhalten können, wirkt sich auf Feedback Hub aus, wirkt sich auf Feedback Hub aus.
DiagTrackService -Disable

# Aktivieren Sie den Dienst "Connected User Experiences and Telemetry" (DiagTrack), und erlauben Sie die Verbindung für den ausgehenden Datenverkehr des Unified Telemetry Client (Standardeinstellung).
# DiagTrackService -Enable

# Setzt die Diagnosedatenerfassung auf ein Minimum.
DiagnosticDataLevel -Minimal

# Setzt die Diagnosedatenerfassung auf Standard (Standardeinstellung).
# DiagnosticDataLevel -Default

# Deaktiviert die Windows-Fehlerberichterstattung.
ErrorReporting -Disable

# Aktiviert die Windows-Fehlerberichterstattung (Standardeinstellung).
# ErrorReporting -Enable

# Ändert die Feedbackfrequenz auf "Nie".
FeedbackFrequency -Never

# Ändert die Rückmeldefrequenz auf "Automatisch" (Standardeinstellung).
# FeedbackFrequency -Automatically

# Deaktiviert die geplanten Aufgaben zur Diagnoseverfolgung.
ScheduledTasks -Disable

# Aktiviert die Diagnoseverfolgung für geplante Aufgaben (Standardeinstellung).
# ScheduledTasks -Enable

# Verwendet keine Anmeldeinformationen, um die Einrichtung des Geräts nach einer Aktualisierung automatisch abzuschließen.
SigninInfo -Disable

# Verwendet Anmeldeinformationen, um die Einrichtung des Geräts nach einer Aktualisierung automatisch abzuschließen (Standardeinstellung).
# SigninInfo -Enable

# Erlaubt Webseiten nicht, lokal relevante Inhalte durch Zugriff auf die Sprachliste bereitzustellen.
# LanguageListAccess -Disable

# Erlaubt Webseiten, lokale Informationen durch Zugriff auf die Sprachliste bereitzustellen (Standardeinstellung).
LanguageListAccess -Enable

# Erlaubt Apps nicht die Verwendung von Werbe-IDs.
AdvertisingID -Disable

# Erlaubt Apps die Verwendung von Werbe-IDs (Standardeinstellung).
# AdvertisingID -Enable

# Blendet Windows-Willkommenserfahrungen nach Updates und gelegentlich bei der Anmeldung aus, um die neuen und vorgeschlagenen Funktionen hervorzuheben.
WindowsWelcomeExperience -Hide

# Zeigt Windows-Willkommenserfahrungen nach Updates und gelegentlich bei der Anmeldung an, um hervorzuheben, was neu ist und vorgeschlagen wird (Standardeinstellung).
# WindowsWelcomeExperience -Show

# Erhält Tipps, Hinweise und Ratschläge zur Verwendung von Windows (Standardeinstellung).
# WindowsTips -Enable

# Erhält keine Tipps, Hinweise und Ratschläge zur Verwendung von Windows.
WindowsTips -Disable

# Blendet vorgeschlagene Inhalte in der Einstellungs-App aus.
SettingsSuggestedContent -Hide

# Zeigt vorgeschlagene Inhalte in der Einstellungs-App an (Standardeinstellung).
# SettingsSuggestedContent -Show

# Deaktiviert die automatische Installation der empfohlenen Apps.
AppsSilentInstalling -Disable

# Aktiviert die automatische Installation der empfohlenen Apps (Standardeinstellung).
# AppsSilentInstalling -Enable

# Erhält keine Vorschläge, wie das Gerät fertig eingerichtet werden kann, um Windows optimal zu nutzen.
WhatsNewInWindows -Disable

# Erhält Vorschläge, wie das Gerät fertig eingerichtet werden kann, um Windows optimal zu nutzen (Standardeinstellung).
# WhatsNewInWindows -Enable

# Erlaubt Microsoft nicht, auf Grundlage der gewählten Einstellung für Diagnosedaten maßgeschneiderte Erfahrungen anzubieten.
TailoredExperiences -Disable

# Erlaubt Microsoft, auf Grundlage der gewählten Einstellung für Diagnosedaten maßgeschneiderte Erfahrungen anzubieten (Standardeinstellung).
# TailoredExperiences -Enable

# Deaktiviert die Bing-Suche im Startmenü.
BingSearch -Disable

# Aktiviert die Bing-Suche im Startmenü (Standardeinstellung).
# BingSearch -Enable

# Zeigen Sie im Startmenü keine Empfehlungen für Tipps, Verknüpfungen, neue Anwendungen und mehr an.
StartRecommendationsTips -Hide

# Anzeigen von Empfehlungen für Tipps, Verknüpfungen, neue Anwendungen und mehr im Startmenü (Standardeinstellung).
# StartRecommendationsTips -Show

# Keine Microsoft-Konto-Benachrichtigungen im Startmenü im Startmenü anzeigen.
StartAccountNotifications -Hide

# Anzeigen von Microsoft-Konto-Benachrichtigungen im Startmenü im Startmenü. (Standardeinstellung).
# StartAccountNotifications -Show

#endregion Privacy & Telemetry


#region UI & Personalization

# Zeigt das Symbol "Dieser PC" auf dem Desktop an.
# ThisPC -Show

# Blendet das Symbol "Dieser PC" auf dem Desktop aus (Standardeinstellung).
ThisPC -Hide

# Verwendet keine Kontrollkästchen für Elemente.
# CheckBoxes -Disable

# Verwendet Kontrollkästchen (Standardeinstellung).
CheckBoxes -Enable

# Zeigt versteckte Dateien, Ordner und Laufwerke an.
HiddenItems -Enable

# Zeigt versteckte Dateien, Ordner und Laufwerke nicht an (Standardeinstellung).
# HiddenItems -Disable

# Zeigt Dateinamenerweiterungen an.
FileExtensions -Show

# Blendet Dateinamenerweiterungen aus (Standardeinstellung).
# FileExtensions -Hide

# Zeigt Konflikte beim Zusammenführen von Ordnern an.
MergeConflicts -Show

# Blendet Konflikte beim Zusammenführen von Ordnern aus (Standardeinstellung).
# MergeConflicts -Hide

# Öffnet den Datei-Explorer mit "Dieser PC".
OpenFileExplorerTo -ThisPC

# Öffnet den Datei-Explorer mit Schnellzugriff (Standardeinstellung).
# OpenFileExplorerTo -QuickAccess

# Deaktiviert den Kompaktmodus des Datei-Explorers (Standardeinstellung).
FileExplorerCompactMode -Disable

# Aktiviert den Kompaktmodus des Datei-Explorers.
# FileExplorerCompactMode -Enable

# Zeigt keine Synchronisationsanbieter-Benachrichtigungen im Explorer an.
OneDriveFileExplorerAd -Hide

# Zeigt Synchronisationsanbieter-Benachrichtigungen im Explorer an (Standardeinstellung).
# OneDriveFileExplorerAd -Show

# Zeigt beim Anbringen eines Fensters nicht an, was daneben angebracht werden kann.
SnapAssist -Disable

# Zeigt beim Anbringen eines Fensters an, was daneben angebracht werden kann (Standardeinstellung).
# SnapAssist -Enable

# Zeigt das Dialogfeld für die Dateiübertragung im detaillierten Modus an.
FileTransferDialog -Detailed

# Zeigt das Dialogfeld für die Dateiübertragung im Kompaktmodus an (Standardeinstellung).
# FileTransferDialog -Compact

# Zeigt eine Bestätigung beim Löschen von Dateien aus dem Papierkorb an.
RecycleBinDeleteConfirmation -Enable

# Zeigt keine Bestätigung beim Löschen von Dateien aus dem Papierkorb an (Standardeinstellung).
# RecycleBinDeleteConfirmation -Disable

# Blendet zuletzt verwendete Dateien im Schnellzugriff aus.
QuickAccessRecentFiles -Hide

# Zeigt zuletzt verwendete Dateien im Schnellzugriff an (Standardeinstellung).
# QuickAccessRecentFiles -Show

# Blendet häufig verwendete Ordner im Schnellzugriff aus.
QuickAccessFrequentFolders -Hide

# Zeigt häufig verwendete Ordner im Schnellzugriff an (Standardeinstellung).
# QuickAccessFrequentFolders -Show

# Stellt die Ausrichtung der Taskleiste auf links ein.
# TaskbarAlignment -Left

# Stellt die Ausrichtung der Taskleiste auf die Mitte ein (Standardeinstellung).
TaskbarAlignment -Center

# Blendet das Widgets-Symbol in der Taskleiste aus.
# TaskbarWidgets -Hide

# Zeigt das Widgets-Symbol in der Taskleiste an (Standardeinstellung).
TaskbarWidgets -Show

# Blendet die Suchschaltfläche in der Taskleiste aus.
TaskbarSearch -Hide

# Zeigt das Suchsymbol in der Taskleiste an.
# TaskbarSearch -SearchIcon

# Zeigt das Suchsymbol und das Label in der Taskleiste an.
# TaskbarSearch -SearchIconLabel

# Zeigt das Suchfeld in der Taskleiste an (Standardeinstellung).
# TaskbarSearch -SearchBox

# Suchhighlights ausblenden.
SearchHighlights -Hide

# Suchhighlights anzeigen (Standardeinstellung).
# SearchHighlights -Show

# Ausblenden der Schaltfläche Copilot in der Taskleiste.
CopilotButton -Hide

# Zeigen Sie die Schaltfläche Copilot in der Taskleiste an (Standardeinstellung).
# CopilotButton -Show

# Blendet die Schaltfläche "Aufgabenansicht" in der Taskleiste aus.
TaskViewButton -Hide

# Zeigt die Schaltfläche "Aufgabenansicht" in der Taskleiste an (Standardeinstellung).
# TaskViewButton -Show

# Blenden Sie das Chat-Symbol (Microsoft Teams) in der Taskleiste aus und verhindern Sie, dass Microsoft Teams für neue Benutzer installiert wird.
PreventTeamsInstallation -Enable

# Zeigen Sie das Chat-Symbol (Microsoft Teams) in der Taskleiste an und entfernen Sie die Sperre für die Installation von Microsoft Teams für neue Benutzer (Standardeinstellung).
# PreventTeamsInstallation -Disable

# Zeigt Sekunden auf der Taskleistenuhr an.
# SecondsInSystemClock -Show

# Blendet Sekunden auf der Taskleistenuhr aus (Standardeinstellung).
SecondsInSystemClock -Hide

# Kombinieren Sie Schaltflächen in der Taskleiste und blenden Sie Beschriftungen immer aus. (default value).
# TaskbarCombine -Always

# Taskleistenschaltflächen zusammenfassen und Beschriftungen ausblenden, wenn die Taskleiste voll ist..
# TaskbarCombine -Full

# Kombinieren Sie die Schaltflächen der Taskleiste und blenden Sie die Beschriftungen nicht aus..
# TaskbarCombine -Never

# Die Verknüpfungen "Microsoft Edge", "Microsoft Store" oder "Mail" von der Taskleiste lösen.
UnpinTaskbarShortcuts -Shortcuts Edge, Store

# Anzeigen der Symbole der Systemsteuerung durch "Große Symbole".
ControlPanelView -LargeIcons

# Anzeige der Symbole der Systemsteuerung durch "Kleine Symbole".
# ControlPanelView -SmallIcons

# Anzeigen der Symbole der Systemsteuerung nach "Kategorie" (Standardeinstellung).
# ControlPanelView -Category

# Den Windows-Standard-Farbmodus auf dunkel einstellen.
WindowsColorMode -Dark

# Den Windows-Standard-Farbmodus auf hell setzen (Standardeinstellung).
# WindowsColorMode -Light

# Den Standardfarbmodus der Anwendung auf dunkel einstellen.
AppColorMode -Dark

# Den Standard-Anwendungsfarbmodus auf Hell setzen (Standardeinstellung).
# AppColorMode -Light

# Animation zur Erstanmeldung nach dem Upgrade ausblenden.
# FirstLogonAnimation -Disable

# Animation zur ersten Anmeldung des Benutzers nach dem Upgrade anzeigen (Standardeinstellung).
FirstLogonAnimation -Enable

# Setzt den Qualitätsfaktor der JPEG-Desktop-Hintergründe auf Maximum.
JPEGWallpapersQuality -Max

# Setzt den Qualitätsfaktor der JPEG-Desktop-Hintergründe auf Standard (Standardeinstellung).
# JPEGWallpapersQuality -Default

# Das Suffix "-Verknüpfung" nicht an den Dateinamen der erstellten Verknüpfungen anhängen.
ShortcutsSuffix -Disable

# Das Suffix "-Verknüpfung" an den Dateinamen der erstellten Verknüpfungen anhängen (Standardeinstellung).
# ShortcutsSuffix -Enable

# Verwenden der Schaltfläche Bildschirm drucken(druck s-abf), um das Snipping Tool zu starten.
PrtScnSnippingTool -Enable

# Die Schaltfläche Bildschirm drucken(druck s-abf) nicht zum Öffnen vom Snipping Tool verwenden (Standardeinstellung).
# PrtScnSnippingTool -Disable

# Verwendet nicht für jedes Anwendungsfenster eine andere Eingabemethode (Standardeinstellung).
# AppsLanguageSwitch -Disable

# Erlaubt die Verwendung einer anderen Eingabemethode für jedes Anwendungsfenster.
AppsLanguageSwitch -Enable

# Minimiert nicht alle anderen Fenster, wenn die Titelleiste eines Fensters gegriffen und geschüttelt wird (Standardeinstellung).
AeroShaking -Enable

# Minimiert alle anderen Fenster, wenn die Titelleiste eines Fensters gegriffen und geschüttelt wird.
# AeroShaking -Disable

# Standard-Cursor einstellen.
Cursors -Default

# Lädt und installiert die kostenlosen dunklen "Windows 11 Cursors Concept v2" Cursors von Jepri Creations.
# Cursors -Dark

# Lädt und installiert die kostenlosen leichten "Windows 11 Cursors Concept v2" Cursors von Jepri Creations.
# Cursors -Light

# Gruppieren Sie keine Dateien und Ordner im Ordner "Downloads".
# FolderGroupBy -None

# Gruppieren Sie Dateien und Ordner im Ordner "Downloads" nach "Änderungsdatum".
FolderGroupBy -Default

# Den Navigatiosbereich des Explorers(Linker Abschnitt) nicht auf den aktuellen Ordner erweitern (aufklappen) (Standardeinstellung).
# NavigationPaneExpand -Disable

# Der Navigationsbereich des Explorers(Linker Abschnitt) wird auf den aktuellen Ordner erweitert (aufgeklappt).
NavigationPaneExpand -Enable

#endregion UI & Personalization


#region OneDrive

# OneDrive deinstallieren. Der OneDrive-Benutzerordner wird nicht entfernt.
# OneDrive -Uninstall

# OneDrive 64-bit installieren.
# OneDrive -Install

# Installieren Sie OneDrive 64-bit für alle Benutzer in %ProgramFiles%. Je nachdem welches Installationsprogramm ausgelöst wird, 64bit oder 32bit.
# OneDrive -Install -AllUsers

#endregion OneDrive


#region System

# Speicheroptimierung einschalten.
StorageSense -Enable

# Speicheroptimierung ausschalten (Standardeinstellung).
# StorageSense -Disable

# Speicheroptimierung einmal im Monat ausführen.
StorageSenseFrequency -Month

# Speicheroptimierung bei geringem freien Speicherplatz ausführen (Standardeinstellung).
# StorageSenseFrequency -Default

# Temporäre Dateien löschen, die von Anwendungen nicht verwendet werden (Standardeinstellung).
StorageSenseTempFiles -Enable

# Lösche keine temporären Dateien, die von Anwendungen nicht verwendet werden.
# StorageSenseTempFiles -Disable

# Deaktiviert den Ruhezustand. Es wird nicht empfohlen, die Funktion für Laptops zu deaktivieren.
# Hibernation -Disable

# Ruhezustand einschalten (Standardeinstellung).
Hibernation -Enable

# Setzt den Pfad der Umgebungsvariablen %TEMP% auf %SystemDrive%\Temp.
# TempFolder -SystemDrive

# Setzt den Pfad der Umgebungsvariablen %TEMP% auf %LOCALAPPDATA%\Temp (Standardeinstellung).
TempFolder -Default

# Deaktiviert die Windows-Pfadbegrenzung auf 260 Zeichen.
# Win32LongPathLimit -Disable

# Aktiviert die Windows-Pfadbegrenzung auf 260 Zeichen (Standardeinstellung).
Win32LongPathLimit -Enable

# Anzeige der Stop-Fehlerinformationen auf dem BSoD.
BSoDStopError -Enable

# Keine Anzeige der Stop-Fehler-Informationen in der BSoD (Standardeinstellung).
# BSoDStopError -Disable

# Wählen Sie, wann Sie über Änderungen an Ihrem Computer benachrichtigt werden möchten: nie benachrichtigen.
# AdminApprovalMode -Never

# Wählen Sie, wann Sie über Änderungen an Ihrem Computer benachrichtigt werden möchten: Nur benachrichtigen, wenn Anwendungen versuchen, Änderungen an meinem Computer vorzunehmen (Standardeinstellung).
AdminApprovalMode -Default

# Aktiviert den Zugriff auf zugeordnete Laufwerke von einer Anwendung, die mit erweiterten Berechtigungen und aktiviertem Admin-Genehmigungsmodus ausgeführt wird.
MappedDrivesAppElevatedAccess -Enable

# Deaktiviert den Zugriff auf zugeordnete Laufwerke von Anwendungen, die mit erweiterten Berechtigungen und aktiviertem Admin-Genehmigungsmodus ausgeführt werden (Standardeinstellung).
# MappedDrivesAppElevatedAccess -Disable

# Zustellungsoptimierung ausschalten.
DeliveryOptimization -Disable

# Zustellungsoptimierung einschalten (Standardeinstellung).
# DeliveryOptimization -Enable

# Standarddrucker nicht von Windows verwalten lassen.
# WindowsManageDefaultPrinter -Disable

# Windows meinen Standarddrucker verwalten lassen (Standardeinstellung).
# WindowsManageDefaultPrinter -Enable

# Deaktivieren Sie die Windows-Funktionen über das Popup-Dialogfeld.
# WindowsFeatures -Disable

# Aktivieren Sie die Windows-Funktionen über das Popup-Dialogfeld (Standardeinstellung).
WindowsFeatures -Enable

# Deinstalliert optionale Funktionen über das Pop-up-Dialogfeld.
# WindowsCapabilities -Uninstall

# Optionale Funktionen über das Popup-Dialogfeld installieren (Standardeinstellung).
WindowsCapabilities -Install

# Erlaubt das Empfangen von Updates für andere Microsoft-Produkte beim Aktualisieren von Windows.
UpdateMicrosoftProducts -Enable

# Erlaubt nicht das Empfangen von Updates für andere Microsoft-Produkte beim Aktualisieren von Windows (Standardeinstellung).
# UpdateMicrosoftProducts -Disable

# Stellt den Energiesparplan auf "Hohe Leistung" ein. Es wird nicht empfohlen, sie für Laptops einzuschalten.
PowerPlan -High

# Einstellen des Energiesparplans auf "Ausgeglichen" (Standardeinstellung).
# PowerPlan -Balanced

# Erlauben Sie dem Computer nicht, die Netzwerkadapter auszuschalten, um Strom zu sparen. Es wird nicht empfohlen, die Funktion für Laptops zu deaktivieren.
NetworkAdaptersSavePower -Disable

# Dem Computer erlauben, die Netzwerkadapter auszuschalten, um Strom zu sparen (Standardeinstellung).
# NetworkAdaptersSavePower -Enable

# Deaktiviert die Komponente Internet Protocol Version 6 (TCP/IPv6) für alle Netzwerkverbindungen. Bevor die Funktion aufgerufen wird, wird geprüft, ob Ihr ISP das IPv6-Protokoll unterstützt. https://ipify.org.
# IPv6Component -Disable

# Aktiviert die Komponente Internet Protocol Version 6 (TCP/IPv6) für alle Netzwerkverbindungen (Standardeinstellung). Bevor die Funktion aufgerufen wird, wird geprüft, ob Ihr ISP das IPv6-Protokoll unterstützt. https://ipify.org.
# IPv6Component -Enable

# Aktiviert die Komponente Internet Protocol Version 6 (TCP/IPv6) für alle Netzwerkverbindungen. IPv4 gegenüber IPv6 bevorzugen. Bevor die Funktion aufgerufen wird, wird geprüft, ob Ihr ISP das IPv6-Protokoll unterstützt. https://ipify.org
IPv6Component -PreferIPv4overIPv6

# Überschreiben Sie die Standard-Eingabemethode: Englisch.
# InputMethod -English

# Überschreibung für Standard-Eingabemethode: Sprachliste verwenden (Standardeinstellung).
# InputMethod -Default

# Verschieben Sie Benutzerordner über das interaktive Menü in das Stammverzeichnis eines beliebigen Laufwerks. Benutzerdateien oder -ordner können nicht an einen neuen Speicherort verschoben werden. Verschieben Sie sie manuell. Sie befinden sich standardmäßig in dem Ordner %USERPROFILE%.
# Set-UserShellFolderLocation -Root

# Wählen Sie  den Ordner für Benutzerordner manuell über einen Ordner-Browser-Dialog aus. Benutzerdateien oder -ordner werden nicht an einen neuen Speicherort verschoben. Verschieben Sie sie manuell. Sie befinden sich standardmäßig in dem Ordner %USERPROFILE%.
# Set-UserShellFolderLocation -Custom

# Ändern Sie den Speicherort von Benutzerordnern auf die Standardeinstellungen. Benutzerdateien oder -ordner lassen sich nicht an einen neuen Speicherort verschieben. Verschieben Sie sie manuell. Sie befinden sich standardmäßig im Ordner %USERPROFILE% (Standardeinstellung).
# Set-UserShellFolderLocation -Default

# Verwenden Sie die neueste installierte .NET-Laufzeitumgebung für alle Anwendungen.
LatestInstalled.NET -Enable

# Die zuletzt installierte .NET-Laufzeitumgebung nicht für alle Anwendungen verwenden (Standardeinstellung).
# LatestInstalled.NET -Disable

# Speichern von Screenshots durch Drücken von Windows-Taste+"druck"-Taste auf dem Desktop.
# WinPrtScrFolder -Desktop

# Speichern von Screenshots durch Drücken von Windows-Taste+"druck"-Taste im Ordner Bilder (Standardeinstellung).
WinPrtScrFolder -Default

# Fehlerbehebung automatisch ausführen, dann benachrichtigen. Damit diese Funktion funktioniert, wird die Betriebssystemebene der Diagnosedatenerfassung auf "Optionale Diagnosedaten" gesetzt und die Fehlerberichtsfunktion wird aktiviert.
# RecommendedTroubleshooting -Automatically

# Fragen Sie mich, bevor Sie Troubleshooter ausführen. Damit diese Funktion funktioniert, muss die Betriebssystemebene der Diagnosedatenerfassung auf "Optionale Diagnosedaten" eingestellt und die Fehlerberichtsfunktion aktiviert werden (Standardeinstellung).
RecommendedTroubleshooting -Default

# Explorer in einem separaten Prozess starten.
# FoldersLaunchSeparateProcess -Enable

# Explorer nicht in einem separaten Prozess starten (Standardeinstellung).
FoldersLaunchSeparateProcess -Disable

# Deaktivieren und Löschen des reservierten Speichers nach der nächsten Update-Installation.
# ReservedStorage -Disable

# Reservierten Speicher aktivieren (Standardeinstellung).
ReservedStorage -Enable

# Hilfe-Suche über F1 deaktivieren.
F1HelpPage -Disable

# Hilfesuche über F1 aktivieren (Standardeinstellung).
# F1HelpPage -Enable

# Num Lock beim Starten aktivieren.
NumLock -Enable

# Num Lock beim Starten deaktivieren (Standardeinstellung).
# NumLock -Disable

# Feststelltaste deaktivieren.
CapsLock -Disable

# Feststelltaste einschalten (Standardeinstellung).
# CapsLock -Enable

# Ausschalten durch 5-maliges Drücken der Umschalttaste, um Sticky Keys einzuschalten.
StickyShift -Disable

# Aktivieren Sie das 5-malige Drücken der Umschalttaste, um Sticky Keys zu aktivieren (Standardeinstellung).
# StickyShift -Enable

# Verwendet die "Automatische Wiedergabe" für alle Medien und Geräte - nicht.
Autoplay -Disable

# "Automatische Wiedergabe" für alle Medien und Geräte verwenden (Standardeinstellung).
# Autoplay -Enable

# Entfernen des Thumbnail-Cache deaktivieren.
ThumbnailCacheRemoval -Disable

# Entfernen des Thumbnail-Cache aktivieren (Standardeinstellung).
# ThumbnailCacheRemoval -Enable

# Aktivieren Sie die automatische Speicherung meiner neu zu startenden Anwendungen beim Abmelden und starten Sie sie nach dem Anmelden neu.
# SaveRestartableApps -Enable

# Deaktivieren Sie das automatische Speichern meiner neu zu startenden Anwendungen beim Abmelden und starten Sie sie neu, nachdem Sie sich angemeldet haben (Standardeinstellung).
SaveRestartableApps -Disable

# Aktiviert die "Netzwerkerkennung" und "Datei- und Druckerfreigabe" für Arbeitsgruppennetzwerke.
# NetworkDiscovery -Enable

# Deaktiviert die "Netzwerkerkennung" und "Datei- und Druckerfreigabe" für Arbeitsgruppennetzwerke (Standardeinstellung).
NetworkDiscovery -Disable

# Eine Benachrichtigung anzeigen, wenn Ihr PC neu gestartet werden muss, um die Aktualisierung abzuschließen.
RestartNotification -Show

# Keine Benachrichtigung anzeigen, wenn Ihr PC neu gestartet werden muss, um die Aktualisierung abzuschließen (Standardeinstellung).
# RestartNotification -Hide

# Starten Sie das Gerät so bald wie möglich neu, wenn ein Neustart erforderlich ist, um ein Update zu installieren.
# RestartDeviceAfterUpdate -Enable

# Dieses Gerät nicht so schnell wie möglich neu starten, wenn ein Neustart erforderlich ist, um ein Update zu installieren (Standardeinstellung).
RestartDeviceAfterUpdate -Disable

# Automatische Anpassung der aktiven Stunden auf der Grundlage der täglichen Nutzung.
ActiveHours -Automatically

# Manuelle Anpassung der aktiven Stunden für mich auf der Grundlage der täglichen Nutzung (Standardeinstellung).
# ActiveHours -Manually

# Holen Sie sich keine Windows-Updates, sobald sie für Ihr Gerät verfügbar sind (Standardeinstellung).
WindowsLatestUpdate -Disable

# Holen Sie sich Windows-Updates, sobald sie für Ihr Gerät verfügbar sind.
# WindowsLatestUpdate -Enable

# Exportieren Sie alle Windows-Verknüpfungen in die Datei Application_Associations.json in den Skriptstammordner.
# Export-Associations

# Importieren Sie alle Windows-Zuordnungen aus einer JSON-Datei. Sie müssen alle Anwendungen gemäß der exportierten JSON-Datei installieren, um alle Zuordnungen wiederherzustellen.
# Import-Associations

# Windows Terminalvorschau als Standard-Terminalanwendung festlegen, um die Benutzeroberfläche für Befehlszeilenanwendungen bereitzustellen.
DefaultTerminalApp -WindowsTerminal

# Windows Console Host als Standardterminalanwendung festlegen, um die Benutzeroberfläche für Befehlszeilenanwendungen zu hosten (Standardeinstellung).
# DefaultTerminalApp -ConsoleHost

# Installieren Sie die neueste unterstützte Microsoft Visual C++ Redistributable 2015–2022 x64.
InstallVCRedist

# Installieren Sie die neueste .NET Desktop Runtime 6, 8 x64.
InstallDotNetRuntimes -Runtimes NET6x64, NET8x64

# Aktivieren Sie das Proxying nur für gesperrte Websites aus der einheitlichen Registrierung von Roskomnadzor. Die Funktion ist nur für Russland anwendbar.
# RKNBypass -Enable

# Deaktivieren Sie das Proxying nur für gesperrte Websites aus dem einheitlichen Register von Roskomnadzor (Standardeinstellung).
# RKNBypass -Disable

# Microsoft Edge-Kanäle auflisten, um die Erstellung von Desktop-Verknüpfungen bei der Aktualisierung zu verhindern.
# PreventEdgeShortcutCreation -Channels

# Verhindern Sie nicht die Erstellung von Desktop-Verknüpfungen beim Update von Microsoft Edge (Standardeinstellung).
# PreventEdgeShortcutCreation -Disable

# Verhindern, dass alle internen SATA-Laufwerke im Infobereich der Taskleiste als Wechselmedien angezeigt werden.
SATADrivesRemovableMedia -Disable

# Anzeige aller internen SATA-Laufwerke als entfernbare Medien im Infobereich der Taskleiste (Standardeinstellung).
# SATADrivesRemovableMedia -Default

# Sichern Sie die Systemregistrierung im Ordner %SystemRoot%\System32\config\RegBack, wenn der PC neu gestartet wird, und erstellen Sie ein RegIdleBackup in der Taskplaner-Aufgabe, um nachfolgende Sicherungen zu verwalten.
RegistryBackup -Enable

# Sichern Sie die Systemregistrierung nicht im Ordner %SystemRoot%\System32\config\RegBack (Standardeinstellung).
# RegistryBackup -Disable

# Registrieren Sie die App, berechnen Sie den Hash und verknüpfen Sie sie mit einer Erweiterung, wobei das Popup 'Wie möchten Sie diese öffnen?' ausgeblendet ist.
# Set-Association

#endregion System


#region WSL

# Aktiviert das Windows Subsystem für Linux (WSL), installiert die neueste Version des WSL-Linux-Kernels und eine Linux-Distribution über ein Popup-Formular. Die Einstellung "Updates für andere Microsoft-Produkte empfangen" wird automatisch aktiviert, um Kernel-Updates zu erhalten.
# Install-WSL

#endregion WSL


#region Start menu

# Standard-Startlayout anzeigen (Standardeinstellung).
# StartLayout -Default

# Mehr Pins auf Start anzeigen.
StartLayout -ShowMorePins

# Weitere Empfehlungen auf Start anzeigen.
# StartLayout -ShowMoreRecommendations

#endregion Start menu


#region UWP apps

# Deinstallation von UWP-Anwendungen über das Pop-up-Dialogfeld.
UninstallUWPApps

# Deinstalliert UWP-Anwendungen über das Popup-Dialogfeld. Wenn das Argument "Für alle Benutzer" aktiviert ist, werden die Anwendungspakete für neue Benutzer nicht installiert. Das Argument "Für alle Benutzer" aktiviert ein Kontrollkästchen, um Pakete für alle Benutzer zu deinstallieren.
# UninstallUWPApps -ForAllUsers

# Standard-UWP-Apps mithilfe des Popup-Dialogfelds wieder herstellen. UWP-Apps können nur wiederhergestellt werden, wenn sie nur für den aktuellen Benutzer deinstalliert wurden.
# RestoreUWPApps

# Autostart von Cortana deaktivieren.
CortanaAutostart -Disable

# Autostart von Cortana aktivieren (Standardeinstellung).
# CortanaAutostart -Enable

# Microsoft Teams-Autostart deaktivieren.
TeamsAutostart -Disable

# Microsoft Teams-Autostart aktivieren (Standardeinstellung).
# TeamsAutostart -Enable

#endregion UWP apps


#region Gaming

# Xbox Game Bar deaktivieren. Um zu verhindern, dass die Warnung "Sie benötigen eine neue App, um dieses ms-gamingoverlay zu öffnen" angezeigt wird, müssen Sie die Xbox Game Bar App deaktivieren, auch wenn Sie sie zuvor deinstalliert haben.
# XboxGameBar -Disable

# Xbox Game Bar aktivieren (Standardeinstellung).
# XboxGameBar -Enable

# Deaktivieren der Xbox Game Bar Tipps.
XboxGameTips -Disable

# Xbox Game Bar-Tipps aktivieren (Standardeinstellung).
# XboxGameTips -Enable

# Wählen Sie eine Anwendung aus und stellen Sie für diese die "Hohe Leistung" für die Grafikleistung ein. Nur mit einer dedizierten GPU.
Set-AppGraphicsPerformance

# Aktiviert die hardwarebeschleunigte GPU-Planung. Ein Neustart ist erforderlich. Nur mit einem dedizierten Grafikprozessor und einer WDDM-Version von 2.7 oder höher.
GPUScheduling -Enable

# Deaktiviert die hardwarebeschleunigte GPU-Planung (Standardeinstellung). Ein Neustart ist erforderlich.
# GPUScheduling -Disable

#endregion Gaming


#region Scheduled tasks

# Erstellt eine geplante Aufgabe "Windows Cleanup", um nicht verwendete Windows-Dateien und Updates zu bereinigen. Alle 30 Tage wird eine interaktive Toast-Benachrichtigung angezeigt. Die Aufgabe wird alle 30 Tage ausgeführt.
# CleanupTask -Register

# Löscht geplante Aufgaben "Windows-Bereinigung" und "Windows-Bereinigungsbenachrichtigung", um nicht verwendeten Windows-Dateien und Updates zu bereinigen.
CleanupTask -Delete

# Erstellt eine geplante Aufgabe "SoftwareDistribution", um den Ordner "%SystemRoot%\SoftwareDistribution\Download" zu bereinigen. Die Aufgabe wartet, bis der Windows-Update-Dienst seine Ausführung beendet hat. Die Aufgabe wird alle 90 Tage ausgeführt.
SoftwareDistributionTask -Register

# Löscht die geplante Aufgabe "SoftwareDistribution", um den Ordner "%SystemRoot%\SoftwareDistribution\Download" zu bereinigen.
# SoftwareDistributionTask -Delete

# Erstellt eine geplante Aufgabe "Temp", um den Ordner %TEMP% zu bereinigen. Die Aufgabe wird alle 60 Tage ausgeführt.
TempTask -Register

# Löscht die geplante Aufgabe "Temp", um den Ordner %TEMP% zu bereinigen.
# TempTask -Delete

#endregion Scheduled tasks


#region Microsoft Defender & Security

# Netzwerkschutz von Microsoft Defender Exploit Guard aktivieren.
NetworkProtection -Enable

# Netzwerkschutz von Microsoft Defender Exploit Guard deaktivieren (Standardeinstellung).
# NetworkProtection -Disable

# Erkennung potenziell unerwünschter Apps aktivieren und diese blockieren.
PUAppsDetection -Enable

# Erkennung potenziell unerwünschter Apps deaktivieren und diese blockieren (Standardeinstellung).
# PUAppsDetection -Disable

# Aktiviert Sandboxing für Microsoft Defender.
# DefenderSandbox -Enable

# Sandboxing für Microsoft Defender deaktivieren (Standardeinstellung).
# DefenderSandbox -Disable

# Microsoft Defender-Angebot in der Windows-Sicherheit über die Anmeldung im Microsoft-Konto ablehnen.
DismissMSAccount

# Microsoft Defender-Angebot in der Windows-Sicherheit über die Aktivierung des SmartScreen-Filters für Microsoft Edge ablehnen.
DismissSmartScreenFilter

# Erstellt eine benutzerdefinierte Ansicht "Prozesserstellung", um ausgeführte Prozesse und ihre Argumente zu protokollieren.
EventViewerCustomView -Enable

# Entfernt die Ereignisanzeige "Prozesserstellung", um ausgeführte Prozesse und ihre Argumente zu protokollieren (Standardeinstellung).
# EventViewerCustomView -Disable

# Aktiviert die Protokollierung für alle Windows PowerShell-Module.
PowerShellModulesLogging -Enable

# Deaktiviert die Protokollierung für alle Windows PowerShell-Module (Standardeinstellung).
# PowerShellModulesLogging -Disable

# Aktiviert die Protokollierung für alle PowerShell-Skripte, die in das Windows PowerShell-Ereignisprotokoll eingegeben werden.
PowerShellScriptsLogging -Enable

# Deaktiviert die Protokollierung für alle PowerShell-Skripte, die in das Windows PowerShell-Ereignisprotokoll eingegeben werden (Standardeinstellung).
# PowerShellScriptsLogging -Disable

# Microsoft Defender SmartScreen markiert heruntergeladene Dateien aus dem Internet nicht als unsicher.
# AppsSmartScreen -Disable

# Microsoft Defender SmartScreen markiert aus dem Internet heruntergeladene Dateien als unsicher (Standardeinstellung).
AppsSmartScreen -Enable

# Deaktiviert den "Attachment Manager", der Dateien, die aus dem Internet heruntergeladen wurden, als unsicher markiert.
SaveZoneInformation -Disable

# Aktiviert den "Attachment Manager", der Dateien, die aus dem Internet heruntergeladen wurden, als unsicher markiert (Standardeinstellung.
# SaveZoneInformation -Enable

# Windows Script Host deaktivieren. Sperrt WSH für die Ausführung von .js und .vbs Dateien.
# WindowsScriptHost -Disable

# Windows Script Host aktivieren (Standardeinstellung).
WindowsScriptHost -Enable

# Windows-Sandbox aktivieren.
# WindowsSandbox -Enable

# Windows-Sandbox deaktivieren (Standardeinstellung).
WindowsSandbox -Disable

# Aktiviert DNS-over-HTTPS für IPv4. Gültige IPv4-Adressen: 1.0.0.1, 1.1.1.1, 149.112.112.112, 8.8.4.4, 8.8.8.8, 9.9.9.91.
# DNSoverHTTPS -Enable

# Deaktiviert DNS-over-HTTPS für IPv4 (Standardeinstellung).
DNSoverHTTPS -Disable

# Aktivieren Sie den Schutz der lokalen Sicherheitsbehörde, um Code-Injektion ohne UEFI-Sperre zu verhindern.
LocalSecurityAuthority -Enable

# Deaktivieren Sie den Schutz der lokalen Sicherheitsbehörde ohne UEFI-Sperre (Standardeinstellung).
# LocalSecurityAuthority -Disable

#endregion Microsoft Defender & Security


#region Context menu

# Anzeigen der Option "Alle extrahieren" im Kontextmenü des Windows-Installationsprogramms (.msi).
MSIExtractContext -Show

# Ausblenden der Option "Alle extrahieren" im Kontextmenü des Windows Installers (.msi) (Standardeinstellung).
# MSIExtractContext -Hide

# Eintrag "Installieren" im Kontextmenü der Cabinet (.cab)-Dateinamenerweiterungen anzeigen.
CABInstallContext -Show

# Eintrag "Installieren" im Kontextmenü der Cabinet (.cab)-Dateinamenerweiterungen ausblenden (Standardeinstellung).
# CABInstallContext -Hide

# Eintrag "Mit Clipchamp bearbeiten" im Kontextmenü ausblenden.
EditWithClipchampContext -Hide

# Eintrag "Mit Clipchamp bearbeiten" im Kontextmenü anzeigen (Standardeinstellung).
# EditWithClipchampContext -Show

# Ausblenden des Eintrags "Drucken" im Kontextmenü von .bat und .cmd.
PrintCMDContext -Hide

# Den Eintrag "Drucken" im Kontextmenü von .bat und .cmd anzeigen (Standardeinstellung).
# PrintCMDContext -Show

# Den Eintrag "Komprimierter ZIP-Ordner" "Neu" im Kontextmenü ausblenden.
# CompressedFolderNewContext -Hide

# Den Eintrag "Komprimierter (zip) Ordner" "Neu" im Kontextmenü anzeigen (Standardeinstellung).
CompressedFolderNewContext -Show

# Aktiviert die Kontextmenüelemente "Öffnen", "Drucken" und "Bearbeiten" für mehr als 15 ausgewählte Elemente.
MultipleInvokeContext -Enable

# Deaktiviert die Kontextmenüelemente "Öffnen", "Drucken" und "Bearbeiten" für mehr als 15 ausgewählte Elemente (Standardeinstellung).
# MultipleInvokeContext -Disable

# Den Punkt "Nach einer App im Microsoft Store suchen" im Dialogfeld "Öffnen mit" ausblenden.
# UseStoreOpenWith -Hide

# Den Punkt "Nach einer App im Microsoft Store suchen" im Dialogfeld "Öffnen mit" anzeigen (Standardeinstellung).
UseStoreOpenWith -Show

# Menüoption "In Windows Terminal öffnen" im Kontextmenü der Ordner anzeigen (Standardeinstellung).
OpenWindowsTerminalContext -Show

# Menüoption "In Windows Terminal öffnen" im Kontextmenü von Ordnern ausblenden.
# OpenWindowsTerminalContext -Hide

# Windows-Terminal im Kontextmenü standardmäßig als Administrator öffnen.
OpenWindowsTerminalAdminContext -Enable

# Windows-Terminal im Kontextmenü standardmäßig als Administrator nicht öffnen (Standardeinstellung).
# OpenWindowsTerminalAdminContext -Disable

#endregion Context menu


#region Update Policies

# Zeigt alle Richtlinien-Registrierungsschlüssel (auch manuell erstellte) im Snap-In Lokaler Gruppenrichtlinien-Editor (gpedit.msc) an. Dies kann bis zu 30 Minuten dauern, abhängig von der Anzahl der in der Registrierung erstellten Richtlinien und Ihren Systemressourcen.
# UpdateLGPEPolicies

#endregion Update Policies


PostActions
Errors