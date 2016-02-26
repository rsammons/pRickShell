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


Export-ModuleMember -Function "Invoke-Chris"