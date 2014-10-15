module Main where

import Database.Oracle.Enumerator
import Database.Enumerator
import Control.Monad.Trans (liftIO)
import Text.Printf
import Data.List (isInfixOf, lookup)
import System.IO








cmd="\"C:\\Program Files (x86)\\Java\\jdk1.6.0_29\\bin\\java\"  -XX:CompileCommand=exclude,com/noelios/restlet/util/HeaderReader,readValue -server -Xmx1000M -XX:+HeapDumpOnOutOfMemoryError -Dtangosol.coherence.distributed.localstorage=false -Dtangosol.coherence.management=all -Dtangosol.coherence.management.rem5Bote=true -Dcom.sun.management.jmxremote -Dlog4j.configuration=foundry-log4j.xml -Dtangosol.coherence.wka=LONMW92814 -Dtangosol.coherence.clusteraddress=239.255.12.41 -Dtangosol.coherence.clusterport=30036 -Dtangosol.coherence.cacheconfig=foundry-combined-cache-config.xml -Dtangosol.coherence.override=foundry-cluster-config.xml -Dfoundry-rest.sso.inactive=true -Xbootclasspath/a:C:/Projects/foundry/foundry-config/env/uat3-reload;C:/Projects/foundry/foundry-config/env/local;C:/Projects/foundry/foundry-config/env/all -Didea.launcher.port=7534 \"-Didea.launcher.bin.path=C:\\Program Files (x86)\\JetBrains\\IntelliJ IDEA 12.1.4\\bin\" -Dfile.encoding=UTF-8  -classpath \"h:\\gregjar.jar;C:\\Projects\\foundry\\foundry-sink-database\\target\\classes;C:\\Projects\\foundry\\reloader\\target\\classes;C:\\Projects\\foundry\\sso-client\\target\\classes;C:\\Projects\\foundry\\risk-viewer\\target\\classes;C:\\Projects\\foundry\\risk-results-rowsource\\target\\classes;C:\\Projects\\foundry\\risk-results\\target\\classes;C:\\Projects\\foundry\\risk-feeds\\target\\classes;C:\\Projects\\foundry\\risk-aggregator\\target\\classes;C:\\Projects\\foundry\\reloader\\target\\classes;C:\\Projects\\foundry\\queue-server\\target\\classes;C:\\Projects\\foundry\\namespace-residency-manager\\target\\classes;C:\\Projects\\foundry\\log-util\\target\\classes;C:\\Projects\\foundry\\foundry-sql-protocol\\target\\classes;C:\\Projects\\foundry\\foundry-sink-server-queue\\target\\classes;C:\\Projects\\foundry\\foundry-sink-server\\target\\classes;C:\\Projects\\foundry\\foundry-sink-queue\\target\\classes;C:\\Projects\\foundry\\foundry-sink-database\\target\\classes;C:\\Projects\\foundry\\foundry-sink-common-server\\target\\classes;C:\\Projects\\foundry\\foundry-sink-common\\target\\classes;C:\\Projects\\foundry\\foundry-sink-client-demo\\target\\classes;C:\\Projects\\foundry\\foundry-sink-api\\target\\classes;C:\\Projects\\foundry\\foundry-rest-common\\target\\classes;C:\\Projects\\foundry\\foundry-rest\\target\\classes;C:\\Projects\\foundry\\foundry-rates-market-service\\target\\classes;C:\\Projects\\foundry\\foundry-pnl-attribution\\target\\classes;C:\\Projects\\foundry\\foundry-metric\\target\\classes;C:\\Projects\\foundry\\foundry-marketdata-client\\target\\classes;C:\\Projects\\foundry\\foundry-manager\\target\\classes;C:\\Projects\\foundry\\foundry-integration-tests\\target\\classes;C:\\Projects\\foundry\\foundry-downstream-feed\\target\\classes;C:\\Projects\\foundry\\foundry-domain\\target\\classes;C:\\Projects\\foundry\\foundry-delivery\\target\\classes;C:\\Projects\\foundry\\foundry-db-rowsource\\target\\classes;C:\\Projects\\foundry\\foundry-db-build\\target\\classes;C:\\Projects\\foundry\\foundry-database\\target\\classes;C:\\Projects\\foundry\\foundry-core-http\\target\\classes;C:\\Projects\\foundry\\foundry-core\\target\\classes;C:\\Projects\\foundry\\foundry-config\\target\\classes;C:\\Projects\\foundry\\fire-domain\\target\\classes;C:\\Projects\\foundry\\fire-common\\target\\classes;C:\\Projects\\foundry\\delivery-service-agent\\target\\classes;C:\\Projects\\foundry\\coherence-cluster\\target\\classes;C:\\Projects\\foundry\\cluster-init\\target\\classes;C:\\Program Files (x86)\\JetBrains\\IntelliJ IDEA 12.1.4\\lib\\idea_rt.jar\"  com.intellij.rt.execution.application.AppMain com.rbsfm.foundry.reloader.DatabaseReloadStarter -queueSink -missingSessions %s,%s,%s\n"


reloads=[("ROE", "EUR_COMPLEX_HW", "2014-02-25"),("ROE", "EUR_COMPLEX_LMM", "2014-02-25"), ("ROE", "USD_COMPLEX_HW", "2014-02-25"),("ROE", "USD_COMPLEX_LMM", "2014-02-25"),("ROE", "FIRE_OPTIONS_BERM_HW", "2014-02-25"),("ROE", "FIRE_OPTIONS_BERM_LMM_ATM", "2014-02-25"),("ROE", "FIRE_OPTIONS_BERM_LMM_DEALSTRIKE", "2014-02-25"),("ROE", "again for same dates in UAt1 and UAT2 pls", "2014-02-25"),("ROE", "ROE and Other", "2014-02-25"),("ROE", "DIAGNOSTICS_EOD", "2014-02-25"),("ROE", "EUR_COMPLEX_HW", "2014-02-25"),("ROE", "EUR_COMPLEX_LMM", "2014-02-25"),("ROE", "USD_COMPLEX_HW", "2014-02-25"),("ROE", "USD_COMPLEX_LMM", "2014-02-25"),("ROE", "FIRE_OPTIONS_BERM_HW", "2014-02-25"),("ROE", "FIRE_OPTIONS_BERM_LMM_ATM", "2014-02-25"),("ROE", "FIRE_OPTIONS_BERM_LMM_DEALSTRIKE", "2014-02-25"),("ROE", "DIAGNOSTICS_EOD", "2014-02-25"),("ROE", "SOD", "2014-02-25")]






--CompilerOracle: exclude com/noelios/restlet/util/HeaderReader.readValue


connstrings :: [(String,(String, String , String, String))]
connstrings =
    [
     ("UAT3",    ("FOU_APP_OWNER_UAT3",     "UOLNFOU3", "lonuc20435.fm.rbsgrp.net", "1880")), 
     ("UAT3_ARC",("FOU_APP_OWNER_UAT3_ARC", "UOLNFOU1", "lonuc20422.fm.rbsgrp.net", "1870")),
     ("UAT1",    ("FOU_APP_OWNER_UAT1",     "UOLNFOU1", "lonuc20422.fm.rbsgrp.net", "1870")), 
     ("UAT1_ARC",("FOU_APP_OWNER_UAT1_ARC", "UOLNFOU2", "lonuc20430.fm.rbsgrp.net", "1875")), 
     ("UAT2",    ("FOU_APP_OWNER_UAT2",     "UOLNFOU2", "lonuc20430.fm.rbsgrp.net", "1875")), 
     ("UAT2_ARC",("FOU_APP_OWNER_UAT2_ARC", "UOLNFOU3", "lonuc20435.fm.rbsgrp.net", "1880")), 
     ("UAT3",    ("FOU_APP_OWNER_UAT3",     "UOLNFOU3", "lonuc20435.fm.rbsgrp.net", "1880")), 
     ("UAT3_ARC",("FOU_APP_OWNER_UAT3_ARC", "UOLNFOU1", "lonuc20422.fm.rbsgrp.net", "1870")), 
     ("UAT4",    ("FOU_APP_OWNER_UAT4",     "UOLNFOU2", "lonuc20430.fm.rbsgrp.net", "1875")), 
     ("UAT4_ARC",("FOU_APP_OWNER_UAT4_ARC", "UOLNFOU3", "lonuc20435.fm.rbsgrp.net", "1880"))
    ] 

query1Iteratee :: (Monad m) => String -> String  -> String -> IterAct m [(String, String , String)]
query1Iteratee org ns  dt accum = result' ((org, ns  ,dt ):accum)
                          

-- name date org
mkcmd :: (String , String , String ) -> String
mkcmd (org , name, date)  = printf cmd  name  date org


qString::String
qString = "select d.attributevalue, name ,  TO_CHAR(namespacedate, 'YYYY-MM-DD') AS b  \
 \  from\
 \ sink2_message m, sink2_session s, namespace n, namespace_detail d\
 \ where s.sessionid = m.sessionid \
 \ and s.namespaceid = n.namespaceid\
 \ and n.namespaceid = d.namespaceid\
 \ and n.namespacedescription not like '%EOD_PNL%' \
 \ and n.name not like '%EOD_PNL%' \
 \ and n.name like 'CAF_%' \
 \ and n.namespacedescription not like '%orest%' \
 \ group by d.attributevalue, name , namespacedate  ORDER BY SUM(dbms_lob.getlength(m.data)/POWER(1024,2)) DESC "


--doconn :: String -> String -> String -> String 
doconn (Just (schm, dab, hst, prt)) = connect schm "FoundryAppOwner1" (printf "%s:%s/%s" hst prt dab)


main :: IO ()
main = do

  withSession (doconn (lookup "UAT1" connstrings))
   ( do
      r <- doQuery (sql qString ) query1Iteratee []
      liftIO ( writeFile "/home/nwosug/cmds.sh"   (unlines (map mkcmd reloads)) >> print r    )
   )




main' = 
      writeFile "/home/nwosug/reloads.sh"   (unlines (map mkcmd reloads))   
       


--  \ and n.namespacedate = '25-FEB-2014'\  \ and n.name = 'EOD'\
--  \ and d.attributevalue = 'ROE'\
--  \ and d.attributename = 'Organisational Unit'\
