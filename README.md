# check_veeam_jobs
Nagios NCPA plugin to check Veeam jobs

Usage:

```PowerShell
.\check_veeam_jobs.ps1 -jobName "job"
```

Configure this plugin in Nagios like this for example :

Command
--------

```text
define command {
    command_name check_ncpa_veeamjobs
    command_line $USER1$/check_ncpa.py -H $HOSTADDRESS$ -t 'your_key' -M 'plugins/check_veeam_jobs.ps1' -a 'job'
}
```

Service
-------

```text
define service {
    use                     generic-service
    host_name               yourserver
    service_description     Job Veeam 1
    check_command           check_ncpa_veeamjobs
    contacts                mailadmin
    max_check_attempts      3
    check_interval          5
    retry_interval          1
}
```

If your job name contains a space (or more), please use pipes to replace the spaces in the definition of the command, otherwise NCPA will not be able to get the job name properly. So for example :

Command
--------

```text
define command {
    command_name check_ncpa_veeamjobs
    command_line $USER1$/check_ncpa.py -H $HOSTADDRESS$ -t 'your_key' -M 'plugins/check_veeam_jobs.ps1' -a 'job|1'
}
```

Will allow NCPA to get the information "job 1". Without this, you will have "job" only. If you have pipes in the name, no problem, just comment :

$jobName = $jobName -replace '\|', ' '

In the ps1 script. Or rename your Veeam job. Or just replace the spaces with another character than pipe. Or feel free to find another solution ;)
