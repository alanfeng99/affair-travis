public with sharing class EncryptionUtility {
    public static String encrypt(String toEncrypt){
        List<EncryptionKey__c> encryptionKeys = [SELECT Key__c FROM EncryptionKey__c WHERE Name = 'EncryptionKeyPkcs8'];
        Blob cryptoKey = EncodingUtil.base64Decode(encryptionKeys.get(0).key__c);
        
        Blob data = Blob.valueOf(toEncrypt);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
        String encryptedDataStr = EncodingUtil.base64Encode(encryptedData);

        return encryptedDataStr;
    }

    public static String decrypt(String toDecrypt) {
        Blob encryptedData = EncodingUtil.base64Decode(toDecrypt);
        
        List<EncryptionKey__c> encryptionKeys = [SELECT Key__c FROM EncryptionKey__c WHERE Name = 'EncryptionKeyPkcs8'];
        Blob cryptoKey = EncodingUtil.base64Decode(encryptionKeys.get(0).key__c);
        
        Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedData);

        return decryptedData.toString();
    }
}