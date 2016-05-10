param(
	[Parameter(Mandatory=$false, ValueFromPipeline=$true)]
	[string]$Image="$PSScriptRoot\GilDrinking-Again.jpg"
)

Begin {

Function Update-Wallpaper {
    Param(
        [Parameter(Mandatory=$true)]
        $Path,
         
        [ValidateSet('Center','Stretch','Fill','Tile','Fit')]
        $Style
    )
    Try {
        if (-not ([System.Management.Automation.PSTypeName]'Wallpaper.Setter').Type) {
            Add-Type -TypeDefinition @"
            using System;
            using System.Runtime.InteropServices;
            using Microsoft.Win32;
            namespace Wallpaper {
                public enum Style : int {
                    Center, Stretch, Fill, Fit, Tile
                }
                public class Setter {
                    public const int SetDesktopWallpaper = 20;
                    public const int UpdateIniFile = 0x01;
                    public const int SendWinIniChange = 0x02;
                    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
                    private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
                    public static void SetWallpaper ( string path, Wallpaper.Style style ) {
                        SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
                        RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
                        switch( style ) {
                            case Style.Tile :
                                key.SetValue(@"WallpaperStyle", "0") ; 
                                key.SetValue(@"TileWallpaper", "1") ; 
                                break;
                            case Style.Center :
                                key.SetValue(@"WallpaperStyle", "0") ; 
                                key.SetValue(@"TileWallpaper", "0") ; 
                                break;
                            case Style.Stretch :
                                key.SetValue(@"WallpaperStyle", "2") ; 
                                key.SetValue(@"TileWallpaper", "0") ;
                                break;
                            case Style.Fill :
                                key.SetValue(@"WallpaperStyle", "10") ; 
                                key.SetValue(@"TileWallpaper", "0") ; 
                                break;
                            case Style.Fit :
                                key.SetValue(@"WallpaperStyle", "6") ; 
                                key.SetValue(@"TileWallpaper", "0") ; 
                                break;
}
                        key.Close();
                    }
                }
            }
"@ -ErrorAction Stop 
            } 
        } 
        Catch {
            Write-Warning -Message "Wallpaper not changed because $($_.Exception.Message)"
        }
    [Wallpaper.Setter]::SetWallpaper( $Path, $Style )
}



	Function Set-Wallpaper {
    [CmdletBinding()]
    Param(  [Parameter(Mandatory=$True,ValueFromPipeline=$true,ValueFromPipelineByPropertyName = $true,Position=0)]
            [string]$Source,
 
            [Parameter(Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName = $true,Position=1)]
            [string]$Selection
    )
    Begin {
        # Select Background colour
        if ($Source -eq "Colour") {
            $BGColour = $Selection
        }
        # If selected, get local pictures
        elseif ($Source -eq "MyPics"){
            Get-MyImages -Path $PicturesPath -Selection $Selection -Resize $ResizeMyPics
            $BGColour = "Existing"
        }

        #If selected, get web pictures
        elseif ($Source -eq "Web"){
            Set-WebProxy
            Get-GoogleImages -SearchTerm $Selection -MaxResults $MaxResults -DaysBetweenSearches $DaysBetweenSearches -Resize $ResizeWebPics
            $BGColour = "Existing"
        }
    }
    Process{
        $oText = Build-TextOverlay $TextOverlay
        $Overlay = @{
            OverlayText = $oText ;        
            TextColour = $TextColour ;  
            FontName = $FontName ;
            FontSize = $FontSize ;
            ApplyHeader = $ApplyHeader ;   
            TextAlign = $TextAlign ;
            Position = $Position    
        }
        
        $Background = @{
            BGType = $source ;   
            BGColour = $BGColour 
        }
    }
    End{
        $WallPaper = New-Wallpaper @Overlay @Background
        Update-Wallpaper -Path $WallPaper.FullName -Style $Style
    }
}

}


Process {
	Update-Wallpaper -Path $Image -Style Stretch
}

