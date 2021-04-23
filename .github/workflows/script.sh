export GITHUB_PAT=`echo ${{ secrets.RUNNER_PAT }}`
json_response=$(curl -sX GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_PAT" https://api.github.com/repos/arimaverick/terraform-repo/actions/runners)
total_cnt=`echo $json_response | jq .total_count`
echo "Total Runners: $total_cnt"
total_runners_cnt=`expr $total_cnt - 1`
echo $total_runners_cnt
a=0
for i in $(seq 0 1 $total_runners_cnt)
do
  echo "Checking runner $i"
  status=`echo $json_response | jq -r .runners[$i].status`
  #echo $status
  if [ $status == 'offline' ]
  then
    runner_id=`echo $json_response | jq .runners[$i].id`
    curl -sX DELETE -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_PAT" https://api.github.com/repos/arimaverick/terraform-repo/actions/runners/$runner_id
    a=`expr $a + 1`
  fi 
done
if [ $a -eq 0 ]
then 
    echo "Great! There are NO OFFLINE runner today" 
else
    echo "Total OFFLINE runners deleted: $a"
fi 