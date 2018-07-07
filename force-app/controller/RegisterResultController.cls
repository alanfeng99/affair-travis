public with sharing class RegisterResultController {
    public RegisterResultViewModel viewModel {get; set;}


    public RegisterResultController() {
        String accountId = ApexPages.currentPage().getParameters().get('id');     
        viewModel = new RegisterResultViewModel(accountId);

    }
}
