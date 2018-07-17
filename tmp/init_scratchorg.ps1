param([string]$alias = (Get-Date).tostring("yyyyMMddhhmmss"))
sfdx force:org:create -f ../config/project-scratch-def.json --setalias $alias --setdefaultusername --wait 2
sfdx force:source:push
sfdx force:user:permset:assign --permsetname Scratch
sfdx force:data:tree:import -f sfdx-out/export-demo-SubscriptionProgram__cs.json
sfdx force:data:tree:import -f sfdx-out/export-demo-Product2s.json
sfdx force:data:tree:import -f sfdx-out/export-demo-Address__cs.json
sfdx force:data:tree:import -f sfdx-out/export-demo-Address__cs2.json
sfdx force:data:tree:import -f sfdx-out/export-demo-EncryptionKey__cs.json