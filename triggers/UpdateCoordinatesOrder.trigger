trigger UpdateCoordinatesOrder on Order (after insert, after update) {
    if (Trigger.IsInsert) {
        System.enqueueJob(new UpdateGeoCoordinates(Trigger.newMap.keySet()));
        List<OpderTopic__c> ots = new List<OpderTopic__c>();
        for (Order order : Trigger.new) {
            OpderTopic__c ot = new OpderTopic__c(
            	Name = 'topicFor' + order.Id,
                Order__c = order.Id
            );
            ots.add(ot);
        }
        insert ots;
    }
    if (Trigger.IsUpdate) {
        Set<Id> orderForUpdate = new Set<Id>();
        for (Order ord : Trigger.new) {
            Order oldOrd = Trigger.oldMap.get(ord.Id);            
            if (ord.ShippingCity != oldOrd.ShippingCity || ord.ShippingStreet != oldOrd.ShippingStreet) {
                orderForUpdate.add(ord.Id);
            }
        }
        if (!orderForUpdate.isEmpty()) {
            System.enqueueJob(new UpdateGeoCoordinates(orderForUpdate));
        }
    }
}