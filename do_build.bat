@echo off
curl --ssl-no-revoke -X POST "https://api.codemagic.io/builds" ^
  -H "x-auth-token: NsPQtjeEcElY7ezBpFShY20m8LabFoJGe57pzC_j7eE" ^
  -H "Content-Type: application/json" ^
  --data @"C:\Users\steve\ClaudeCode\customer-app\wapp\wapp\cm_payload.json"
echo BUILD_CURL_DONE
