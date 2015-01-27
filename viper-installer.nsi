; Script generated by the NSIS Studio maintained by hand

!include "LogicLib.nsh"
!include "WinVer.nsh"
!include "x64.nsh"

; Define helper variables
!define PRODUCT_NAME "viper"
!define PRODUCT_VERSION "0.9.4.0"
!define PRODUCT_DISPLAY_NAME "${PRODUCT_NAME} v${PRODUCT_VERSION}"
!define PRODUCT_PUBLISHER "Greenhost"
!define PRODUCT_WEB_SITE "www.greenhost.nl"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

!define SRC_ROOT "."
!define SERVICE_ROOT "${SRC_ROOT}\viper"
!define CLIENT_ROOT "${SRC_ROOT}\viper-reference-gui\systray"
;"${SRC_ROOT}\"

; Define user variables
var CONDITION_0

SetCompress auto
SetCompressor /SOLID lzma

; Interface Settings
!define MULTIUSER_EXECUTIONLEVEL Admin
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!include "MultiUser.nsh"
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\box-install.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\arrow.bmp"
!define MUI_COMPONENTSPAGE_CHECKBITMAP "${NSISDIR}\Contrib\Graphics\Checks\modern.bmp"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\box-uninstall.ico"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\arrow.bmp"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Page Settings
; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${PRODUCT_NAME}"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\doc\index.html"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end


Name "${PRODUCT_DISPLAY_NAME}"
OutFile "${SRC_ROOT}\${PRODUCT_NAME}-setup.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
BrandingText "${PRODUCT_PUBLISHER}"
SetOverwrite on
Caption "${PRODUCT_DISPLAY_NAME} Setup"
UninstallCaption "${PRODUCT_DISPLAY_NAME} Uninstall"

; Installer file metadata
VIProductVersion ${PRODUCT_VERSION}
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "Viper"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" ${PRODUCT_VERSION}
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Greenhost"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "? ${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" ""
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${PRODUCT_NAME} Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.0.0.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" ""

Section "UmanViper Install" SEC001

  SetOutPath "$INSTDIR\openvpn"
  File "${SERVICE_ROOT}\dist\openvpn\*"

  SetOutPath "$INSTDIR\resources"
  SetOutPath "$INSTDIR\resources"
  File "${SERVICE_ROOT}\dist\resources\*"

  SetOutPath "$INSTDIR\resources\icons"
  File "${SERVICE_ROOT}\dist\resources\icons\*.ico"

;  SetOutPath "$INSTDIR\resources\www"
;  File "${SERVICE_ROOT}\dist\resources\www\*"

  SetOutPath "$INSTDIR\resources\www\res"
  File "${SERVICE_ROOT}\dist\resources\www\res\*"

  SetOutPath "$INSTDIR\resources\www\views"
  File "${SERVICE_ROOT}\dist\resources\www\views\*"

  SetOutPath "$INSTDIR\tap-windows"
  File "${SERVICE_ROOT}\dist\tap-windows\tap-windows.exe"

  SetOutPath "$INSTDIR\doc"
  File "${SERVICE_ROOT}\dist\doc\*"
  SetOutPath "$INSTDIR\doc\res"
  File "${SERVICE_ROOT}\dist\doc\res\*"

  SetOutPath "$INSTDIR\service"
  File "${SERVICE_ROOT}\dist\service\*"

  SetOutPath "$INSTDIR\client"
  File "${CLIENT_ROOT}\bin\Release\Newtonsoft.Json.dll"
  File "${CLIENT_ROOT}\bin\Release\Newtonsoft.Json.xml"
  File "${CLIENT_ROOT}\bin\Release\viper-reference-client.exe"
  File "${CLIENT_ROOT}\bin\Release\viper-reference-client.exe.config"
SectionEnd

SectionGroup /e "Prerequisites" SEC002
Section "TUN/TAP driver install" SEC003
  SetOutPath "$INSTDIR"
  MessageBox MB_OK|MB_ICONINFORMATION "This software needs a third-party TAP/TUN driver to work. This driver is included in this installation package and will install automatically when you click OK."

  SetOutPath "$INSTDIR\tap-windows"
  ExecWait '"$INSTDIR\tap-windows\tap-windows.exe" /S'
SectionEnd
Section "Environment variables" SEC004
  SetOutPath "$INSTDIR"
WriteRegStr "SHCTX" "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "OPENVPN_HOME" "$INSTDIR\openvpn\"
WriteRegStr "SHCTX" "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "VIPER_HOME" "$INSTDIR"
SectionEnd
SectionGroupEnd

Section "Startup" SEC005
  SetOutPath "$INSTDIR"
  SetOutPath "$INSTDIR\service"
  ExecWait '"$INSTDIR\service\ovpnmon.exe" -install -auto'
  SetOutPath ""
  ExecWait '"net" start ovpnmon'
SectionEnd


Function .onInit
  ; Go on with initialization routine
  !insertmacro MULTIUSER_INIT
  !define MUI_LANGDLL_ALWAYSSHOW
  !insertmacro MUI_LANGDLL_DISPLAY

  ;Set user variables
  ReadRegStr $CONDITION_0 "SHCTX" "SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" ""
  ${If} $CONDITION_0 == ""
    StrCpy $CONDITION_0 "false"
  ${Else}
    StrCpy $CONDITION_0 "true"
  ${EndIf}

  ${If} ${RunningX64}
      SetRegView 64
      StrCpy $INSTDIR "$PROGRAMFILES64\${PRODUCT_NAME}"
  ${EndIf}

  ;Set section flags
  StrCpy $0 0
  IntOp $0 $0 | ${SF_SELECTED}
  SectionSetFlags ${SEC001} $0

  StrCpy $0 0
  IntOp $0 $0 | ${SF_SELECTED}
  SectionSetFlags ${SEC003} $0

  StrCpy $0 0
  IntOp $0 $0 | ${SF_SELECTED}
  SectionSetFlags ${SEC004} $0

  StrCpy $0 0
  IntOp $0 $0 | ${SF_SELECTED}
  SectionSetFlags ${SEC005} $0

  ; Find out if there's a previous version installed
  ReadRegStr $R0 HKLM \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
    "UninstallString"
    StrCmp $R0 "" done

    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
    "${PRODUCT_NAME} is already installed. $\n$\nClick `OK` to remove the \
    previous version or `Cancel` to cancel this upgrade." \
    IDOK uninst
    Abort

  ;Run the uninstaller
  uninst:
    ClearErrors
    ;ExecWait '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file
    Exec $INSTDIR\uninst.exe

  done:

FunctionEnd

Section -AdditionalIcons
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  WriteIniStr "$SMPROGRAMS\$ICONS_GROUP\Website.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\${PRODUCT_NAME}.lnk" "$INSTDIR\client\viper-reference-client.exe"  SetOutPath "$INSTDIR\doc"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\UmanViper Readme.html.lnk" "$INSTDIR\doc\index.html" "" "" "" "SW_SHOWNORMAL" "" ""
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallPath" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallMode" "$MultiUser.InstallMode"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC001} "This will install all the necessary components to secure your internet connection through the Uman Viper OpenVPN client."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC002} "This will set the necessary environment variables."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC003} ""
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC004} ""
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC005} "This will start the monitoring service."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  !insertmacro MULTIUSER_UNINIT
  !insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  !insertmacro MUI_STARTMENU_GETFOLDER Application $ICONS_GROUP
  Delete "$INSTDIR\*"
  Delete "$INSTDIR\openvpn\*"
  Delete "$INSTDIR\resources\icons\*"
  Delete "$INSTDIR\resources\*"
  Delete "$INSTDIR\tap-windows\tap-windows.exe"
  Delete "$INSTDIR\tap-windows\tapdrivers\icon.ico"
  Delete "$INSTDIR\tap-windows\tapdrivers\license.txt"
  Delete "$INSTDIR\tap-windows\tapdrivers\$PLUGINSDIR\InstallOptions.dll"
  Delete "$INSTDIR\tap-windows\tapdrivers\$PLUGINSDIR\ioSpecial.ini"
  Delete "$INSTDIR\tap-windows\tapdrivers\$PLUGINSDIR\modern-header.bmp"
  Delete "$INSTDIR\tap-windows\tapdrivers\$PLUGINSDIR\modern-wizard.bmp"
  Delete "$INSTDIR\tap-windows\tapdrivers\$PLUGINSDIR\nsExec.dll"
  Delete "$INSTDIR\tap-windows\tapdrivers\$PLUGINSDIR\System.dll"
  Delete "$INSTDIR\tap-windows\tapdrivers\bin\devcon.exe"
  Delete "$INSTDIR\tap-windows\tapdrivers\driver\OemWin2k.inf"
  Delete "$INSTDIR\tap-windows\tapdrivers\driver\tap0901.cat"
  Delete "$INSTDIR\tap-windows\tapdrivers\driver\tap0901.sys"
  Delete "$INSTDIR\tap-windows\tapdrivers\include\tap-windows.h"
  Delete "$INSTDIR\tap-windows\tapdrivers\include\$PLUGINSDIR\UserInfo.dll"
  Delete "$INSTDIR\doc\index.html"
  Delete "$INSTDIR\doc\README.md"
  Delete "$INSTDIR\doc\res\configure.png"
  Delete "$INSTDIR\doc\res\connected.png"
  Delete "$INSTDIR\doc\res\connecting.png"
  Delete "$INSTDIR\doc\res\envvar.png"
  Delete "$INSTDIR\doc\res\not_connected.png"
  Delete "$INSTDIR\doc\res\run_as_admin.png"
  Delete "$INSTDIR\doc\res\validate.png"
  Delete "$INSTDIR\service\*"
  RMDir "$INSTDIR\openvpn"
  RMDir "$INSTDIR\resources\icons"
  RMDir "$INSTDIR\resources"
  RMDir "$INSTDIR\tap-windows\tapdrivers\$PLUGINSDIR"
  RMDir "$INSTDIR\tap-windows\tapdrivers\bin"
  RMDir "$INSTDIR\tap-windows\tapdrivers\driver"
  RMDir "$INSTDIR\tap-windows\tapdrivers\include\$PLUGINSDIR"
  RMDir "$INSTDIR\tap-windows\tapdrivers\include"
  RMDir "$INSTDIR\tap-windows\tapdrivers"
  RMDir "$INSTDIR\tap-windows"
  RMDir "$INSTDIR\doc\res"
  RMDir "$INSTDIR\doc"
  RMDir "$INSTDIR\service"

DeleteRegValue "SHCTX" "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "OPENVPN_HOME"


DeleteRegValue "SHCTX" "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "OPENVPN_HOME"
DeleteRegValue "SHCTX" "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "VIPER_HOME"


  SetOutPath ""
  ExecWait '"net" stop ovpnmon'
  SetOutPath ""
  ExecWait '"sc" delete ovpnmon'
  Delete "$INSTDIR\uninst.exe"
  RMDir "$INSTDIR"

  Delete "$SMPROGRAMS\$ICONS_GROUP\UmanViper Readme.html.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\Website.url"
  Delete "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\${PRODUCT_NAME}.lnk"
  RMDir "$SMPROGRAMS\$ICONS_GROUP"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd
