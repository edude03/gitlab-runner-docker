To run: 

clone this repo somewhere

install docker if you don't have it and you're running this locally

Get your auth token from gitlab ci, 

create or copy in a key for the server you'll be deploying to

then 
	
	# Build the container, removing intermediate images
	docker build -t "edude03/gitlab-runner-node" -rm=true .
	
	# run the container
	docker run -i -t -e GITLAB_URL=<YOUR_GITLAB_INSTANCE> -e CI_SERVER_URL=<YOUR_SERVER_HERE> -e REGISTRATION_TOKEN=<YOUR_TOKEN_HERE> -e DEPLOY_HOST=<WHERE_TO_DEPLOY_CODE> edude03/gitlab-runner-node
	

This should automatically boot the container, start the worker and await a new test. If there are none, it will hang around until some tests come in, then it runs whem and deploys as necessary.