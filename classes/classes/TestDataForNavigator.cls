public class TestDataForNavigator {
    
    public static void createTestData() {
        
        Account a = new Account(Name = 'TestNavigator');
        insert a;
        
        Contract c = new Contract(
        	Status = 'Draft',
            AccountId = a.Id,
            StartDate = Date.today(),
            ContractTerm = 5
        );
        insert c;
        
        c.Status = 'Activated';
        update c;
        
        Product2 prod = new Product2(
            Name = 'TestNavigatorProduct', 
            Family = 'Hardware');
        insert prod;
        
        Id pricebookId;
        
        if (Test.isRunningTest()){
        	pricebookId = Test.getStandardPricebookId();
        } else {
            Pricebook2 stdPriceBook = [select id, name from Pricebook2 where isStandard = true limit 1];
            pricebookId = stdPriceBook.Id;
        } 
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;       
        
        List<Order> orders = new List<Order>();
        for(Integer i = 0; i < 2; i++) {
            orders.add(new Order(
                Name = 'TestNavigatorOrder' + i,
                AccountId = a.Id,
                ContractId = c.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pricebookId,
                ShippingCity = 'Lynchburg',
                ShippingStreet = '501-620 Federal St'
            ));
        }
        insert orders;
        List<OrderItem> oi = new List<OrderItem>();
        for(Order order : orders) {
            oi.add(new OrderItem(
            	Product2Id = prod.Id,
                OrderId = order.Id,
                PricebookEntryId = standardPrice.Id,
                Quantity = 50.0,
                UnitPrice = 15000
            ));
        }
        
        orders[1].ShippingCity = 'Indianapolis, IN';
        orders[1].ShippingStreet = '2055 N Senate Ave';
        
        insert oi;
        update orders;
        
        insert new StockLocations__c(Name = 'TestNavigatorSettings', Street__c = '17 E Monroe St', Sity__c = 'Chicago', Latitude__c = 41.88088500, Longitude__c = -87.62652200);
        insert new GoogleAPIkey__c(Name = 'DirectionsAPI', key__c = 'AIzaSyB4FLZcneRdwnpIj4aQrbC2mX1_kmG3Q5o');
    }
    
    public static void deleteTestData() {
        
        List<StockLocations__c> stockLocations = [SELECT id, Name FROM StockLocations__c WHERE Name Like '%TestNavigator%'];
        List<GoogleAPIkey__c> googleAPIkey = [SELECT id, Name FROM GoogleAPIkey__c WHERE Name Like '%DirectionsAPI%'];        
        List<Order> orders = [SELECT id, Name FROM Order WHERE Name Like '%TestNavigator%'];
        List<PricebookEntry> pricebookEntry = [SELECT id, Product2.Name FROM PricebookEntry WHERE Product2.Name Like '%TestNavigator%'];
        List<OrderItem> orderItems = [SELECT id, Order.Name FROM OrderItem WHERE Order.Name Like '%TestNavigator%'];
        List<Product2> product2 = [SELECT id, Name FROM Product2 WHERE Name Like '%TestNavigator%'];
        List<Contract> contract = [SELECT id, Account.Name FROM Contract WHERE Account.Name Like '%TestNavigator%'];
        List<Account> account = [SELECT id, Name FROM Account WHERE Name Like '%TestNavigator%'];
        
        delete orderItems;
        delete googleAPIkey;
        delete stockLocations;
        delete orders;
        delete pricebookEntry;        
        delete product2;
        delete contract;
        delete account; 
    }
}