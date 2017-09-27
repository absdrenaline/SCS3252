@ECHO off
setlocal EnableDelayedExpansion
set "defaultMongoDir=C:\Program Files\MongoDB\Server\3.4\bin\"

echo *** Welcome to the mongo Shell launcher creation script v1.0 ***

for /L %%n in (1,1,3) do (
  set /p mongoDir="Where is Mongo located on your machine? (E.g: %defaultMongoDir% or Press Enter for Default): "
  IF "!mongoDir!" == "" (
	set "mongoDir=!defaultMongoDir!"
	echo Using mongo directory !mongoDir!
  )
  IF EXIST "!mongoDir!\\mongo.exe" (
	call :nextstep
  ) ELSE (
	echo I did not find the Mongo Client on the path %mongoDir%.
	echo Check if Mongo.exe is located inside that folder and try again!
  )
)
:failed
echo Failed to create the mongo Shell launcher. Try again.
goto end

:nextstep
echo Good Job. I found the Mongo Client. Let's continue.
echo **** Connection String ***
echo Enter the connection string EXACTLY as copied from Step (2) of the Mongo Website.
echo No need to replace the password yet.
echo E.g.mongo "mongodb: ... --password <PASSWORD>
set /p str="Connection String: " 
set /p passwd="Enter the admin Password:"
set "str=!str:<PASSWORD>="%passwd%"!"
echo Setting the connection string to 
echo !str!

:createlauncher
(
	echo cd /D "!mongoDir!"
	echo start cmd /c !str!
	echo exit
) > mongoShell.bat

echo Created mongoShell.bat in %cd%.
set /p answer="To make it easier to launch, shall I move the launcher file to your Desktop? (y/n): "
if /I "!answer!" == "y" (
	move mongoShell.bat %USERPROFILE%\Desktop
	echo Double-click mongoShell.bat on the Desktop to launch the mongo Shell
) ELSE (
	echo You may run mongoShell.bat by double-clicking it or from the command prompt. The path is 
	echo "%cd%\mongoShell.bat"
)


:end
set /p pauseString = "Press Enter to exit."
exit
