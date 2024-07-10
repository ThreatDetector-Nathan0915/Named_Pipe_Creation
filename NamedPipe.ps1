# Main script execution parameters
param (
    [string]$mode,
    [string]$message
)

# Define the name of the pipe
$pipeName = "\\.\pipe\TDE_TEST_PIPE"

function Create-NamedPipe {
    Write-Host "Creating named pipe: $pipeName"
    $pipe = New-Object System.IO.Pipes.NamedPipeServerStream(
        "TDE_TEST_PIPE", 
        [System.IO.Pipes.PipeDirection]::InOut, 
        1, 
        [System.IO.Pipes.PipeTransmissionMode]::Byte, 
        [System.IO.Pipes.PipeOptions]::None, 
        4096, 
        4096
    )
    Write-Host "Waiting for client connection..."
    $pipe.WaitForConnection()
    Write-Host "Client connected."
    return $pipe
}

function Write-ToPipe {
    param (
        [string]$message
    )

    Write-Host "Connecting to named pipe: $pipeName"
    $pipeClient = New-Object System.IO.Pipes.NamedPipeClientStream(".", "TDE_TEST_PIPE", [System.IO.Pipes.PipeDirection]::Out)
    $pipeClient.Connect()
    Write-Host "Connected to named pipe."

    $streamWriter = New-Object System.IO.StreamWriter($pipeClient)
    $streamWriter.AutoFlush = $true
    Write-Host "Writing message to pipe: $message"
    $streamWriter.WriteLine($message)
    $streamWriter.Close()
    $pipeClient.Close()
    Write-Host "Message written and pipe closed."
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
    Write-Host "Pipe closed."
}

function Find-NamedPipe {
    $namedPipes = Get-ChildItem -Path \\.\pipe\
    $pipe = $namedPipes | Where-Object { $_.Name -eq "TDE_TEST_PIPE" }

    if ($pipe) {
        Write-Host "Named pipe 'TDE_TEST_PIPE' found:"
        Write-Host "Name: $($pipe.Name)"
    } else {
        Write-Host "Named pipe 'TDE_TEST_PIPE' not found."
    }
}

if ($mode -eq "read") {
    Find-NamedPipe
    Read-FromPipe
    Find-NamedPipe
} elseif ($mode -eq "write") {
    if ($message -eq $null) {
        Write-Host "Usage: .\NamedPipe.ps1 -mode write -message <your_message>"
        exit
    }
    Write-ToPipe -message $message
} else {
    Write-Host "Usage: .\NamedPipe.ps1 -mode <read|write> [-message <your_message>]"
}
