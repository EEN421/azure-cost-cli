#Connect to Azure
Connect-AzAccount -UseDeviceAuthentication -Tenant xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx

#Pull list of Subscriptions
$ids = Get-AzSubscription -TenantId xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx| Select-Object id,name
$firstid = $ids | Select-Object -first 1
$remainingids = $ids | Select-Object -skip 1

#Create CSV for first subscription with header
$firstoutput = azure-cost costByResource -s $firstid.id -t Custom --from 2023-05-01 --to 2023-05-31 -o csv
Add-Content ".\report.csv" $firstoutput

#Loop through remaining subscriptions and append to CSV
Foreach ($id in $remainingids) {
$output = azure-cost costByResource -s($id.id) -t Custom --from 2023-05-01 --to 2023-05-31 -o csv --skipHeader
Add-Content ".\report.csv" $output
}