public with sharing class ChangePasswordController extends ApexBaseController {
    public ChangePasswordViewModel viewModel {get; set;}
    public String isActive {get; set;}

    public ChangePasswordController() {
        String accountId = ApexPages.currentpage().getparameters().get('id');
        viewModel = new ChangePasswordViewModel(accountId);
    }

    public PageReference submitForm() {
        if (viewModel.submit() == true) {
            if(isActive != null){
                viewModel.account.Active__c = Boolean.valueOf(isActive);  
                update viewModel.account;  
            }
            addMessage(ApexPages.Severity.INFO, '密碼更新成功');
            
            return AuthUtility.logOut();

        } else {
            addMessage(ApexPages.Severity.ERROR, viewModel.getErrorMessage());
        }
        return null;
    }
}