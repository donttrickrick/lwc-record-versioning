import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex'; 

export default class QuestionnaireVersionHistory extends LightningElement {
    snapshotJSON;
    @api recordId;
    @api objectApiName;
    @track versionHistory;
    get versionFields() {
        return [this.versionHistoryFieldName, this.versionSnapshotFieldName];
    }
    get versionHistoryFieldName() {
        return this.objectApiName + '.Version_History__c';
    }
    get versionSnapshotFieldName() {
        return this.objectApiName + '.Version_Snapshot__c';
    }
    @wire(getRecord, { recordId: '$recordId', fields: '$versionFields' })
    wiredRecord({ error, data }) {
        if (error) {
            this.dispatchEvent(new ShowToastEvent({
                variant: 'error',
                message: 'Fail to load version history.',
                title: 'Fail'
            }));
        } else if (data) {
            const historiesJSON = getFieldValue(data, this.versionHistoryFieldName);
            this.snapshotJSON = getFieldValue(data, this.versionSnapshotFieldName);
            if (historiesJSON) {
                let histories = JSON.parse(historiesJSON)
                    .sort((a, b) => b.version - a.version)
                    .map(e => Object.assign(e, {
                        versionName: 'Version ' + e.version,
                        isVersionOne: e.version === 1,
                        hasChanges: e.changes && e.changes.length > 0,
                        changes: e.changes ? e.changes.map(oneChange => Object.assign(oneChange, {
                            polishedFieldLabel: oneChange.field.replace(/__c/g, '').replace(/_/g, ' ')
                        })) : null
                    }));
                this.versionHistory = histories;
            }
        }
    }

    handleRevertVersion(event) {
        const selectedVersionNumber = event.target.value;
        const revertedVersions = this.versionHistory
                                .filter(e => e.version >= selectedVersionNumber)
                                .sort((a, b) => b.version - a.version);

        let newRecord = { Id : this.recordId };
        for(const oneVersion of revertedVersions) {
            for(const oneChange of oneVersion.changes) {
                newRecord[oneChange.field] = oneChange.fromValue;
            }
        }

        const newVersionHistory = this.versionHistory.filter(e => e.version < selectedVersionNumber).sort((a, b) => b.version - a.version);
        const newVersion = newVersionHistory[newVersionHistory.length - 1];
        const newSnapshot = Object.assign(JSON.parse(this.snapshotJSON), newRecord);
        newRecord.Version_History__c = JSON.stringify(newVersionHistory);
        newRecord.Version__c = newVersion.version;
        newRecord.Version_Date__c = newVersion.versionDate;
        newRecord.Version_Snapshot__c = JSON.stringify(newSnapshot);

        updateRecord({ fields: newRecord })
        .then(data => {
            this.dispatchEvent(new ShowToastEvent({
                variant: 'success',
                message: 'Revert Successfully.',
                title: 'Success'
            }));
            refreshApex(this.versionHistory);
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                variant: 'error',
                message: 'Revert Failed.',
                title: 'Fail'
            }));
        });
    }
}