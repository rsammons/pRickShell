
    Set-StrictMode -Version latest
    
    # Always run the script with the current script location as the base path
    set-location (Split-Path $MyInvocation.MyCommand.Path)

    if ((Get-ExecutionPolicy) -eq "Restricted") {
        Write-Warning @"
Your execution policy is $executionPolicy, this means you will not be able import or use any scripts including modules.
To fix this change your execution policy to something like RemoteSigned.

        PS> Set-ExecutionPolicy RemoteSigned

For more information execute:

        PS> Get-Help about_execution_policies

"@
    }

    # Include a user module directory in PSModulePath
    function Verify-User-Module-Path {
        $ModulePaths = @($env:PSModulePath -split ';')
        $ExpectedUserModulePath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules
        $Destination = $ModulePaths | Where-Object { $_ -eq $ExpectedUserModulePath }
        if (-not $Destination) {
            $Destination = $ModulePaths | Select-Object -Index 0
        }
        $Destination
    }

    # Install PsGet to the new user module directory
    function Install-PsGet {
        $Destination = Verify-User-Module-Path

        $PsGetPath = Join-Path $Destination  "\PsGet\"

        if ( !( Test-Path $PsGetPath )) {
            New-Item -Path ($Destination + "\PsGet\") -ItemType Directory -Force | Out-Null
        
            Write-Host 'Downloading PsGet from https://github.com/psget/psget/raw/master/PsGet/PsGet.psm1'
            $client = (New-Object Net.WebClient)
            $client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
            $client.DownloadFile("https://github.com/psget/psget/raw/master/PsGet/PsGet.psm1", $Destination + "\PsGet\PsGet.psm1")
        }
        
        Import-Module -Name $Destination\PsGet
    }

    # Use PsGet for module loading
    Install-PsGet 
    
    # Install type requirements
    Add-Type -AssemblyName System.Web

    # Install module requirements
    Install-Module PsUrl
    Install-Module PowerYaml
    #Install-Module PSColor
    Install-Module SplitPipeline

    # Install modules via nuget
    Install-Module -NuGetPackageId psake -PackageVersion '4.4.2' 

    # Install module, but do not import
    Install-Module -ModuleName 'Rick.Sammons' -ModulePath '.\source' -Update -Global -DoNotImport

    # Import module with specific version and skip name checking
    Import-Module 'Rick.Sammons' -Force -DisableNameChecking 


