@isTest
public with sharing class RecordVersionaryTest {
    // @isTest
    // public static void testIncreaseVersion() {
    //     Pre_KYC_Questionnaire_Community_Setting__c setting = new Pre_KYC_Questionnaire_Community_Setting__c();
    //     setting.KYC_Ops_Email_Group__c = 'test@test.com';
    //     insert setting;

    //     Airwallex_Account__c theAwxAcc = new Airwallex_Account__c(Account_Id__c = 'test account id');
    //     insert theAwxAcc;

    //     Pre_KYC_Questionnaire__c theQuestionnaire = new Pre_KYC_Questionnaire__c(Airwallex_Account__c = theAwxAcc.Id);
    //     insert theQuestionnaire;

    //     String flowParams = JSON.serialize(new Map<String, Object> {
    //         'sfId' => theQuestionnaire.Id,
    //         'abAccountId' => theAwxAcc.Account_Id__c,
    //         'businessName' => 'test business name',
    //         'leadOwnerEmail' => 'test@airwallex.test.com'
    //     });

    //     KYCQuestionnaireVersionaryController.versioningAndNotify(theQuestionnaire.Id, flowParams);

    //     theQuestionnaire.Business_Name_English__c = 'test business name';
    //     KYCQuestionnaireVersionaryController.versioningAndNotify(theQuestionnaire.Id, flowParams);

    // }
}
