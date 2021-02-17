@ECHO OFF

echo # Changing powershell script execution policy > log.txt
echo # ------------------------------------------------- >> log.txt
powershell Set-ExecutionPolicy RemoteSigned -Scope CurrentUser >> log.txt


echo # Running the script >> log.txt
echo # ------------------------------------------------- >> log.txt
powershell -File ./script.ps1

