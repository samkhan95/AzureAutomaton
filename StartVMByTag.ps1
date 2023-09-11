

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process 

# Connect using a Managed Service Identity
$AzureContext = (Connect-AzAccount -Identity).context

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription `
    -DefaultProfile $AzureContext

$vms = get-azvm | Where-Object {$_.Tags['LabGroup'] -eq 'autostart'}

# Start shut dowm VM's
foreach ($vm in $vms) {
    $status = (get-azvm -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -status).statuses[1].code
    if ($status -ne "PowerState/running") {
        Write-Output "Starting VM $vm.name "
        start-azvm $vm.Name -ResourceGroupName $vm.ResourceGroupName -NoWait
    }
}