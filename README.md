# PowerShell Named Pipe Exploitation Scripts

This repository contains PowerShell scripts and a batch file designed to interact with and exploit named pipes for inter-process communication (IPC). Named pipes can be a vector for security vulnerabilities if not properly secured. These scripts demonstrate how to find, interact with, and potentially exploit named pipes.

## Scripts Overview

### FindPipe.txt

**Purpose**: Find and list specific named pipes.

**Functionality**:
- Lists all named pipes on the system.
- Filters to find a named pipe named "TDE_TEST_PIPE".
- Outputs the details if the named pipe is found.

### NamedPipe.ps1

**Purpose**: Interact with named pipes.

**Functionality**:
- Creates, connects to, and communicates through named pipes.
- Uses the named pipe to send and receive data between processes.

### RunNamedPipe.bat

**Purpose**: Execute the `NamedPipe.ps1` script.

**Functionality**:
- A batch file to run the PowerShell script for named pipe operations.
- Ensures the script is executed in a proper environment.

### Detailed Explanation of Named Pipe Vulnerabilities

#### Vulnerabilities in Named Pipes

Named pipe vulnerabilities arise when permissions are not correctly set, allowing unauthorized users to access or manipulate the pipe. Common issues include:

- **Insecure Permissions**: Pipes that grant access to low-privileged users.
- **Impersonation**: Attackers can impersonate higher-privileged users if the pipe allows it.
- **Data Interception**: Sensitive data transmitted through the pipe can be intercepted.

#### Obfuscation Techniques

To evade detection, attackers might employ several obfuscation techniques:

- **Encoding**: Commands and payloads are encoded to avoid detection by security tools.
- **Dynamic Code Execution**: Code is generated and executed at runtime to make static analysis difficult.
- **Command Splitting**: Breaking commands into smaller segments that are executed sequentially to avoid detection by pattern-matching algorithms.
