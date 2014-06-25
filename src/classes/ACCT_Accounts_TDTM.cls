/*
    Copyright (c) 2014 Salesforce.com Foundation
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Salesforce.com Foundation nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.
 
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/
/**
* @author Salesforce.com Foundation
* @date 2014
* @description handles triggers on Account to deal with initializing system fields for Household and One2One Accounts 
*/
public with sharing class ACCT_Accounts_TDTM extends TDTM_Runnable {
        
    public override DmlWrapper run(List<SObject> listNew, List<SObject> listOld, 
        TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        
        if (triggerAction != TDTM_Runnable.Action.BeforeInsert)
            return null; 
        
        ID rtIdAccountHH = ACCT_IndividualAccounts_TDTM.rtIdForAccountModel(true);
        ID rtIdAccountOne2One = ACCT_IndividualAccounts_TDTM.rtIdForAccountModel(false);
        
        for (SObject so : listNew) {
            Account acc = (Account)so;
            if (acc.RecordTypeId == rtIdAccountHH && acc.RecordTypeId != null && acc.npe01__SYSTEM_AccountType__c == null) {
            	acc.npe01__SYSTEM_AccountType__c = CAO_Constants.HH_ACCOUNT_TYPE;
            	acc.Type = CAO_Constants.HH_TYPE;
            	acc.npe01__SYSTEMISINDIVIDUAL__c = true; 
            } else if (acc.RecordTypeId == rtIdAccountOne2One && acc.RecordTypeId != null && acc.npe01__SYSTEM_AccountType__c == null) {
                acc.npe01__SYSTEM_AccountType__c = CAO_Constants.ONE_TO_ONE_ORGANIZATION_TYPE;
                acc.npe01__SYSTEMISINDIVIDUAL__c = true; 
            }    
        }
        
        return null;
    }
}