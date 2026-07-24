# A script that you can use to sync the compiled app to a server running cockpit.
# you need to be able to ssh into it with a copied key prior to running.

TEST_SERVER_A="192.168.1.100"
COCKPIT_MODULE="dell-disks"

echo "Running npm run build"
npm run build

echo "Stopping Cockpit on $TEST_SERVER_A..."
ssh root@$TEST_SERVER_A "systemctl stop cockpit.socket"

echo "Removing cockpit module ($COCKPIT_MODULE) from $TEST_SERVER_A..."
ssh root@$TEST_SERVER_A "rm -rf /usr/share/cockpit/$COCKPIT_MODULE"

echo "updating $COCKPIT_MODULE on $TEST_SERVER_A using rsync..."
rsync -a ./dist/ root@$TEST_SERVER_A:/usr/share/cockpit/$COCKPIT_MODULE/

echo "Restarting Cockpit on $TEST_SERVER_A..."
ssh root@$TEST_SERVER_A "systemctl start --now cockpit.socket"
