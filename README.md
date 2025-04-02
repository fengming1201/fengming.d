# fengming.d

this dir save mybashrc and help file

first time init linux envirence to mybash

## **step 1:download fengming.d**

```shell
$cd /opt
$sudo git clone https://github.com/fengming1201/fengming.d.git
```

make sure download completed

```shell
/opt/fengming.d/
├── bash_function_lib
├── cmd_help
├── documents
├── install.sh
├── mybashrc
├── README.md
├── sorftware_toolket
└── what_is_by_keyword
```

## **step 2:install mybashrc**

```shell
$sudo bash /opt/fengming.d/install.sh
```

check exec result:

```shell
if [ -f /opt/fengming.d/mybashrc ];then
    . /opt/fengming.d/mybashrc
fi
```

## **step 3:relogin**

```shell
logout
```

## **step 4:install base sorftware with level 1**

## **step 5:install sorftarw packet**

```shell
$bash sorftware_pagke_install.sh

