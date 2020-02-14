@isTest
public with sharing class RecordVersionaryTest {
    @isTest
    public static void testIncreaseVersion() {
        Account account = new Account();
        account.Name = 'test account';
        insert account;

        SObject theRecord = (Database.query('SELECT ' + VersioningAction.toString4AllFieldsOfSObject('Account', null) + ' FROM Account WHERE Id = \'' + account.Id + '\''))[0]; 
        
        RecordVersionary.Wrapper currentVersionData = new RecordVersionary.Wrapper();
        currentVersionData.version = (Decimal)theRecord.get('Version__c');
        currentVersionData.versionDate = (Datetime)theRecord.get('Version_Date__c');
        currentVersionData.versionSnapshot = (String)theRecord.get('Version_Snapshot__c');
        currentVersionData.versionHistory = (String)theRecord.get('Version_History__c');
        currentVersionData.allFieldsRecord = theRecord;

        RecordVersionary.Wrapper newVersionData = RecordVersionary.increaseVersion(currentVersionData);
    }
}
