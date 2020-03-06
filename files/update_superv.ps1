echo "Atualizando Zabbix"
echo "------------------"

echo "> Parando Zabbix atual"
Stop-Service "Zabbix Agent"

echo "> Baixando arquivo"
(new-object System.Net.WebClient).DownloadFile('https://superv.shayani.net/windows.zip', 'C:\zabbix\agent_windows.zip')
Expand-Archive -Force c:\zabbix\agent_windows.zip -DestinationPath c:\zabbix

echo "> Reiniciando Zabbix"
Start-Service "Zabbix Agent"

