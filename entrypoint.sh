sleep 5
echo "mc alias set BACKUP $1 $2 $3"
mc alias set BACKUP $1 $2 $3
mc rb --force BACKUP/$4;
mc mb BACKUP/$4;
mc mirror --watch --overwrite /export BACKUP/$4
/usr/local/bin/start_ipfs daemon --migrate=true --agent-version-suffix=docker