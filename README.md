# LWC Record Versioning

This repo implements the functions of pulishing, versioning and reverting record.

## How to start

Pull the repo on your machine, then run these commands with SFDX:

$ `sfdx force:org:create -f config/project-scratch-def.json --setalias lwcrecordversioning --durationdays 1 --setdefaultusername`

$ `sfdx force:source:push --forceoverwrite`

$ `sfdx force:data:tree:import -p data/data-plan.json`

$ `sfdx force:org:open -p "/lightning/o/Account/list"`

## Folder Structure
```	
data
├── Accounts.json
└── data-plan.json
force-app
└── main
    ├── default
    │   ├── flexipages
    │   │   └── Account_Record_Page.flexipage-meta.xml
    │   ├── layouts
    │   │   └── Account-Account\ Layout.layout-meta.xml
    │   ├── objects
    │   │   └── Account
    │   │       └── fields
    │   │           ├── Version_Date__c.field-meta.xml
    │   │           ├── Version_History__c.field-meta.xml
    │   │           ├── Version_Snapshot__c.field-meta.xml
    │   │           └── Version__c.field-meta.xml
    │   ├── profiles
    │   │   └── Admin.profile-meta.xml
    │   └── quickActions
    │       └── Account.Versioning.quickAction-meta.xml
    └── versioning
        ├── aura
        │   ├── CloseQuickAction
        │   │   ├── CloseQuickAction.cmp
        │   │   ├── CloseQuickAction.cmp-meta.xml
        │   │   └── CloseQuickActionController.js
        │   └── RefreshView
        │       ├── RefreshView.cmp
        │       ├── RefreshView.cmp-meta.xml
        │       └── RefreshViewController.js
        ├── classes
        │   ├── RecordVersionary.cls
        │   ├── RecordVersionary.cls-meta.xml
        │   ├── RecordVersionaryTest.cls
        │   ├── RecordVersionaryTest.cls-meta.xml
        │   ├── VersioningAction.cls
        │   ├── VersioningAction.cls-meta.xml
        │   ├── VersioningActionTest.cls
        │   └── VersioningActionTest.cls-meta.xml
        ├── flows
        │   └── Versioning.flow-meta.xml
        └── lwc
            ├── jsconfig.json
            └── questionnaireVersionHistory
                ├── questionnaireVersionHistory.html
                ├── questionnaireVersionHistory.js
                └── questionnaireVersionHistory.js-meta.xml
```