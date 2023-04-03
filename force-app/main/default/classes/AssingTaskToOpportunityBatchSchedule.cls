global class AssingTaskToOpportunityBatchSchedule implements Schedulable {

    global void execute(SchedulableContext ctx){

        AssingTaskToOpportunityBatch b = new AssingTaskToOpportunityBatch(); 
        Database.executeBatch(b);    
    }
 
}
