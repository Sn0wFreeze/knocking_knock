################data define
# Define an array of port numbers
$openPorts = 7000, 8000, 9000
$closePorts = 9000, 8000, 7000
# Specify the target server (replace with your actual server)
$nickname = "User"
$server = "8.8.8.8"
$sshport = 22



function TocarPuertos() {

    param(# server's address or domain to connect
    [Parameter(Mandatory=$true, Position=1, HelpMessage="Host to connect.")]
    [ValidatePattern('^([a-z][A-Z]|[0-9]).*')]
    [string]$HostN,
    [Parameter(Mandatory=$true, Position=2, HelpMessage="Ports to connect.")]
    [ValidatePattern('^[0-9].*')]
    [int[]]$Ports
    )

    # Loop through each port and ping it
    foreach ($port in $Ports) {

        (New-Object System.Net.Sockets.TcpClient).ConnectAsync($HostN, $port).Wait(5) | Out-Null

    }

    if ( $? -eq 0 ) {
    
        return 0

    }else{

        return -1
    }

}

function Main() {

    try {

        if ( TocarPuertos $server $openPorts ) {

            Write-Host "Iniciando una conexion ssh al servidor $server."

            Start-Process -FilePath "Powershell.exe" -ArgumentList "ssh", "$nickname@$server", "-p", "$sshport" -Wait -WindowStyle Maximized

            TocarPuertos $server $closePorts

            Write-Host "Cerrando los puertos en el server $server."

            exit(0)

        } else {

            Write-Host "Hubo un error al ejecutar el comando o usted ha sido baneado del server."

            exit(-1)

        }    
        
    }
    catch {
        
        Write-Error -Message "Ha ocurrido un error mientras se tocaban los puertos. Valida tu conexion."
    
    } finally {
        
        exit(0)
    
    }


}

Main