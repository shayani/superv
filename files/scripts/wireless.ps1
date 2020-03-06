$strDump = netsh wlan show interfaces
$objInterface = "" | Select-Object SSID,BSSID,Signal

foreach ($strLine in $strDump) {
        if ($strLine -match "^\s+SSID") {
                $objInterface.SSID = $strLine -Replace "^\s+SSID\s+:\s+",""
        } elseif ($strLine -match "^\s+BSSID") {
                $objInterface.BSSID = $strLine -Replace "^\s+BSSID\s+:\s+",""
        } elseif ($strLine -match "^\s+Si*nal") {
                $objInterface.Signal = $strLine -Replace "^\s+Si*nal\s+:\s+",""
        }
}

# Do whatever with the resulting object. We'll just print it out here
if ($args[0] -eq "SSID") {
  $objInterface.SSID
} elseif ($args[0] -eq "BSSID") {
  $objInterface.BSSID
} elseif ($args[0] -eq "Signal") {
  $objInterface.Signal -Replace "%",""
}

