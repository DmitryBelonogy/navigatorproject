@IsTest
public class TestDataForNavigatorTest {
	@IsTest
    public static void testCreate() {
        insert new GoogleAPIkey__c(Name = 'DirectionsAPI', key__c = '123');
        Test.setMock(HttpCalloutMock.class, new MockGoogleApiGenerator());
        List<OrderItem> beforeOrderItems = [SELECT id, Order.Name FROM OrderItem WHERE Order.Name Like '%TestNavigator%'];
        TestDataForNavigator.createTestData();
        List<OrderItem> afterOrderItems = [SELECT id, Order.Name FROM OrderItem WHERE Order.Name Like '%TestNavigator%'];
        System.assertEquals(0, beforeOrderItems.size());
        System.assertEquals(2, afterOrderItems.size());
    }
    @IsTest
    public static void testDelete() {
        TestDataForNavigator.createTestData();
        List<OrderItem> createOrderItems = [SELECT id, Order.Name FROM OrderItem WHERE Order.Name Like '%TestNavigator%'];
        TestDataForNavigator.deleteTestData();
        List<OrderItem> deleteOrderItems = [SELECT id, Order.Name FROM OrderItem WHERE Order.Name Like '%TestNavigator%'];
        System.assertEquals(2, createOrderItems.size());
        System.assertEquals(0, deleteOrderItems.size());
    }
}