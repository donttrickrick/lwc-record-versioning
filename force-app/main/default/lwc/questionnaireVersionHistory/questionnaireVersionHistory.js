import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import VERSION_HISTORY from '@salesforce/schema/Case.Version_History__c';

export default class QuestionnaireVersionHistory extends LightningElement {
    @api recordId;
    @track versionHistory;
    @wire(getRecord, { recordId: '$recordId', fields: [VERSION_HISTORY] })
    wiredRecord({ error, data }) {
        if (error) {
            this.dispatchEvent(new ShowToastEvent({
                variant: 'error',
                message: 'Fail to load version history.',
                title: 'Fail'
            }));
        } else if (data) {
            const historiesJSON = getFieldValue(data, VERSION_HISTORY);
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
}