Function New-Color{

Param(
  [Parameter(Mandatory=$True)]
  [String]$ColorName,
  [Parameter(Mandatory=$True)]
  [Int]$Red,
  [Parameter(Mandatory=$True)]
  [Int]$Green,
  [Parameter(Mandatory=$True)]
  [Int]$Blue
)
#Generate a New Color Object from RGB Values, Colorname should always be ColorTable##

  $properties = @{
    Name = $ColorName
    R = $Red
    G = $Green
    B = $Blue
    RGB = ('{0:X2}' -f $Red) + ('{0:X2}' -f $Green) + ('{0:X2}' -f $Blue)
    DWORD = ('{0:X2}' -f $Blue) + ('{0:X2}' -f $Green) + ('{0:X2}' -f $Red)
  }
  
  $Color = New-Object -TypeName PSObject -Property $properties
  Write-Output $Color

}

Function New-RegColor{

Param(
  [Parameter(Mandatory=$True)]
  [String]$ColorName,
  [Parameter(Mandatory=$True)]
  [Int]$DWORD
)
#Return a Color Object from Reading the Current User registry settings

  $Hex = '{0:X6}' -f $DWORD

  $Blue = [Convert]::toInt32($Hex.Substring(0,2), 16)
  $Green = [Convert]::toInt32($Hex.Substring(2,2), 16)
  $Red = [Convert]::toInt32($Hex.Substring(4,2), 16)


  $properties = @{
    Name = $ColorName
    R = $Red
    G = $Green
    B = $Blue
    RGB = $Hex.Substring(4,2) + $Hex.Substring(2,2) + $Hex.Substring(0,2)
    DWORD = $DWORD
  }
  
  $Color = New-Object -TypeName PSObject -Property $properties
  Write-Output $Color

}

Function Get-CurrentColorSetting{
  
  #Reads the current Color Mapping from the Registry
  #Use 'Get-CurrentColorSetting | Create-RegFile' to create a backup

  $RegSettings = (Get-ItemProperty HKCU:\Console).psobject.properties | ?{$_.Name -like 'ColorTable*'}
  $CurrentColors= [System.Collections.ArrayList]@()
  Foreach ($Color in $RegSettings){
    $i = New-RegColor -ColorName $Color.Name -DWORD $Color.Value
    $CurrentColors.Add($i) | Out-null
   
  }
  Write-Output $CurrentColors
}

Function Create-RegFile {
    
    Param(
      [Parameter(Mandatory=$True)]
      [PSObject]$ColorMap
    )
    #Should be a full set of 16 Color or RegColor returns
    Write-Output "Windows Registry Editor Version 5.00"
    Write-Output "[HKEY_CURRENT_USER\Console]"
    foreach($Color in $ColorMap)
    {
      Write-Output "`"$($Color.Name)`"=dword:00$("{0:x6}" -f $Color.DWORD)"
    }
}
