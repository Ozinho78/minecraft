# Checklist Contents

## Project Submission - Own Minecraft Server

Please fulfill all points on this list before submitting the project. If you have built in additional extras, mention them briefly so that the mentors can review them if needed.

### 1. Repository

#### Existing Files

- [x] A .gitignore file has been created that ignores all irrelevant content from the git repository
- [x] There is a docker-compose.yaml that meets the requirements of the next section
- [x] A file named README.md exists and has been created according to the criteria below
- [x] There are no other files in the repository without them being explicitly named and described in the README.md

#### Dockerfile

- [x] There is a Dockerfile that assembles a suitable image to start a minecraft-server
  - [x] see 3. Notes for the download link to the server application
- [x] All necessary packages should be installed and configured in the base image in the Dockerfile
- [x] Ensure that your server can always start, for environment variables you should possibly use default values
- [x] You should not use a pre-made Minecraft image

#### docker-compose.yaml

- [x] There is a service that is defined and configured: mc-server
- [x] There is an env configuration for the Minecraft server service where all non-critical variables are configured (no Auth!)
- [x] There are necessary port releases so that the container is reachable from the internet
- [x] There are volume configurations for the container data so that the content is persisted on a file system and the game progress is not lost

#### README.md

- [x] The README should contain a table of contents a.k.a. Table-of-Contents (ToC)
- [x] A section with a description of the repository must be present. This description should state what the essential contents are, what the purpose of the repository is
- [x] A "Quickstart" section should be included as part of the README. Here, prerequisites should be briefly mentioned and a quick start guide should be described
- [x] A detailed variant of the aforementioned section should be included as "Usage". Here, the configuration and configurability should be discussed in more detail, i.e., it should also be explained how relevant passages can be modified to achieve different results

### 2. Documentation

- [x] The documentation of the code as well as the project should take place in the repository in the form of a README file
- [x] The documentation language for all projects (and associated documents) is English

### 3. Notes

You can download a Minecraft server binary directly from the Minecraft website at (use the Java version here):
- https://www.minecraft.net/de-de/download

#### General Notes

- [x] In addition to your GitHub repository, you should record and provide a short Loom video (maximum 5min.) in which you briefly show your submission and present what you have done - you don't have to mention all the details, but you should briefly address and show all relevant steps

#### Security Notes

- [x] Do not store SSH keys in the workspace of your Git repository
- [x] Do not store passwords, tokens, or usernames in your code. Use environment variables instead
- [x] Do not store IP addresses or other sensitive information in a Git repository

#### Code Conventions

- [x] For build-args, environment variables and shell variables the following naming convention applies: UPPER_CASE_WITH_UNDERSCORE
- [x] When referencing a variable, always use the {}-notation to avoid errors in interpretation: ${SOME_VAR_VALUE}, instead of: $SOME_VAR_VALUE
- [x] Default values should be configured for build-args or environment variables, but only if it makes sense
- [x] Critical configuration such as tokens, passwords or similar should not be stored in the code repository, but should be passed into a container using a .env file, for example

#### Testing

Before submitting your project, you should have ensured and tested the following:

- [x] The Minecraft server is reachable at the IP address of your cloud VM on port 8888
- [x] For testing you basically have two ways: start the game and try to connect to your server (see next point), or try to establish a connection to the Minecraft server using a script. For this you can use the following Python module: https://github.com/py-mine/mcstatus
- [x] (optional) You can connect from your Java Minecraft client on your computer to the server on your cloud VM and play Minecraft
- [x] After restarting the server, the configured data is still present and is not deleted or overwritten. This includes the game progress and the configuration of the game server
- [x] The containers of the services are restarted as soon as an error occurs that leads to the termination of the container
