# JPetStore for WebLogic Server 12cR2

Overview

## Description

## Demo

## Features

- feature:1
- feature:2

## Requirement

## Usage

## Installation
### DataSource
#### WebLogic

|Property|Value|
|--------|-----|
|DS Name|PetStoreDS|
|JNDI Name|jdbc/PetstoreDB|
|Driver|Oracle's Driver(Thin) for Service connections; Version:Any|
|Driver Name|oracle.jdbc.OracleDriver|
|Database Name|PDB1.jptest01.oraclecloud.internal|
|Host Name|${DBCS-Host-Name}|
|Port|1521|
|Database User Name|petstore|
|Password|${SYS-Password}|
|JDBC URL|jdbc:oracle:thin:@//${DBCS-Host-Name}:1521/PDB1.jptest01.oraclecloud.internal|

#### JPetStpre

- applicationContext.xml

```
    <bean id="dataSource"
          class="org.springframework.jndi.JndiObjectFactoryBean">
        <property name="jndiName" value="jdbc/PetstoreDB"/>
    </bean>
    <bean id="transactionManager" class="org.springframework.transaction.jta.JtaTransactionManager"/>
```

## Licence

Released under the [MIT license](https://gist.githubusercontent.com/shinyay/56e54ee4c0e22db8211e05e70a63247e/raw/44f0f4de510b4f2b918fad3c91e0845104092bff/LICENSE)

## Author

[shinyay](https://github.com/shinyay)
