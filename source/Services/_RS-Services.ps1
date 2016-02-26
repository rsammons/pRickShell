function RS-Delete-Services {
    Param (
        [Parameter(ValueFromPipeline=$true)]
        [string] $match
    )
    Begin {
        RS-Stop-Services $match
    }
    Process {
        Get-WmiObject -Class Win32_Service | where {$_.Name -like "$match"} | % {
            Write-Host $_.Name #($_ | Format-List | Out-String)
            $_.delete()
        }

    }
}

Export-ModuleMember -Function "RS-Delete-Services"

function RS-Stop-Services {
    Param (
        [Parameter(ValueFromPipeline=$true)]
        [string] $match
    )
    Begin {
        Write-Host "Stop Service $match" -ForegroundColor Yellow
    }
    Process {
        get-service | where {$_.Name -like "$match"} | where {$_.Status -eq 'Running'} | stop-service -pass 
    }
}

Export-ModuleMember -Function "RS-Stop-Services"

function RS-Start-Services {
    Param (
        [Parameter(ValueFromPipeline=$true)]
        [string] $match
    )
    Begin {
        Write-Host "Sytart Service $match" -ForegroundColor Yellow
    }
    Process {
        try {
            get-service | where {$_.Name -like "$match"} | where {$_.Status -ne 'Running'} | % { 
                Write-Host $_.Name
                start-service -Verbose $_.Name  
                Start-Sleep -s 5
            } 

            Start-Sleep -s 2

            get-service | where {$_.Name -like "$match"} | where {$_.Status -ne 'Running'} | start-service -pass 
        }
        catch [system.exception] {
            Write-Host $_
        }
    }
}

Export-ModuleMember -Function "RS-Start-Services"

function RS-Restart-Services {
    Param (
        [Parameter(ValueFromPipeline=$true)]
        [string] $match
    )
    Begin {
        Write-Host "Restart Services $match" -ForegroundColor Yellow
    }
    Process {
        RS-Stop-Services $match
        RS-Start-Services $match
    }
}

Export-ModuleMember -Function "RS-Restart-Services"

