public with sharing class RegisterViewModel {
    public Account__c account {get; set;}

    public enum RegisterType {
        Email,
        Facebook,
        Google
    }

    public RegisterViewModel() {
        account = new Account__c();
    }
}