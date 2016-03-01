function Invoke-Chris
{
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string] $say,
		[string] $key=1
    )
    Begin {
        $voice = New-Object -ComObject SAPI.SPVoice
    }
    process
    {
        $rate = $voice.Rate
        $voice.Rate = -10
		$voices = $voice.GetVoices('',''); 		
		$cnt = 0
		$voices | % { 
			$cnt = $cnt + 1;
			if ($cnt = $key) {
			#if ($_.Id -eq "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices\Tokens\TTS_MS_EN-GB_HAZEL_11.0") {
				$voice.Voice = $_ 
			}
		}
		#$voice.GetVoices('','') | where $true.Id = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices\Tokens\TTS_MS_EN-GB_HAZEL_11.0"
        #$voice.Speak("$say, chris chris chris, push it, push it real good") | out-null; 
		$voice.Speak("$say, chris") | out-null; 
		
        $voice.Rate = $rate
    }
}


Export-ModuleMember -Function "Invoke-Chris"