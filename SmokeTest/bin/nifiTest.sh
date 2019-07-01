#!/bin/bash
source ./conf/SmokeConfig.config
# SmokeTest Template
cat <<EOF >$NIFI_TEMPLATE_TEMP_LOCATION

<template encoding-version="1.2">
    <description/>
    <id>ac664185-4941-4606-bb44-d03ac54e8602</id>
    <name>SmokeTest</name>
    <snippet>
        <connections>
            <id>ee334b2a-ae4e-3480-0000-000000000000</id>
            <parentGroupId>53677ab9-1c05-3447-0000-000000000000</parentGroupId>
            <backPressureDataSizeThreshold>1 GB</backPressureDataSizeThreshold>
            <backPressureObjectThreshold>10000</backPressureObjectThreshold>
            <destination>
                <groupId>53677ab9-1c05-3447-0000-000000000000</groupId>
                <id>3eea25e4-b790-32e0-0000-000000000000</id>
                <type>PROCESSOR</type>
            </destination>
            <flowFileExpiration>0 sec</flowFileExpiration>
            <labelIndex>1</labelIndex>
            <loadBalanceCompression>DO_NOT_COMPRESS</loadBalanceCompression>
            <loadBalancePartitionAttribute/>
            <loadBalanceStatus>LOAD_BALANCE_NOT_CONFIGURED</loadBalanceStatus>
            <loadBalanceStrategy>DO_NOT_LOAD_BALANCE</loadBalanceStrategy>
            <name/>
            <selectedRelationships>success</selectedRelationships>
            <source>
                <groupId>53677ab9-1c05-3447-0000-000000000000</groupId>
                <id>b0b3f1e4-3843-362a-0000-000000000000</id>
                <type>PROCESSOR</type>
            </source>
            <zIndex>0</zIndex>
        </connections>
        <processors>
            <id>3eea25e4-b790-32e0-0000-000000000000</id>
            <parentGroupId>53677ab9-1c05-3447-0000-000000000000</parentGroupId>
            <position>
                <x>235.0</x>
                <y>241.0</y>
            </position>
            <bundle>
                <artifact>nifi-hadoop-nar</artifact>
                <group>org.apache.nifi</group>
                <version>1.9.0.1.0.0.0-90</version>
            </bundle>
            <config>
                <bulletinLevel>WARN</bulletinLevel>
                <comments/>
                <concurrentlySchedulableTaskCount>1</concurrentlySchedulableTaskCount>
                <descriptors>
                    <entry>
                        <key>Hadoop Configuration Resources</key>
                        <value>
                            <name>Hadoop Configuration Resources</name>
                        </value>
                    </entry>
                    <entry>
                        <key>kerberos-credentials-service</key>
                        <value>
                            <identifiesControllerService>org.apache.nifi.kerberos.KerberosCredentialsService</identifiesControllerService>
                            <name>kerberos-credentials-service</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Kerberos Principal</key>
                        <value>
                            <name>Kerberos Principal</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Kerberos Keytab</key>
                        <value>
                            <name>Kerberos Keytab</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Kerberos Relogin Period</key>
                        <value>
                            <name>Kerberos Relogin Period</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Additional Classpath Resources</key>
                        <value>
                            <name>Additional Classpath Resources</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Directory</key>
                        <value>
                            <name>Directory</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Conflict Resolution Strategy</key>
                        <value>
                            <name>Conflict Resolution Strategy</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Block Size</key>
                        <value>
                            <name>Block Size</name>
                        </value>
                    </entry>
                    <entry>
                        <key>IO Buffer Size</key>
                        <value>
                            <name>IO Buffer Size</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Replication</key>
                        <value>
                            <name>Replication</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Permissions umask</key>
                        <value>
                            <name>Permissions umask</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Remote Owner</key>
                        <value>
                            <name>Remote Owner</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Remote Group</key>
                        <value>
                            <name>Remote Group</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Compression codec</key>
                        <value>
                            <name>Compression codec</name>
                        </value>
                    </entry>
                </descriptors>
                <executionNode>ALL</executionNode>
                <lossTolerant>false</lossTolerant>
                <penaltyDuration>30 sec</penaltyDuration>
                <properties>
                    <entry>
                        <key>Hadoop Configuration Resources</key>
                        <value>$HADOOP_CORE_SITE_PATH,$HADOOP_HDFS_SITE_PATH</value>
                    </entry>
                    <entry>
                        <key>kerberos-credentials-service</key>
                    </entry>
                    <entry>
                        <key>Kerberos Principal</key>
                    </entry>
                    <entry>
                        <key>Kerberos Keytab</key>
                    </entry>
                    <entry>
                        <key>Kerberos Relogin Period</key>
                        <value>4 hours</value>
                    </entry>
                    <entry>
                        <key>Additional Classpath Resources</key>
                    </entry>
                    <entry>
                        <key>Directory</key>
                        <value>$TEMP_HDFS_DIRECTORY</value>
                    </entry>
                    <entry>
                        <key>Conflict Resolution Strategy</key>
                        <value>fail</value>
                    </entry>
                    <entry>
                        <key>Block Size</key>
                    </entry>
                    <entry>
                        <key>IO Buffer Size</key>
                    </entry>
                    <entry>
                        <key>Replication</key>
                    </entry>
                    <entry>
                        <key>Permissions umask</key>
                    </entry>
                    <entry>
                        <key>Remote Owner</key>
                    </entry>
                    <entry>
                        <key>Remote Group</key>
                    </entry>
                    <entry>
                        <key>Compression codec</key>
                        <value>NONE</value>
                    </entry>
                </properties>
                <runDurationMillis>0</runDurationMillis>
                <schedulingPeriod>0 sec</schedulingPeriod>
                <schedulingStrategy>TIMER_DRIVEN</schedulingStrategy>
                <yieldDuration>1 sec</yieldDuration>
            </config>
            <deprecated>false</deprecated>
            <executionNodeRestricted>false</executionNodeRestricted>
            <name>PutHDFS</name>
            <relationships>
                <autoTerminate>true</autoTerminate>
                <name>failure</name>
            </relationships>
            <relationships>
                <autoTerminate>true</autoTerminate>
                <name>success</name>
            </relationships>
            <restricted>true</restricted>
            <state>RUNNING</state>
            <style/>
            <type>org.apache.nifi.processors.hadoop.PutHDFS</type>
        </processors>
        <processors>
            <id>b0b3f1e4-3843-362a-0000-000000000000</id>
            <parentGroupId>53677ab9-1c05-3447-0000-000000000000</parentGroupId>
            <position>
                <x>0.0</x>
                <y>0.0</y>
            </position>
            <bundle>
                <artifact>nifi-standard-nar</artifact>
                <group>org.apache.nifi</group>
                <version>1.9.0.1.0.0.0-90</version>
            </bundle>
            <config>
                <bulletinLevel>WARN</bulletinLevel>
                <comments/>
                <concurrentlySchedulableTaskCount>1</concurrentlySchedulableTaskCount>
                <descriptors>
                    <entry>
                        <key>File Size</key>
                        <value>
                            <name>File Size</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Batch Size</key>
                        <value>
                            <name>Batch Size</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Data Format</key>
                        <value>
                            <name>Data Format</name>
                        </value>
                    </entry>
                    <entry>
                        <key>Unique FlowFiles</key>
                        <value>
                            <name>Unique FlowFiles</name>
                        </value>
                    </entry>
                    <entry>
                        <key>generate-ff-custom-text</key>
                        <value>
                            <name>generate-ff-custom-text</name>
                        </value>
                    </entry>
                    <entry>
                        <key>character-set</key>
                        <value>
                            <name>character-set</name>
                        </value>
                    </entry>
                </descriptors>
                <executionNode>ALL</executionNode>
                <lossTolerant>false</lossTolerant>
                <penaltyDuration>30 sec</penaltyDuration>
                <properties>
                    <entry>
                        <key>File Size</key>
                        <value>0B</value>
                    </entry>
                    <entry>
                        <key>Batch Size</key>
                        <value>100</value>
                    </entry>
                    <entry>
                        <key>Data Format</key>
                        <value>Text</value>
                    </entry>
                    <entry>
                        <key>Unique FlowFiles</key>
                        <value>false</value>
                    </entry>
                    <entry>
                        <key>generate-ff-custom-text</key>
                    </entry>
                    <entry>
                        <key>character-set</key>
                        <value>UTF-8</value>
                    </entry>
                </properties>
                <runDurationMillis>0</runDurationMillis>
                <schedulingPeriod>05 sec</schedulingPeriod>
                <schedulingStrategy>TIMER_DRIVEN</schedulingStrategy>
                <yieldDuration>1 sec</yieldDuration>
            </config>
            <deprecated>false</deprecated>
            <executionNodeRestricted>false</executionNodeRestricted>
            <name>GenerateFlowFile</name>
            <relationships>
                <autoTerminate>false</autoTerminate>
                <name>success</name>
            </relationships>
            <restricted>false</restricted>
            <state>RUNNING</state>
            <style/>
            <type>org.apache.nifi.processors.standard.GenerateFlowFile</type>
        </processors>
    </snippet>
    <timestamp>06/18/2019 11:29:01 PDT</timestamp>
</template>

EOF

# Retrieve Root Process ID
mainProcessID=$(curl -s http://{$NIFI_HOST}/nifi-api/flow/process-groups/root/status?recursive=true |
    python -c "import sys, json; print (json.load(sys.stdin)['processGroupStatus']['id'])")

curl -X POST -H 'Content-Type: application/json' -d '{"revision":{"version":0},"component":{"name":"SmokeTestGroup","position":{"x":0,"y":0}}}' http://{$NIFI_HOST}/nifi-api/process-groups/{$mainProcessID}/process-groups

# Retrieve Process ID for newly created Process Group "SmokeTestGroup"
processID=$(python <<EOF
import sys, json, urllib;
obj = json.loads(urllib.urlopen('http://$NIFI_HOST/nifi-api/process-groups/$mainProcessID/process-groups').read().decode("utf-8"))
for x in obj['processGroups']:
    if (x['component']['name'] == "SmokeTestGroup"):
        print (x['component']['id']);
        break;

EOF
)

# Template Upload
curl -k -F template=@$NIFI_TEMPLATE_TEMP_LOCATION -X POST http://{$NIFI_HOST}/nifi-api/process-groups/{$processID}/templates/upload

# Retrieve template ID
templateID=$(
    python <<EOF
import sys, json, urllib; 
obj = json.loads(urllib.urlopen('http://$NIFI_HOST/nifi-api/flow/templates').read().decode("utf-8"))
for x in obj['templates']:
    if (x['template']['name'] == "SmokeTest"):
        print (x['template']['id']);
        break;
EOF
)

# Template Instantiate
curl -H 'Content-Type:application/json' -d '{"originX":"0","originY":"0","templateId":"'"$templateID"'"}' -X POST http://{$NIFI_HOST}/nifi-api/process-groups/{$processID}/template-instance

# Start Process
curl -i -X PUT -H 'Content-Type: application/json' -d '{"state":"RUNNING","id":"'"$processID"'"}' http://{$NIFI_HOST}/nifi-api/flow/process-groups/{$processID}

sleep 10s

# Stop Process
curl -i -X PUT -H 'Content-Type: application/json' -d '{"state":"STOPPED","id":"'"$processID"'"}' http://{$NIFI_HOST}/nifi-api/flow/process-groups/{$processID}

sleep 5s

hadoop fs -ls {$TEMP_HDFS_DIRECTORY}

# Clear and drop queue
compID=$(curl -X GET http://{$NIFI_HOST}/nifi-api/process-groups/{$processID}/connections |
    python -c "import sys, json; print (json.load(sys.stdin)['connections'][0]['component']['id'])")

compVersion=$(curl -X GET http://{$NIFI_HOST}/nifi-api/process-groups/{$processID}/connections |
    python -c "import sys, json; print (json.load(sys.stdin)['connections'][0]['revision']['version'])")

curl -i -X POST http://{$NIFI_HOST}/nifi-api/flowfile-queues/{$compID}/drop-requests

sleep 5s

curl -i -X DELETE http://{$NIFI_HOST}/nifi-api/connections/{$compID}?version={$compVersion}

# Delete template
curl -X DELETE http://{$NIFI_HOST}/nifi-api/templates/{$templateID}

processVersion=$(python <<EOF
import sys, json, urllib; 
obj = json.loads(urllib.urlopen('http://$NIFI_HOST/nifi-api/process-groups/$mainProcessID/process-groups').read().decode("utf-8"))
for x in obj['processGroups']:
    if (x['component']['name'] == "SmokeTestGroup"):
        print (x['revision']['version']);
        break;
EOF
)

# Delete the process group
curl -X DELETE http://{$NIFI_HOST}/nifi-api/process-groups/{$processID}?version={$processVersion}

rc=$?; if [[ $rc != 0 ]]; then echo "Something went wrong! Exiting!";  echo " - Nifi	- Failed [Error]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "***************************************"
echo "*  Nifi test completed Successfully!  *"
echo "***************************************"

echo " - Nifi		- Passed" >> ./log/SummaryReport.txt