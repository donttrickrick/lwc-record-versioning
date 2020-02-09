public with sharing class RecordVersionary {
    public final static List<String> ingoreFieldList = new List<String> {
        'Version__c', 'Version_Date__c', 'Version_Snapshot__c', 'Version_History__c',
        'LastReferencedDate', 'LastViewedDate', 'SystemModstamp', 'LastModifiedDate', 'CreatedDate' 
    };

    public static Wrapper increaseVersion(Wrapper currentVersionData) {
        Wrapper newVersionData = new Wrapper();
        Map<String, Object> newRecordMap = currentVersionData.allFieldsRecord.getPopulatedFieldsAsMap().clone();

        // #region calc version number
        if(currentVersionData.version == null) {
            newVersionData.version = 1;
        } else {
            newVersionData.version = currentVersionData.version + 1;
        }
        // #endregion
        // #region calc version date
        newVersionData.versionDate = Datetime.now();
        // #endregion
        // #region calc version snapshot
        for(String field : ingoreFieldList) {
            newRecordMap.remove(field);
        }
        newVersionData.versionSnapshot = JSON.serialize(newRecordMap);
        // #endregion
        // #region calc version history
        if(newVersionData.version == 1) {
            HistoryItem version1Item = new HistoryItem();
            version1Item.version = newVersionData.version;
            version1Item.versionDate = newVersionData.versionDate;

            newVersionData.versionHistory = JSON.serialize(new List<HistoryItem> { version1Item });
        } else {
            Map<String, Object> currentRecordMap = (Map<String, Object>)JSON.deserializeUntyped(currentVersionData.versionSnapshot);
            List<Object> currentHistories = (List<Object>)JSON.deserializeUntyped(currentVersionData.versionHistory);

            HistoryItem history = new HistoryItem();
            history.version = newVersionData.version;
            history.versionDate = newVersionData.versionDate;
            history.changes = new List<ChangedItem>();
            currentHistories.add(history);
            Set<String> allFieldKeySet = new Set<String>();
            allFieldKeySet.addAll(newRecordMap.keySet());
            allFieldKeySet.addAll(currentRecordMap.keySet());
            for(String key : allFieldKeySet) {
                if(!ingoreFieldList.contains(key)) {
                    Object currentValue = currentRecordMap.containsKey(key) ? currentRecordMap.get(key) : null;
                    Object newValue = newRecordMap.containsKey(key) ? newRecordMap.get(key) : null;
                    
                    ChangedItem change = new ChangedItem();
                    if(newValue != currentValue) {
                        change.toValue = newValue;
                        change.fromValue = currentValue;
                        change.field = key;
                        history.changes.add(change);
                    }
                }
            }
            newVersionData.versionHistory = JSON.serialize(currentHistories);
        }
        // #endregion

        return newVersionData;
    }

    public class Wrapper {
        public Decimal version;
        public Datetime versionDate;
        public String versionSnapshot;
        public String versionHistory;
        public SObject allFieldsRecord;
    }

    public class HistoryItem {
        public Decimal version;
        public Datetime versionDate;
        public List<ChangedItem> changes;
    }

    public class ChangedItem {
        public String field;
        public Object fromValue;
        public Object toValue;
    }
}
