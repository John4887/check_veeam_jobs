<#
.VERSION
1.0.0

.AUTHOR
John Gonzalez
#>

param(
    [string]$jobName,
    [switch]$v
)

# Convert pipes in spaces for job names with spaces
$jobName = $jobName -replace '\|', ' '

# Check for version flag
if ($v) {
    Write-Host "check_veeam_jobs.ps1 - John Gonzalez - 1.0.0"
    exit 0
}

# Check if the job name was specified, if not, return UNKNOWN status
if ($jobName -eq "") {
    Write-Host "UNKNOWN: No backup job name specified. Use -jobName on interactive command or -a in your Nagios service definition."
    exit 3
}

# Try to get the backup job, if not possible return UNKNOWN status
try {
    $job = Get-VBRJob -Name $jobName
    if ($null -eq $job) {
        Write-Host "UNKNOWN: Backup job specified ($jobName) does not exist (bad name?)."
        exit 3
    }
} catch {
    Write-Host "UNKNOWN: Error while recovering the backup job ($jobName). The job does not exist or its name is not correct."
    exit 3
}

# Get job last state and job last result to see if the job is running. If job is running, status is always OK.
$jobStatus = $job.GetLastState()
$jobResult = $job.GetLastResult()

# Evaluate job backup status
if ($jobStatus -eq "Running" -or $jobStatus -eq "Working") {
    Write-Host "OK: Backup job '$jobName' is running."
    exit 0
} elseif ($job.GetLastResult() -eq "Success") {
    Write-Host "OK: Backup job '$jobName' is successful."
    exit 0
} elseif ($job.GetLastResult() -eq "Warning") {
    Write-Host "WARNING: Backup job '$jobName' is finished with warnings."
    exit 1
} else {
    Write-Host "CRITICAL: Backup job '$jobName' failed."
    exit 2
}