pipeline {
    agent {
        label 'build' // Use build node
        }
    triggers {
        pollSCM('') // Enabling being build on Push
    }
    environment {
        REGISTRY = "repo.t3st.org:48083/appster-${BRANCH_NAME}"
        REGISTRY_URL = "https://repo.t3st.org:48083"
        REGISTRY_CREDENTIALS = 'jenkins_nexus'
        DOCKER_IMAGE = ''
        DOCKER_IMAGE_TAG = "$REGISTRY:$BUILD_NUMBER"
    }
    stages {
            stage('Build') {
                steps {
                    sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    script {
                        DOCKER_IMAGE = docker.build REGISTRY + ":$BUILD_NUMBER"
                    }
                    sh 'docker images'
                }
            }
            stage('Nginx syntax configuration check') {
                 steps {
                    sh 'whoami'
                    sh 'echo $WORKSPACE'
                    sh 'ls -la'
                    sh 'docker run --rm -t -a stdout --name my-nginx --sysctl net.ipv4.ip_nonlocal_bind=1 -v $WORKSPACE/etc/nginx:/etc/nginx/ $DOCKER_IMAGE_TAG nginx -t'
                 }
            }
            stage('Deploy Image') {
                steps{
                    script {
                        // Use private repo
                        docker.withRegistry( REGISTRY_URL, REGISTRY_CREDENTIALS ) {
                            DOCKER_IMAGE.push()
                        }
                    }
                }
            }
        // stage('Publish to prod') {
        //     steps {
        //         sh "ssh -t user@xxx.xxx.xxx.xxx.xxx '/home/user/./update-nginx-config.sh'"
        //     }
        // }
        // stage('Deploy NGINX to POC Server') {
        //     steps {
        //         sshagent(['NGINX_VM1_Pass']) {
        //             sh "scp -r nginx/ user@xxx.xxx.xxx.xxx:~"
        //             sh "ssh -tt -o StrictHostKeyChecking=no -l root xxx.xxx.xxx.xxx whoami"
        //             sh "ssh -tt -o StrictHostKeyChecking=no -l root xxx.xxx.xxx.xxx 'sudo cp -R ~/nginx/ /etc/'"
        //             sh "ssh -tt -o StrictHostKeyChecking=no -l root xxx.xxx.xxx.xxx 'sudo /usr/sbin/nginx -t && sudo nginx -s reload'"
        //         }
        //     }
        // }
    }
    post {
        cleanup {
            echo 'Cleanup'
            // Remove the image built in this build
            sh 'docker rmi $DOCKER_IMAGE_TAG'
            //clean up any resources — images, containers, volumes, and networks — that are dangling (not associated with a container) and any stopped containers and all unused images (not just dangling images)
            sh 'docker system prune -a -f'
            // Delete all others:
            //clean up any resources — images, containers, volumes, and networks — that are dangling (not associated with a container) and any stopped containers and all unused images (not just dangling images)
            //sh 'docker system prune -a -f'
            // docker stop $(docker ps -q)
            // docker rm $(docker ps -a -q)
            // docker rmi $(docker images -q -f dangling=true)
            sh 'docker images'
            deleteDir()
        }
    }
}