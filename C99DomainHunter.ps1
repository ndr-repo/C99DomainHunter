# Target Domain - Passed in from system arguments
$targetDomain = $args[0]
# C99.nl API Key
$key = Get-Content ".key"
# File Extensions
$csvExt = ".csv"
$jsonExt = ".json"
# Log Destination Directory
$logDir = "log"
# Scan Time Logging
$startTime = Get-Date
# C99.nl Subdomainfinder API
$privIPLookup = (Invoke-WebRequest -InformationAction SilentlyContinue -Method Get -Uri "https://api.c99.nl/subdomainfinder?key=$key&domain=$targetDomain&server=us&json" -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36").Content | ConvertFrom-Json | Select-Object -ExpandProperty subdomains | Sort-Object -Property "ip" | Where-Object -Property "ip" -NotMatch "^10[.].*" | Format-Table -Wrap -AutoSize -Property "subdomain" -HideTableHeaders | Out-String -Stream | Out-File $logDir/$targetDomain-publicIpSpace.txt utf8 -Force
$total = (Get-Content -Encoding UTF8 $logDir/$targetDomain-publicIpSpace.txt | Out-String -Stream ) -replace ' ','' | Out-String -Stream | Sort-Object -Unique | Out-String -Stream | Select-String -Pattern '.*' | Measure-Object | Select-Object -ExpandProperty Count
# Operator Message
Write-Host "`nC99DomainHunter - v1.0`n`nCreated by Gabriel H.`nhttp://weekendr.me | https://github.com/ndr-repo" -ForegroundColor Red  
Write-Host "`nIdentified $total public hostnames for $targetDomain. Enumerating DNS records...`n" -ForegroundColor Red
# DNS Enumeration 
$domains = (Get-Content -Encoding UTF8 $logDir/$targetDomain-publicIpSpace.txt | Out-String -Stream ) -replace ' ','' | Select-String "$targetDomain" -SimpleMatch
$allResults = @()
foreach ($domain in $domains){
    Write-Progress -Activity "Enumerating DNS for: " -Status "$domain" | Write-Host -ForegroundColor Red
    $resolved = Invoke-RestMethod -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' -Headers @{"Accept"="application/json"} -Method Get -Uri "https://dns.google/resolve?name=$domain&type=ALL"
    $allResults += $resolved
}
$stopTime = Get-Date
# Exporting Results
$allResults | Select-Object -ExpandProperty Answer -ErrorAction Ignore | Sort-Object -Property "name","type","TTL","data" -Unique | Select-Object -Property "name","type","TTL","data" -Unique | Format-Table -AutoSize -Wrap | Out-String -Stream | Write-Host -ForegroundColor Red
$allResults | Select-Object -ExpandProperty Comments -ErrorAction Ignore | Out-File $logDir/$targetDomain-comments$jsonExt utf8 -Force
$allResults | Select-Object -ExpandProperty Answer -ErrorAction Ignore | ConvertTo-Csv -NoTypeInformation | Out-File $logDir/$targetDomain-resolutions$csvExt utf8 -Force
Write-Host "Scan started at $startTime" -ForegroundColor Red
Write-Host "`Scan completed at $stopTime" -ForegroundColor Red
Write-Host "`nC99.nl subdomains saved to $targetDomain-publicIpSpace.txt" -ForegroundColor Red
Write-Host "Resolutions saved to $targetDomain-resolutions$csvExt" -ForegroundColor Red
Write-Host "Comments saved to $targetDomain-comments$jsonExt" -ForegroundColor Red
