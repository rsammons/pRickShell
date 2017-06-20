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

function RS-GitMerge {
    Param (
        [Parameter(ValueFromPipeline=$true)]
        
		[string] $FromBrach = "dev"
    )
    Begin {        
        Install-Module Posh-Git -Force
		[System.Collections.ArrayList] $localbranches = RS-PullAllBranches
    }
    Process {

		$localbranches | % {
			Write-Host $_
			git checkout $_ | Out-Null
			Start-Sleep -s 5
			git merge $FromBrach 
			
		}
    }
}

function RS-PullAllBranches() {
	$branches = git branch
	[System.Collections.ArrayList] $localbranches = @()
	foreach($branch in $branches){
		$fixedBranch = $branch.Substring(2, $branch.Length - 2)
		$trackedExpression = "branch." + $fixedBranch + ".merge"
		$trackedBranch = git config --get $trackedExpression
		#  Write-Host($trackedBranch)
		if([string]::IsNullOrEmpty($trackedBranch))
		{
			[void]$localbranches.Add($fixedBranch)
		}	
	}

	return $localbranches
}

Export-ModuleMember -Function "RS-Gitall"
Export-ModuleMember -Function "RS-GitMerge"
Export-ModuleMember -Function "RS-PullAllBranches"