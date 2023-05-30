@set basestring=((Get-Content "%~sf0"^|Select-String '^^^::.'^) -replace '::\s'^)^|Out-String
@powershell -noprofile -nologo -command ^
 "Invoke-Expression (%basestring%);" ^
 "Get-ChildItem "'%~dp0'" -filter guide.xml | foreach {" ^
     "New-GZipArchive $_.FullName "$($_.FullName + '.gz')" -Verbose -Clobber;" ^
     "Remove-Item -LiteralPath $_.FullName -Verbose -Force" ^
 "}"

:: function New-GZipArchive {
::     [CmdletBinding(SupportsShouldProcess=$true, PositionalBinding=$true)]
::     [OutputType([Boolean])]
:: 
::     Param (
::         [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
::         [ValidateNotNull()]
::         [ValidateNotNullOrEmpty()]
::         [ValidateScript({Test-Path $_})]
::         [String]$fileIn,
::         [Parameter(Position=1)]
::         [ValidateNotNull()]
::         [ValidateNotNullOrEmpty()]
::         [String]$fileOut,
::         [Switch]$Clobber
::     )
:: 
::     Process {
::         if ($pscmdlet.ShouldProcess("$fileIn", "Zip file to $fileOut")) {
::             if ($fileIn -eq $fileOut) {
::                 Write-Error "You can't zip a file into itself"
::                 return
::             }
:: 
::             if (Test-Path $fileOut) {
::                 if ($Clobber) {
::                     Remove-Item $fileOut -Verbose -Force
::                 } else {
::                     $ErrorLog = "The output file already exists and the Clobber parameter was not specified. " +
::                                 "Please input a non-existent filename or specify the Clobber parameter"
::                     Write-Error $ErrorLog
::                     return
::                 }
::             }
:: 
::             try {
::                 $fsIn = New-Object System.IO.FileStream(
::                         $fileIn, [System.IO.FileMode]::Open,
::                                  [System.IO.FileAccess]::Read,
::                                  [System.IO.FileShare]::Read)
::                 $fsOut = New-Object System.IO.FileStream(
::                          $fileOut, [System.IO.FileMode]::CreateNew,
::                                    [System.IO.FileAccess]::Write,
::                                    [System.IO.FileShare]::None)
::                 $gzStream = New-Object System.IO.Compression.GZipStream(
::                             $fsout, [System.IO.Compression.CompressionMode]::Compress)
::                 $buffer = New-Object byte[](262144)
:: 
::                 do {
::                     $read = $fsIn.Read($buffer, 0, 262144)
::                     $gzStream.Write($buffer, 0, $read)
::                 }
::                 while ($read -ne 0)
::             }
::             catch {
::                 throw
::             }
::             finally {
::                 if ($fsIn) {
::                     $fsIn.Close()
::                     $fsIn.Dispose()
::                 }
::                 if ($gzStream) {
::                     $gzStream.Close()
::                     $gzStream.Dispose()
::                 }
::                 if ($fsOut) {
::                     $fsOut.Close()
::                     $fsOut.Dispose()
::                 }
::             }
::         }
::     }
:: }
