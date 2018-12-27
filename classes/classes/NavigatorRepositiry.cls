public with sharing class NavigatorRepositiry {
    public static List<Order> getOrders() {
        return [SELECT Id, TotalAmount, ShippingStreet, ShippingLongitude, ShippingLatitude, ShippingCity, OrderNumber, Status, Contract.Account.Name
                FROM Order
                WHERE Status = 'Activated' AND ShippingLongitude != null AND ShippingLatitude != null LIMIT 10000];
    }
    
    public static List<Contract> getAccounts() {
        return [SELECT Id, Account.ShippingStreet, Account.ShippingLongitude, Account.ShippingLatitude, Account.ShippingCity, Account.Name, Status 
                FROM Contract 
                WHERE Status = 'Activated' AND Account.ShippingLongitude != null AND Account.ShippingLatitude != null LIMIT 10000];
    }
}