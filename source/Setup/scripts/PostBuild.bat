rem %1 - $(TargetDir)
rem %2 - $(TargetFileName) = OdfAddinForOfficeSetup.msi
rem %3 - $(ConfigurationName)


echo Signing MSI files
call %1..\..\..\..\signing\sign.bat "%1de-DE\%2"
call %1..\..\..\..\signing\sign.bat "%1en-US\%2"
call %1..\..\..\..\signing\sign.bat "%1fr-FR\%2"
call %1..\..\..\..\signing\sign.bat "%1ja-JP\%2"
call %1..\..\..\..\signing\sign.bat "%1nl-NL\%2"
call %1..\..\..\..\signing\sign.bat "%1pl-PL\%2"
call %1..\..\..\..\signing\sign.bat "%1zh-CHS\%2"


echo Building self-extracting installer
echo IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.de-DE.sed
IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.de-DE.sed
echo IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.en-US.sed
IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.en-US.sed
echo IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.fr-FR.sed
IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.fr-FR.sed
echo IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.ja-JP.sed
IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.ja-JP.sed
echo IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.nl-NL.sed
IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.nl-NL.sed
echo IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.pl-PL.sed
IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.pl-PL.sed
echo IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.zh-CHS.sed
IExpress /Q /N ..\..\l10n\OdfAddInForOfficeSetup.zh-CHS.sed


rem Signing self-extracting installer
call %1..\..\..\..\signing\sign.bat "%1OdfAddInForOfficeSetup-de.exe"
call %1..\..\..\..\signing\sign.bat "%1OdfAddInForOfficeSetup-en.exe"
call %1..\..\..\..\signing\sign.bat "%1OdfAddInForOfficeSetup-fr.exe"
call %1..\..\..\..\signing\sign.bat "%1OdfAddInForOfficeSetup-ja.exe"
call %1..\..\..\..\signing\sign.bat "%1OdfAddInForOfficeSetup-nl.exe"
call %1..\..\..\..\signing\sign.bat "%1OdfAddInForOfficeSetup-pl.exe"
call %1..\..\..\..\signing\sign.bat "%1OdfAddInForOfficeSetup-chs.exe"

rem Package command line tool
call %1..\..\scripts\PackageCommandLineTool.bat %1 %3
