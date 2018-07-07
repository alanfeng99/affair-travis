public with sharing class AccountModel {
    public static Account__c getAccountById(String userId) {
        return [Select Active__c, Locked__c, Email__c, LastName__c, Password__c, JoinDate__c from Account__c where Id = :userId];
    }

    public static Account__c getAccountByEmail(String email) {
        List<Account__c> accounts = [Select Id,  Locked__c, Active__c, Email__c, LastName__c, Password__c from Account__c where Email__c = :email];
        if (accounts.size() > 0) {
            return accounts.get(0);
        } else { 
            return null;
        }
    }

    public static void lockAccountForThreeTimes(Account__c account) {
        account.Locked__c = true;
        update account;
    }

    public static String saveToken(Account__c account) {
        String token = AuthUtility.generateToken();
        account.Token__c = token;
        update account;
        return token;
    }
}