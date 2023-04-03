public without sharing class AssingTaskToOpportunityBatch implements Database.Batchable<sObject>, Database.Stateful{
   
   Id userAdminId = null;

   public Database.QueryLocator start(Database.BatchableContext ctx){


       userAdminId = [SELECT Id FROM User WHERE IsActive = true AND profile.name = 'System Administrator' LIMIT 1].Id;
       
       return Database.getQueryLocator('SELECT Owner.Id, Owner.isActive FROM Opportunity');
   }

   public void execute(DataBase.BatchableContext ctx, List<Opportunity> opps ){

        List<Task> tasks = new List<Task>();

        for(Opportunity opp : opps){

            String taskOwner = opp.Owner.isActive ? opp.OwnerId : userAdminId;  

            tasks.add(
                new Task(
                    OwnerId=taskOwner, 
                    WhatId = opp.Id 
                )
            );
        }

        insert tasks;

   }

   public void finish(DataBase.BatchableContext ctx){
   
   }


}