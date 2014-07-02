To run: 

clone this repo somewhere

install docker if you don't have it and you're running this locally

Get your auth token from gitlab ci, 

create or copy in a key for the server you'll be deploying to

then 
	
	# Build the container, removing intermediate images
	docker build -t "edude03/gitlab-runner-node" -rm=true .
	
	# run the container
	docker run -i -t -e GITLAB_URL=git.melenion.com -e CI_SERVER_URL=<YOUR_SERVER_HERE> -e REGISTRATION_TOKEN=<YOUR_TOKEN_HERE> edude03/gitlab-runner-node
	

This should automatically boot the container, start the worker 