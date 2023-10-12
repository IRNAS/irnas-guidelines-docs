@ECHO OFF
setlocal EnableDelayedExpansion

ECHO Make sure you have committed AND pushed your changes inside Altium Designer before continuing.
ECHO:
set /p "local_directory=Enter Local Path to your Altium Designer project: "

:: Check if the local directory exists and go to end if it does not
IF EXIST !local_directory! (
    ECHO Moving into %local_directory%
    :: Move into the local directory
    cd /d %local_directory%
) ELSE (
    ECHO %local_directory% does not exist. Enter the correct path.
    :: Jump to the end of the script
    GOTO :end
)

:: If the first command line argument is reset, delete the .git-remote file
IF "%1"=="reset" (
    ECHO Resetting remote URL
    DEL .git-remote
)

:: Read the .git-remote file and set the remote url to the target repo
FOR /f "tokens=*" %%x in (.git-remote) do (
    set remote_url=%%x
)

:: If the .git-remote file does not exist, ask the user to enter the remote url
IF "%remote_url%"=="" (
    ECHO .git-remote file does not exist

    :enter_remote_url
    SET /p "target_repo=Enter Remote URL: "

    :: Check if the repo exists and request the user to enter the correct url if it does not
    git ls-remote !target_repo! || (
        ECHO Repository does not exist. Enter the correct URL.
        GOTO :enter_remote_url
    )

    :: Notify the user that the remote url has been set and create the .git-remote file
    ECHO Set remote URL: !target_repo!
    ECHO Creating .git-remote file
    
    :: Create .git-remote file with the repo url and add it to .gitignore
    ECHO !target_repo! > .git-remote
    ECHO: >> .gitignore
    ECHO .git-remote >> .gitignore

    :: For some reason the ELSE executes even if the IF is true
    GOTO :altium_remote
) ELSE (
    :: Notify the user that the remote url has been read from the file
    ECHO Remote URL from file: %remote_url%
    set target_repo=%remote_url%
    @REM ECHO target_repo: !target_repo!
)

:: Get current altium github repo url
:altium_remote
FOR /F "tokens=* USEBACKQ" %%F IN (`git ls-remote --get-url`) DO (
    SET altium_remote=%%F
)
@REM ECHO %altium_remote%

:: Set remote url to target repo, pull it and checkout main branch
git remote set-url origin %target_repo%
git add .
git push %target_repo% HEAD:main --force

:: Set the remote url back to the altium repo and checkout master branch
git remote set-url origin %altium_remote%
git checkout master

:end
ECHO Press enter to exit
SET /p input=