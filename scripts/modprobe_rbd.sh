#set -x
#!/bin/bash

echo
echo "------------------------------------------"
echo "MODPROBE RBD"
sudo modprobe rbd


echo
echo "------------------------------------------"
echo "LSMOD RBD"
sudo lsmod | grep -i rbd


echo
echo "------------------------------------------"
echo "ADD RBD ON SYSTEM REBOOT"
echo "rbd" | sudo tee /etc/modules-load.d/rbd.conf


echo
echo "------------------------------------------"
echo "LIST RBD.CONF FILE"
ls -la /etc/modules-load.d/rbd.conf


echo
echo "------------------------------------------"
echo "SLEEP 15"
sleep 15


exit 0