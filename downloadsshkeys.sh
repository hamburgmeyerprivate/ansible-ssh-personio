#!/bin/bash

# Zugangsdaten zur API von Personio
client_id='ZTcwYjg0NjE5YjQwYmRmMDEyNDZhYzI2'
client_secret='ZjYyNDljYWMyZWIxZDg4NDhjNTVhZjJmOTJmODRjZDE2ZjYy'
endpoint='https://api.personio.de'

# Generierung des Bearer Token
token=$(curl -X POST "$endpoint/v1/auth?client_id=$client_id&client_secret=$client_secret" -H 'cache-control: no-cache' | jq -r .data.token)

# Abruf der aktuellen Angestellendaten der API. 
# Formatierung durch jq '.' 
# grep zum Identifizieren der richtigen Zeilen, die SSH als Attribut besitzen
# Nochmals grep zum Auslesen der SSH-Keys
# Nochmals grep zum Entfernen leerer Value-Felder
# Nun sind nur noch Zeilen mit SSH-Keys vorhanden. Diese werden durch cut extrahiert und in die Datei keys.txt geschrieben. 
curl -H "Authorization: Bearer $token" 'https://api.personio.de/v1/company/employees' | jq '.' | grep -C1 SSH | grep value | grep -v '""' | cut -d\" -f4 > keys.txt

# Erstellt die Datei status.txt mit dem String "Erfolgreich", um Ansible das Erreichen des Ende des Scripts zu signalisieren.
echo "ERFOLGREICH" > status.txt