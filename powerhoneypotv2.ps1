# Power HoneyPot - F1lby 2026 v2

# Before running this script, ensure you first run Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
#
# Excuse my bad coding - I'm not a programmer, so sometimes my code is a bit rubbish... ha
#
Write-Host "Power Honey Pot In Stealth Mode!" -ForegroundColor Yellow

#
# --- CONFIG - CHANGE THESE TO SUIT YOUR SYSTEM!! ---
$localIP = "192.168.1.32" # <--- YOU MUST CHANGE THIS to your actual local IP address!
$logFile = "$PSScriptRoot\powerhoneypot.log"

Write-Host "[*] Initialise all sockets powerhoneypot on $localIP..." -ForegroundColor Cyan

# Initialising sockets
try {
    $socket = New-Object System.Net.Sockets.Socket(
        [System.Net.Sockets.AddressFamily]::InterNetwork,
        [System.Net.Sockets.SocketType]::Raw,
        [System.Net.Sockets.ProtocolType]::IP
    )



    $endpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Parse($localIP), 0)
    $socket.Bind($endpoint)


    # capture all incoming packets (I borrowed this code from another Github project so I claim no originality here

    $SioRcvAll = [BitConverter]::GetBytes([uint32]1)
    $socket.IOControl([System.Net.Sockets.IOControlCode]::ReceiveAll, $SioRcvAll, $null) | Out-Null

    Write-Host "[V] Monitoring ALL TCP Ports. Logging to $logFile..." -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop." -ForegroundColor Gray

    $buffer = New-Object byte[] 4096

    while ($true) {
        $bytesRead = $socket.Receive($buffer)
        
        # IP Header is 20 bytes. TCP Header starts at index 20.
        # Protocol 6 is TCP
        $protocol = $buffer[9]
        
        if ($protocol -eq 6) {
            # Extract Source IP (Bytes 12-15)
            $srcIP = "$($buffer[12]).$($buffer[13]).$($buffer[14]).$($buffer[15])"
            
            # Extract Destination Port (Bytes 22-23)
            $destPort = [System.Net.IPAddress]::NetworkToHostOrder([BitConverter]::ToInt16($buffer, 22))
            
            # Check TCP Flags (Offset 33) - Only grab syn packets
            # filter existing traffic and only log NEW connections - use TCP flag 2
            $flags = $buffer[33]
            if ($flags -eq 2) {
                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $logEntry = "[$timestamp] TCP SYN Detected | Source: $srcIP | Target Port: $destPort"
                
                Write-Host $logEntry -ForegroundColor Red
                $logEntry | Out-File -FilePath $logFile -Append
            }
        }
    }
}
catch {
    Write-Host "[-] Error: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "[!] F1lby says ensure you've local admin privs and are using the correct local IP address. Failing to do this will result in this not working!" -ForegroundColor Red
}
finally {
    if ($socket) { $socket.Close() }
}