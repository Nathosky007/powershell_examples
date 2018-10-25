#Private MSMQ Queues for LndApplic server
$privateQueueNameArray = @("queueName1","queueName2","queueName3","queueName4","queueName5","queueName6","queueName7","queueName8","queueName9")
$Logfile="C:\Users\User1\powershell_examples\msmq-testong.log"

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
    MSMQPrivateQueuesConfig -QueueName $privateQueueNameArray[5] -isTransactional $true  -L $Logfile
    MSMQPrivateQueuesConfig -QueueName $privateQueueNameArray[6] -isTransactional $true  -L $Logfile
    MSMQPrivateQueuesConfig -QueueName $privateQueueNameArray[7] -isTransactional $true  -L $Logfile
    MSMQPrivateQueuesConfig -QueueName $privateQueueNameArray[8] -isTransactional $true  -L $Logfile

}

CreateMSMQPrivateQueues
