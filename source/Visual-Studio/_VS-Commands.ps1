function VS-Open {
    Param (
        [Parameter(ValueFromPipeline=$true)]
        [string] $match="*.sln",
        [string] $folder=".\"
    )
    Begin {
        Write-Host $match
		Get-ChildItem -Filter $match | Write-Host -ForegroundColor Green
    }
    Process {
        ii "$($folder)$($match)"
    }
}

Export-ModuleMember -Function "VS-Open"