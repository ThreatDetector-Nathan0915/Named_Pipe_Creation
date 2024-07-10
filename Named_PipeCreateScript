# Main script execution parameters
param (
    [string]$mode,
    [string]$message
)

# Define the name of the pipe
$pipeName = "\\.\pipe\TDE_TEST_PIPE"

function Create-NamedPipe {
    $pipe = New-Object System.IO.Pipes.NamedPipeServerStream(
        "TDE_TEST_PIPE", 
        [System.IO.Pipes.PipeDirection]::InOut, 
        1, 
        [System.IO.Pipes.PipeTransmissionMode]::Byte, 
        [System.IO.Pipes.PipeOptions]::None, 
        4096, 
        4096
    )

    $pipe.WaitForConnection()
    return $pipe
}

function Write-ToPipe {
    param (
        [string]$message
    )

    $pipeClient = New-Object System.IO.Pipes.NamedPipeClientStream(".", "TDE_TEST_PIPE", [System.IO.Pipes.PipeDirection]::Out)
    $pipeClient.Connect()

    $streamWriter = New-Object System.IO.StreamWriter($pipeClient)
    $streamWriter.AutoFlush = $true
    $streamWriter.WriteLine($message)
    $streamWriter.Close()
    $pipeClient.Close()
}

function Read-FromPipe {
    $pipe = Create-NamedPipe

    $streamReader = New-Object System.IO.StreamReader($pipe)
    while ($true) {
        $message = $streamReader.ReadLine()
        if ($message -ne $null) {
            Write-Host "Received: $message"
        } else {
            break
        }
    }
    $streamReader.Close()
    $pipe.Close()
}

if ($mode -eq "read") {
    Read-FromPipe
} elseif ($mode -eq "write") {
    if ($message -eq $null) {
        Write-Host "Usage: .\NamedPipe.ps1 -mode write -message <your_message>"
        exit
    }
    Write-ToPipe -message $message
} else {
    Write-Host "Usage: .\NamedPipe.ps1 -mode <read|write> [-message <your_message>]"
}
