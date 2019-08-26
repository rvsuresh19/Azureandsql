Automate file copy to Azure Blob - Azcopy & Powershell
The quickest way to copy files from local to azure blob storage with Azure SAS URI is to use the Azurecopy tool.  Automating such operations with Powershell can save us lot of time and effort. 

I have created a simple powershell script to perform the same and attached for readers benefit.

The script expects 3 inputs, 

1. Source directory where AZcopy is available already or where it needs to be installed.

2. Source folder where full backups files are available

3. Destination SAS URI 

What does the below script does

1. Validates if Azcopy already available in the source server, if not, it downloads the azcopy to the path keyed in by the user.

2. Copy all the files from the source directory path provided by the user.

3. Move the files to our blob storage using the SAS URI provided by the user.

Sample execution of the script:

CopyFilestoBlob_SAS.ps1 "C:\Suresh\Downloads" "C:\Suresh\Fulldbbackups" "https://suresh.blob.core.windows.net/db-bkp?st=2018-08-23T00%3A25%3A27Z&se=2018-09-30T13%3A59%3A00Z&sp=rwdl&sv=2018-03-28&sr=c&sig=wGlYoUQQXagS0lcMwWGQs%2FrrEI5ybKKRnh9DylCAKto%3D"

####Powershell Script#####

[CmdletBinding()]

Param(

[Parameter(Mandatory=$True,HelpMessage= "Path where Azcopy exists or to be downloaded",Position=0)]

[string]$AzCopypath,

[Parameter(Mandatory=$True,HelpMessage= "Path where database backup folder exists",Position=1)]

[string]$sourcebkppath,

[Parameter(Mandatory=$True,HelpMessage= "Destination SAS URI with the container name",Position=2)]

[string]$destinationSASURI

)

$Azcopysubfldr = "azcopy_windows_amd64_10.1.2"

$AzFilepath ="azcopy_windows_amd64_10.1.2\azcopy.exe"

$AzFilepath ="azcopy_windows_amd64_10.1.2\azcopy.exe"

$Azcopyfullpath = join-path -path $AzCopypath -childpath $Azcopysubfldr

 $path1=join-path -path $AzCopypath -childpath $AzFilepath

 $val=test-path $path1

if(-not $val ) {

Invoke-WebRequest https://azcopyvnext.azureedge.net/release20190517/azcopy_windows_amd64_10.1.2.zip -OutFile $AzCopypath\azcopyv10.zip

Expand-Archive -LiteralPath $AzCopypath\azcopyv10.zip $AzCopypath}

ELSE

{

 cd $Azcopyfullpath

 ./azcopy.exe copy $sourcebkppath\* $destinationSASURI --recursive=true
