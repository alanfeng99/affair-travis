public with sharing class LoginViewModel {

    public Account__c account {get; set;}
    public String sessionString {get; set;}
    
    public LoginViewModel() {
        account = new Account__c();
    }   
}