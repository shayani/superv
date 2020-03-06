$hostname = $env:computername
$config_file = "c:\zabbix\conf\zabbix_agentd.win.conf"

# Script para teste de PING a servidores remotos
#
$ping_8888 = 0
if (Test-Connection 8.8.8.8 -Count 2 -Quiet) { $ping_8888 = 1 }
$ping_8844 = 0
if (Test-Connection 8.8.4.4 -Count 2 -Quiet) { $ping_8844 = 1 }
$ping_srv001 = 0
if (Test-Connection srv001.shayani.net -Count 2 -Quiet) { $ping_srv001 = 1 }

c:\zabbix\bin\win64\zabbix_sender.exe -c $config_file -z superv.shayani.net -s $hostname -k ping.8888 -o $ping_8888 >$null 2>&1
c:\zabbix\bin\win64\zabbix_sender.exe -c $config_file -z superv.shayani.net -s $hostname -k ping.8844 -o $ping_8844 >$null 2>&1
c:\zabbix\bin\win64\zabbix_sender.exe -c $config_file -z superv.shayani.net -s $hostname -k ping.srv001_shayani_net -o $ping_srv001 >$null 2>&1

# Script para teste de latencia
#
$Test = test-connection 8.8.8.8 -count 1
$ping_time_8888 = $Test.responsetime 
c:\zabbix\bin\win64\zabbix_sender.exe -c $config_file -z superv.shayani.net -s $hostname -k ping.time.8888 -o $ping_time_8888 >$null 2>&1 
$Test = test-connection 8.8.4.4 -count 1
$ping_time_8844 = $Test.responsetime 
c:\zabbix\bin\win64\zabbix_sender.exe -c $config_file -z superv.shayani.net -s $hostname -k ping.time.8844 -o $ping_time_8844 >$null 2>&1 
$Test = test-connection srv001.shayani.net -count 1
$ping_time_srv001 = $Test.responsetime 
c:\zabbix\bin\win64\zabbix_sender.exe -c $config_file -z superv.shayani.net -s $hostname -k ping.time.srv001 -o $ping_time_srv001 >$null 2>&1 

# Qualidade do WiFi
#
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
c:\zabbix\bin\win64\zabbix_sender.exe -c $config_file -z superv.shayani.net -s $hostname -k wireless.SSID -o $objInterface.SSID >$null 2>&1 
c:\zabbix\bin\win64\zabbix_sender.exe -c $config_file -z superv.shayani.net -s $hostname -k wireless.BSSID -o $objInterface.BSSID >$null 2>&1 
c:\zabbix\bin\win64\zabbix_sender.exe -c $config_file -z superv.shayani.net -s $hostname -k wireless.signal -o $objInterface.Signal.replace("%","") >$null 2>&1 

# Finaliza
echo 1