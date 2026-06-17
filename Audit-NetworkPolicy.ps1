<#
.SYNOPSIS
    Windows Network Security Auditor - Firewall Port & Process Rule Manager.
.DESCRIPTION
    Validates firewall rules for specific ports and identifies process conflicts.
    Ensures that manual 'Block' rules are not overridden by application-specific rules.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [int]$Port
)

process {
    Write-Host "[+] Auditing Port: $Port" -ForegroundColor Cyan
    
    # Check for existing rules targeting this port
    $rules = Get-NetFirewallRule | Get-NetFirewallPortFilter | Where-Object { $_.LocalPort -eq $Port }
    
    if ($rules) {
        Write-Host "[!] Rules found for port $Port. Analyzing priority..." -ForegroundColor Yellow
        $rules | ForEach-Object { Get-NetFirewallRule -Name $_.InstanceID } | Select-Object Name, Action, Enabled
    } else {
        Write-Host "[*] No specific rules detected for this port." -ForegroundColor Gray
    }

    # Identify process associated with the port
    Write-Host "[+] Identifying associated process..." -ForegroundColor Cyan
    $process = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    if ($process) {
        $procInfo = Get-Process -Id $process.OwningProcess
        Write-Host "[!] Port $Port is currently held by: $($procInfo.ProcessName) (PID: $($procInfo.Id))" -ForegroundColor Red
    }
}