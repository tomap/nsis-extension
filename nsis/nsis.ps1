param(
    [string]$scriptFile,
    [string]$justInclude,
    [string]$arguments,
	[string]$includeMorePlugins
)

foreach($key in $PSBoundParameters.Keys)
{
    Write-Host ($key + ' = ' + $PSBoundParameters[$key])
}

$path = split-path $MyInvocation.MyCommand.Path


$output = $path + "\nsis.zip"

$destination = $path + "\nsis"

if(!(Test-Path $output)){

	$url = "https://sourceforge.net/projects/nsis/files/NSIS%203/3.01/nsis-3.01.zip/download"
	
    $start_time = Get-Date
    
    $webClient = new-object System.Net.WebClient
    $webClient.Headers.Add("user-agent", "Chrome")
    $webClient.DownloadFile($url, $output)

	Add-Type -assembly "system.io.compression.filesystem"

	[io.compression.zipfile]::ExtractToDirectory($output, $destination)

	$directories = Get-ChildItem -Path $destination
	$nsis3Directory = $directories[0].FullName

	if($includeMorePlugins -eq "yes")
	{
		$pluginPath = $path + "\plugins\*"
		$pluginOutput = $nsis3Directory + "\plugins\x86-ansi"
		Copy-Item $pluginPath $pluginOutput -force
	}
	
    Write-Output "Time taken (DL + unzip): $((Get-Date).Subtract($start_time).Seconds) second(s)"
} else {
	$directories = Get-ChildItem -Path $destination
	$nsis3Directory = $directories[0].FullName
}

$nsis3Exe = $nsis3Directory + "\makensis.exe"

$env:NSIS_EXE = $nsis3Exe
Write-Host("##vso[task.setvariable variable=NSIS_EXE;]$nsis3Exe")

if($justInclude -eq "no")
{
	$args = ''

    if($arguments -notcontains "/V"){
        if($env:Debug -eq "true")
        {
            $args += "/V4 "
        }
        if($env:Debug -eq "false")
        {
            $args += "/V1 "
        }
    }
    $args += $arguments + ' "' + $scriptFile + '"'

    Write-Host("Executing nsis $nsis3Exe with args: $args")

    Invoke-Tool -Path $nsis3Exe -Arguments $args
}
else
{
    Write-Host("Including nsis in variable NSIS_EXE: $nsis3Exe")
}