@isTest
public with sharing class VersioningActionTest {
    @isTest
    public static void testVersioning() {
        Account account = new Account();
        account.Name = 'test account';
        insert account;

        VersioningAction.versioning(new List<Id> { account.Id });
    }
}
