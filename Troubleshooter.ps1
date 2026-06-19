#requires -Version 5.1
<# Created by Dewald Pretorius #>
param([string]$OutputPath)
if(-not $OutputPath){$OutputPath="$([Environment]::GetFolderPath('Desktop'))\Excel_VBA_Reports"};New-Item $OutputPath -ItemType Directory -Force|Out-Null
$trust=Get-ItemProperty 'HKCU:\Software\Microsoft\Office\16.0\Excel\Security' -ErrorAction SilentlyContinue;$refs=Get-ChildItem 'HKCU:\Software\Microsoft\VBA' -Recurse -ErrorAction SilentlyContinue
$events=Get-WinEvent -FilterHashtable @{LogName='Application';StartTime=(Get-Date).AddDays(-5)} -ErrorAction SilentlyContinue|Where-Object Message -match 'EXCEL|VBA|macro'|Select-Object -First 40 TimeCreated,Id,ProviderName,Message
@('EXCEL MACRO AND VBA TROUBLESHOOTER','Created by Dewald Pretorius',"Generated: $(Get-Date)",'Review Trust Center settings, blocked content, missing references, bitness, signed macros, startup add-ins, and runtime errors.',($trust|Format-List|Out-String -Width 220),($events|Format-List|Out-String -Width 220))|Set-Content (Join-Path $OutputPath 'Report.txt') -Encoding UTF8