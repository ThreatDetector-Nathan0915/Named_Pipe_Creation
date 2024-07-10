# Main script execution parameters
param (
    [string]$mode
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
    Write-Host "Named pipe created: $pipeName"
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
    Write-Host "Writing message to pipe: $message"
    $streamWriter.WriteLine($message)
    $streamWriter.Flush()
    $streamWriter.Close()
    $pipeClient.Close()
}

function Read-FromPipe {
    while ($true) {
        $pipe = Create-NamedPipe
        $pipe.WaitForConnection()

        $streamReader = New-Object System.IO.StreamReader($pipe)
        while ($true) {
            try {
                $message = $streamReader.ReadLine()
                if ($message -ne $null) {
                    Write-Host "Received: $message"
                } else {
                    break
                }
            } catch {
                Write-Host "Error reading from pipe: $_"
                break
            }
        }
        $streamReader.Close()
        $pipe.Close()
        Start-Sleep -Milliseconds 100
    }
}

function Find-NamedPipe {
    while ($true) {
        $namedPipes = Get-ChildItem -Path \\.\pipe\
        $pipe = $namedPipes | Where-Object { $_.Name -eq "TDE_TEST_PIPE" }

        if ($pipe) {
            Write-Host "Named pipe 'TDE_TEST_PIPE' found:"
            Write-Host "Name: $($pipe.Name)"
        } else {
            Write-Host "Named pipe 'TDE_TEST_PIPE' not found."
        }
        Start-Sleep -Seconds 5
    }
}

function Start-Writer {
    while ($true) {
        $message = Read-Host "Enter your message"
        if ($message -ne $null -and $message.Trim() -ne '') {
            Write-ToPipe -message $message
        }
    }
}

if ($mode -eq "read") {
    Start-Job -ScriptBlock { Find-NamedPipe }
    Read-FromPipe
} elseif ($mode -eq "write") {
    Start-Writer
} else {
    Write-Host "Usage: .\NamedPipe.ps1 -mode <read|write>"
}
