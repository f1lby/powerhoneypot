# Power HoneyPot - F1lby 2026
# Before running this script ensure you've run Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
#This is needed as the script is unsigned.
# Define the range of ports

$startPort = 1
$endPort = 65535
$listeners = @()

Write-Host "Starting listeners on ports $startPort to $endPort..." -ForegroundColor Cyan
Write-Host "This script is not efficient and may slow down your computer or consume too much memory!"
Write-Host "Press Ctrl+C to end this script." -ForegroundColor Yellow


foreach ($port in $startPort..$endPort) {
    try {
        # Create the listener for all network interfaces
        $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $port)
        $listener.Start()
        $listeners += $listener
        
        # Optional: Print port listener progress for every 1000 ports to help avoid console lag
        if ($port % 1000 -eq 0) { Write-Host "Opened up to port $port..." }
    }
#    catch {
#        # This usually happens if a port is already in use by the system
#        Write-Verbose "Could not open port $port: $($_.Exception.Message)"
#    }

catch {
        # Using ${} This helps ensure PowerShell knows where the variable name ends
        Write-Verbose "Could not open port ${port}: $($_.Exception.Message)"
        continue 
    }


}

Write-Host "All available ports are now listening." -ForegroundColor Green

# Keep the script alive so the sockets stay open
try {
    while ($true) { Start-Sleep -Seconds 1 }
}
finally {
    # Cleanup: Close all sockets when you stop the script
    Write-Host "`nClosing all listeners..." -ForegroundColor Red
    foreach ($l in $listeners) { $l.Stop() }
}
# If lots of ports stay open after the script ends, close PowerShell entirely to forcefully terminate any errant processes!