sleep 5
echo "mc alias set BACKUP $1 $2 $3"
mc alias set BACKUP $1 $2 $3
mc mirror --watch --overwrite /export BACKUP/my-bucket
/usr/local/bin/start_ipfs daemon --migrate=true --agent-version-suffix=docker