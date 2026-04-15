PowerHoneyPot
<br>
# A Simple TCP Honeypot For PowerShell

### ** V1 of this PowerShell script opens up a TCP listener (socket) on every single port on a Windows machine **
### ** V2 of this PowerShell is a stealth honeypot as it doesn't open a listener, but takes note of any port access attempts, writes them to the console and to a local log file. This way the threat actor who kicks off a port scan doesn't see any results, but you do! **


To make this run there are a couple of pre-requisites
* It must be run as Administrator as it listens on 'low ports' which are ports below 1024

* Before running it, the following command must be run in PowerShell as the script is unsigned<br>
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

And finally run the script by typing ./powerhoneypot.ps1



https://www.youtube.com/f1lby

<br><br><br>
Disclaimer; No warranty is given for any inaccuracies, loss of service or otherwise. Use this code responsibly and ethically. Use it according to your local laws. My hovercraft is still full of eels.
<br><br>
