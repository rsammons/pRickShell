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
                Write-Host $_.Name
                git pull

            }
            popd -StackName base
            
        }


    }
}

Export-ModuleMember -Function "RS-Gitall"