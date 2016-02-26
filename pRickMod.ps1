#region Git
function RS-Gitall {
    Param (
        [Parameter(ValueFromPipeline=$true)]
        [string] $match="*"
    )
    Begin {
        Write-Host $match
        Install-Module Posh-Git -Force
    }
    Process {
        Get-ChildItem | where {$_.Attributes -eq 'Directory'} | Where {$_.Name -like $match} | % { 
            #Write-Host $_.Name
            Get-Location | Push-Location -StackName base
            cd $_.Name
            $something = $(git rev-parse --is-inside-work-tree) # | Out-String

            if ($something -eq $null -or $something -eq "" ) {
                #Write-Host $something
            } else {
                Write-Host $_.Name -ForegroundColor Green
                git pull

            }
            popd -StackName base
            
        }


    }
}
#endregion

#region Invokde-Chris
function Invoke-Chris
{
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string] $say 
    )
    Begin {
        $voice = New-Object -ComObject SAPI.SPVoice
    }
    process
    {
        $rate = $voice.Rate
        $voice.Rate = -10
        $voice.Speak("$say, chris chris chris, push it, push it real good") | out-null; 
        $voice.Rate = $rate
    }
}
#endregion

#region Service Calls
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
#endregion

#region VS Commands
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


#endregion


#region Export
Export-ModuleMember -Function "RS-Gitall"

Export-ModuleMember -Function "Invoke-Chris"

Export-ModuleMember -Function "RS-Delete-Services"
Export-ModuleMember -Function "RS-Stop-Services"
Export-ModuleMember -Function "RS-Start-Services"
Export-ModuleMember -Function "RS-Restart-Services"

Export-ModuleMember -Function "VS-Open"
#endregion