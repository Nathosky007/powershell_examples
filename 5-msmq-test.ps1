<#Author: Sainath M
 Date: 17062018
 Name: 5-msmq-test.ps1
 Purpose: Create Private Message queues and add permissions to them
 License: MIT License
#>

$privateQueueNameArray = @("queue1","queue2","queue3","queue4","queue5")
$Logfile=<log file location>

Function MSMQPrivateQueuesConfig  {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]
        $QueueName,

        [Parameter(Mandatory=$true)]
        [bool]
        $isTransactional,

        [Parameter(Mandatory=$false)]
        [Alias("L")]
        [string]
        $Logfile

)

[Reflection.Assembly]::LoadWithPartialName("System.Messaging")
     $fullQueueName = ".\private$\" + $QueueName

    If ([System.Messaging.MessageQueue]::Exists($fullQueueName))

    {
        echo "$($fullQueueName) queue already exists" > $Logfile
    }

    else
    {
        $newQ = [System.Messaging.MessageQueue]::Create($fullQueueName,$isTransactional)

        $newQ.SetPermissions("Everyone", [System.Messaging.MessageQueueAccessRights]::FullControl, [System.Messaging.AccessControlEntryType]::Allow)
        echo "MSMQ Queue creation completed for $($QueueName)" >> $Logfile
    }

}

Function CreateMSMQPrivateQueues{

    MSMQPrivateQueuesConfig -QueueName $privateQueueNameArray[0] -isTransactional $true  -L $Logfile
    MSMQPrivateQueuesConfig -QueueName $privateQueueNameArray[1] -isTransactional $false -L $Logfile
    MSMQPrivateQueuesConfig -QueueName $privateQueueNameArray[2] -isTransactional $false -L $Logfile
    MSMQPrivateQueuesConfig -QueueName $privateQueueNameArray[3] -isTransactional $true  -L $Logfile
    MSMQPrivateQueuesConfig -QueueName $privateQueueNameArray[4] -isTransactional $true  -L $Logfile

}

CreateMSMQPrivateQueues
