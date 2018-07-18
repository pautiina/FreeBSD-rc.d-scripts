#!/usr/local/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:$HOME/bin; 
export PATH
 
BACKUP_DIR=/var/Virtualbox_Backup
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
 
if [ -z "$1" ]
then
    echo "Supply name of virtual machine or ALL for all running VMs"
    exit
fi
 
if [ "$1" = "ALL" ]
then
    VMS=`VBoxManage list runningvms|awk '{FS=" "}{print $1}'|sed s/\"//g`
else
    VMS=$1
fi
 
for VM in $VMS
do
    echo $VM
    mkdir $BACKUP_DIR/$VM/
    CFG=`VBoxManage showvminfo $VM --machinereadable|grep CfgFile|awk '{FS="="}{print $2}'|sed s/\"//g`
    echo "Copy $CFG ==> $BACKUP_DIR/$VM/"
    cp "$CFG" "$BACKUP_DIR/$VM/"
    VDIS=`VBoxManage showvminfo $VM --machinereadable|grep .vdi|awk '{FS="="}{print $2}'|sed s/\"//g`
    echo "Make snapshot of $VM"
    VBoxManage snapshot $VM take autobackup
 
    for VDI in "$VDIS"
    do
        #копирование диска
        echo "Copy $VDI > $BACKUP_DIR/$VM/"
        cp "$VDI" "$BACKUP_DIR/$VM/"
    done
    
    echo "Delete snapshot of $VM"
    VBoxManage snapshot $VM delete autobackup
 
    echo "Create archive of $VM"
    cd $BACKUP_DIR
    tar cfvJ $VM-$TIMESTAMP.xz "$VM/"
    rm -rf "$BACKUP_DIR/$VM/"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "DONE"

done

find $BACKUP_DIR -type f -mtime +90 -exec rm -rf {} \;
