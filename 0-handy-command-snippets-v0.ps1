#Useful cmd snippets

#1 get MSMQ message counts
gwmi -class Win32_PerfRawData_MSMQ_MSMQQueue | sort-object -Property PSComputerName,Name | format-table Displayname, MessagesInQueue, PSComputerName

#2 rename a username
wmic useraccount where name="y" rename "z"