@IsTest
public class UpdateGeoCoordinatesTest {
	@testSetup 
    static void setup() {        
        Account a = new Account(Name = 'Test');
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
        List<Order> orders = new List<Order>();
        for(Integer i = 0; i < 3; i++) {
            orders.add(new Order(
                AccountId = a.Id,
                ContractId = c.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                ShippingCity = 'Tets city'
            ));
        }
        insert orders; 
        
        insert new GoogleAPIkey__c(Name = 'DirectionsAPI', key__c = 'e123456789');
    }
    @IsTest
    public static void testUpdateGeoCoordinates() {        
        Test.setMock(HttpCalloutMock.class, new MockGoogleApiGenerator());
        Order[] orders = [SELECT Id, ShippingCity, ShippingStreet FROM Order];
        for (Order o : orders) {
            o.ShippingStreet = 'Test street';
        }
        update orders;
    }
}