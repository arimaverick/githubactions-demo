export GITHUB_PAT=`echo ${{ secrets.RUNNER_PAT }}`
json_response=$(curl -sX GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_PAT" https://api.github.com/repos/arimaverick/terraform-repo/actions/runners)
echo $json_response
total_runners_cnt=`echo $json_response | jq .total_count`
echo "Total Runners: $total_runners_cnt"
total_runners_cnt=`expr $total_runners_cnt - 1`
echo $total_runners_cnt
for i in `seq 0 $total_runners_cnt`
do
  echo "Checking runner $i"
  status=`echo $json_response | jq .runners[$i].status`
  if [ $status == "offline"]
  then
    runner_id=`echo $json_response | jq .runners[$i].id
    curl -sX DELETE -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_PAT" https://api.github.com/repos/arimaverick/terraform-repo/actions/runners/$runner_id
  else
    echo "Great! There is no offline runners today" 
  fi 
done