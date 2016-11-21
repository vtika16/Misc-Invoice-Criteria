##identify credit devices##
UPDATE [Misc Invoice Monthly Data] INNER JOIN [Misc Invoice Total] 
ON [Misc Invoice Monthly Data].SubLease_Lease_Number = [Misc Invoice Total].SubLease_Lease_Number SET [Misc Invoice Monthly Data].[Credit (Y/N)] = "Yes", 
[Misc Invoice Monthly Data].[Credit Warehouse Receipt Date] = [Misc Invoice Monthly Data].[Warehouse_Receipt_Date], 
[Misc Invoice Monthly Data].[Credit Warehouse Grade] = [Misc Invoice Monthly Data].[Warehouse_Grade]
WHERE ((([Misc Invoice Monthly Data].[Credit (Y/N)]) Is Null) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Not Null 
And ([Misc Invoice Monthly Data].[Previously Invoiced]) Not Like "*Received*"));

#Received - Qualified devices#
UPDATE [Misc Invoice Monthly Data] SET [Misc Invoice Monthly Data].[Misc Invoice Treatment] = "Oct Received - Qualified"
WHERE ((([Misc Invoice Monthly Data].[Misc Invoice Treatment]) Is Null) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Null) 
AND (([Misc Invoice Monthly Data].Warehouse_Grade)="A" 
Or ([Misc Invoice Monthly Data].Warehouse_Grade)="B" 
Or ([Misc Invoice Monthly Data].Warehouse_Grade)="C") 
AND (([Misc Invoice Monthly Data].[Warehouse Graded Date])>#10/2/2016#));

#Received - Not Qualified Devices#
UPDATE [Misc Invoice Monthly Data] SET [Misc Invoice Monthly Data].[Misc Invoice Treatment] = "Oct Received - Not qualified"
WHERE ((([Misc Invoice Monthly Data].[Misc Invoice Treatment]) Is Null) 
AND (([Misc Invoice Monthly Data].Warehouse_Grade)="D" 
Or ([Misc Invoice Monthly Data].Warehouse_Grade)="E" 
Or ([Misc Invoice Monthly Data].Warehouse_Grade)="BER") 
AND (([Misc Invoice Monthly Data].[Warehouse Graded Date])>#10/2/2016#) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Null));


#PPO Devices (2 instances based on contract language)#
UPDATE [Misc Invoice Monthly Data] SET [Misc Invoice Monthly Data].[Misc Invoice Treatment] = "Oct PPO"
WHERE ((([Misc Invoice Monthly Data].[Misc Invoice Treatment]) Is Null) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Null) 
AND (([Misc Invoice Monthly Data].Puerto_Rico_IND)=0) 
AND (([Misc Invoice Monthly Data].Lease_Event) Like "*Purchase*") 
AND (([Misc Invoice Monthly Data].SPT_PPO_Percent_PaidAdjusted)>=1 
And ([Misc Invoice Monthly Data].SPT_PPO_Percent_PaidAdjusted)>=1) 
AND (([Misc Invoice Monthly Data].Warehouse_Receipt_Date) Is Null)) 
OR ((([Misc Invoice Monthly Data].[Misc Invoice Treatment]) Is Null) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Null) 
AND (([Misc Invoice Monthly Data].Puerto_Rico_IND)=0) 
AND (([Misc Invoice Monthly Data].Warehouse_Receipt_Date) Is Null) 
AND (([Misc Invoice Monthly Data].Percent_PPO_Paid_Bucket) Like "100%+*") 
AND (([Misc Invoice Monthly Data].Lease_Status)="Closed" 
Or ([Misc Invoice Monthly Data].Lease_Status)="Cancelled") 
AND (([Misc Invoice Monthly Data].Lease_Status_Reason) Not Like "*BNKRCY*" 
And ([Misc Invoice Monthly Data].Lease_Status_Reason) Not Like "*ASNOCA*") 
AND (([Misc Invoice Monthly Data].Months_Since_Current_Status)>1));

#Non-receipt from Customer devices#
UPDATE [Misc Invoice Monthly Data] SET [Misc Invoice Monthly Data].[Misc Invoice Treatment] = "Oct Non-receipt A (From Customer)"
WHERE ((([Misc Invoice Monthly Data].[Misc Invoice Treatment]) Is Null) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Null) 
AND (([Misc Invoice Monthly Data].Months_Since_Current_Status)>1) 
AND (([Misc Invoice Monthly Data].Lease_Event) Not Like "*Ownership*" 
And ([Misc Invoice Monthly Data].Lease_Event) Not Like "*Collections" 
And ([Misc Invoice Monthly Data].Lease_Event) Not Like "*Purchase*" 
And ([Misc Invoice Monthly Data].Lease_Event) Not Like "*Fraud*" 
And ([Misc Invoice Monthly Data].Lease_Event) Not Like "*Military*" 
And ([Misc Invoice Monthly Data].Lease_Event) Not Like "*Return Confirm*") 
AND (([Misc Invoice Monthly Data].Lease_Status)="Closed" 
Or ([Misc Invoice Monthly Data].Lease_Status)="Cancelled")
AND (([Misc Invoice Monthly Data].Lease_Status_Reason)<>"BNKRCY" 
And ([Misc Invoice Monthly Data].Lease_Status_Reason)<>"DECSED" 
And ([Misc Invoice Monthly Data].Lease_Status_Reason)<>"ULHLTC") 
AND (([Misc Invoice Monthly Data].Warehouse_Grade) Like "*Not Graded*") 
AND (([Misc Invoice Monthly Data].Puerto_Rico_IND)=0));

##Non-receipts from Sprint##
UPDATE [Misc Invoice Monthly Data] SET [Misc Invoice Monthly Data].[Misc Invoice Treatment] = "Oct Non-receipt B (From Sprint)"
WHERE ((([Misc Invoice Monthly Data].[Misc Invoice Treatment]) Is Null) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Null) 
AND (([Misc Invoice Monthly Data].Months_Since_Current_Status)>1) 
AND (([Misc Invoice Monthly Data].Lease_Event) Not Like "*Ownership*" 
And ([Misc Invoice Monthly Data].Lease_Event) Not Like "*Collections" 
And ([Misc Invoice Monthly Data].Lease_Event) Not Like "*Purchase*" 
And ([Misc Invoice Monthly Data].Lease_Event) Not Like "*Fraud*" 
And ([Misc Invoice Monthly Data].Lease_Event) Not Like "*Military*" 
And ([Misc Invoice Monthly Data].Lease_Event) Like "*Return Confirm*") 
AND (([Misc Invoice Monthly Data].Lease_Status)="Closed" 
Or ([Misc Invoice Monthly Data].Lease_Status)="Cancelled") 
AND (([Misc Invoice Monthly Data].Lease_Status_Reason)<>"BNKRCY" 
And ([Misc Invoice Monthly Data].Lease_Status_Reason)<>"DECSED" 
And ([Misc Invoice Monthly Data].Lease_Status_Reason)<>"ULHLTC") 
AND (([Misc Invoice Monthly Data].Warehouse_Grade) Like "*Not Graded*") 
AND (([Misc Invoice Monthly Data].Puerto_Rico_IND)=0));


##Change of Ownership Devices##
UPDATE [Misc Invoice Monthly Data] SET [Misc Invoice Monthly Data].[Misc Invoice Treatment] = "Oct Change of Ownership"
WHERE ((([Misc Invoice Monthly Data].[Misc Invoice Treatment]) Is Null) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Null) 
AND (([Misc Invoice Monthly Data].Puerto_Rico_IND)=0) 
AND (([Misc Invoice Monthly Data].Lease_Event) Like "*Ownership*") 
AND (([Misc Invoice Monthly Data].Lease_Status) Like "Closed" 
Or ([Misc Invoice Monthly Data].Lease_Status)="Cancelled") 
AND (([Misc Invoice Monthly Data].Months_Since_Current_Status)>1) 
AND (([Misc Invoice Monthly Data].Warehouse_Receipt_Date) Is Null));

##Military Devices##
UPDATE [Misc Invoice Monthly Data] SET [Misc Invoice Monthly Data].[Misc Invoice Treatment] = "Oct Military"
WHERE ((([Misc Invoice Monthly Data].[Misc Invoice Treatment]) Is Null) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Null) 
AND (([Misc Invoice Monthly Data].Puerto_Rico_IND)=0) 
AND (([Misc Invoice Monthly Data].Lease_Event) Like "*Military*") 
AND (([Misc Invoice Monthly Data].Warehouse_Receipt_Date) Is Null));


##Fraud Devices##
UPDATE [Misc Invoice Monthly Data] SET [Misc Invoice Monthly Data].[Misc Invoice Treatment] = "Oct Fraud"
WHERE ((([Misc Invoice Monthly Data].[Misc Invoice Treatment]) Is Null) 
AND (([Misc Invoice Monthly Data].[Previously Invoiced]) Is Null) 
AND (([Misc Invoice Monthly Data].Puerto_Rico_IND)=0) 
AND (([Misc Invoice Monthly Data].Warehouse_Receipt_Date) Is Null) 
AND (([Misc Invoice Monthly Data].Lease_Event) Like "*Fraud*"));















