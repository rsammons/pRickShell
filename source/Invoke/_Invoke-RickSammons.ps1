function Invoke-RickSammons {
    [CmdletBinding()]
    Param (
        [string]$name
    )
    Begin {

    }
    Process {
        Write-Host $name
    }
}

Export-ModuleMember -Function "Invoke-RickSammons"
