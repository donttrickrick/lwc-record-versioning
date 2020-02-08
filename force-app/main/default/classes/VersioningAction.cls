public with sharing class VersioningAction {
    public static String toString4AllFieldsOfSObject(String sObjectName, String prefix) {
        String stringOfAllFields = '';
        String tokenizer = ', ';

        if(String.isEmpty(prefix)) {
            prefix = '';
        } else {
            if(prefix.endsWithIgnoreCase('__c')) {
                prefix = prefix.replace('__c', '__r.');
            } else if(prefix.endsWithIgnoreCase('__c.')) {
                prefix = prefix.replace('__c.', '__r.');
            }
            if(!prefix.endsWith('.')) {
                prefix += '.';
            }
        } 

        List<String> fieldNameLst = new List<String>();
        for(Schema.SObjectField sobjectField : Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().values()) {
            if(sobjectField.getDescribe().isAccessible()) {
                fieldNameLst.add(prefix + sobjectField.getDescribe().getName());
            }
        }

        for(String fieldName : fieldNameLst) {
            stringOfAllFields += fieldName + tokenizer;
        }
        if(fieldNameLst.size() > 0) {
            stringOfAllFields = stringOfAllFields.removeEnd(tokenizer);
        } 
        
        system.debug('stringOfAllFields:'+stringOfAllFields);
        return stringOfAllFields;
    }

    @InvocableMethod(label='Publish Record' description='Publish Record and Increase Version')
    public static void versioning(List<Id> recordIdList) {
        // Only support single record
        Id theRecordId = recordIdList[0];

        String recordType = theRecordId.getSobjectType().getDescribe().getName();

        SObject theRecord = (Database.query('SELECT ' + toString4AllFieldsOfSObject(recordType, null) + ' FROM ' + recordType + ' WHERE Id = \'' + theRecordId + '\''))[0]; 
        RecordVersionary.Wrapper currentVersionData = new RecordVersionary.Wrapper();
        currentVersionData.version = (Decimal)theRecord.get('Version__c');
        currentVersionData.versionDate = (Datetime)theRecord.get('Version_Date__c');
        currentVersionData.versionSnapshot = (String)theRecord.get('Version_Snapshot__c');
        currentVersionData.versionHistory = (String)theRecord.get('Version_History__c');
        currentVersionData.allFieldsRecord = theRecord;

        RecordVersionary.Wrapper newVersionData = RecordVersionary.increaseVersion(currentVersionData);

        SObject newRecord = theRecordId.getSobjectType().newSObject(theRecordId);
        newRecord.put('Version__c', newVersionData.version);
        newRecord.put('Version_Date__c', newVersionData.versionDate);
        newRecord.put('Version_Snapshot__c', newVersionData.versionSnapshot);
        newRecord.put('Version_History__c', newVersionData.versionHistory);
        update newRecord;
    }
}
