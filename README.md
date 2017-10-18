# sinaptika/deluge
[Github](https://github.com/git-sinaptika/deluged)  
Docker image for deluged  
From alpine:3.6  
From [sinaptika/libtorrent](https://hub.docker.com/r/sinaptika/libtorrent/)  

[Deluge: 1.3.15](http://deluge-torrent.org/)    
[libtorrent: 1.0.11-1.1.4](http://www.libtorrent.org/)    
This image contains only Deluge Daemon.  
Deluge daemon port: 58846  
Deluged incoming port tcp&udp: 50100  

Docker tags: latest(1.3.15), dev (2.0b1)
#### Simple instructions:  
1. Pull the image from docker-hub:  
`docker pull sinaptika/deluge`  

2. Create a directory called **deluge** inside your home directory on the host:  
`mkdir ~/deluge`

3. Create or run your container:  
`docker run -d \`  
`--name c_deluge \`  
`-p 50100:50100 \`  
`-p 58846:58846 \`  
`-p 8112:8112 \`  
`-v ~/deluge:/opt/deluge \`  
`sinaptika/deluge`

4. Create a username and password for logging in to deluge daemon by running:   
`docker exec -it c_deluge deluged-pass.sh`   
You can also add a username and password manually.   
Just edit the **auth** file inside your **~/deluge/config** directory.

5. Sign into the web interface at http://your.docker.host:8112 with  
the default password **deluge** and change the password as instructed.

In the example above, we pulled the image from docker-hub,  
created and started a container named c_deluge and mounted the directory  
~/deluge from the host to /opt/deluge inside the container.  
We have also exposed three ports in the container and mapped them on the host.  
Then we generated user and pass and appended it to deluged's **auth** file.

Other optional variables, that you can pass at `docker create -e` or `docker run -e`  
are:  
- `-e TZ=<timezone>` (examples: Europe/London or America/New_York)
- `-e D_UID=<user id of user running deluge>` (default user id 1000)
- `-e D_GID=<group id of user running deluge>` (default group id 1000)
- `-e D_D_UMASK=<umask used deluged>` (umask used by deluged, default 022)
- `-e D_D_LOG_LEVEL=<log level of deluged>` (default is warn)
- `-e D_W_LOG_LEVEL=<log level of deluge-web>` (default is warn)

#### Another example:
`docker create`  
We will be using *docker create* instead of run, but you can use either.

`--name c_deluge`  
The name of our container. Use something you will remember and append c_ in front,  
so you don't mix up images and container and volumes and networks...  

`-p 50200:50100`  
Here we are mapping port 50200 on the host to port 50100 on our deluge container.  
We can map a port from the container to any port on the host.  
If you have a firewall between your host running docker and the internet,  
you would then open port 50200/tcp on the fw for incoming connections.  

`-p 50300:50100/udp`  
Here we are having some more fun and mapping udp port 50100 from deluged  
to 50300 on the host.  
You can choose your own values here and even use ranges.  
You can always change ports on the host side as you wish.  
If you change ports on the container side, you also need to set them correctly  
in deluged and deluge-web preferences.    

`-p 50400:58846`  
You will now be able to connect to the daemon with gtkui client on port 50400.  

`-p 443:8112`  
You will now be able to connect to deluge web interface by pointing your browser to:  
https://your.docker.host

`-v v_deluge_config:/opt/deluge/config`  
This mounts your containers config directory with configuration files,  
logs and ssl certificates to a named docker volume v_deluge_config  
(usually at /var/lib/docker/volumes).  

`-v /path/to/downloads:/opt/deluge/downloads`  
This mounts the downloads dir from your container to a custom location.  
Make sure the location already exists.

`-v /path/to/complete:/opt/deluge/complete`  
Same as above, but for complete directory. If you are using a cow file system  
it might be useful to have downloads and complete on separate pools and  
"move completed" enabled inside deluge.

`-e TZ=America/Costa_Rica`  
Set the [timezone](https://en.wikipedia.org/wiki/Tz_database).

`-e D_UID:1000 -e D_GID:1000`  
User and group id of the user running deluged and deluge-web. All files downloaded by deluged  
will be owned by that user. 1000 is the default id of the first "human" user   
on debian/ubuntu/rhel7. You can see your id by typing *id* inside of a terminal.

`-e D_D_UMASK=002`  
Umask for deluged.  

`--restart=unless-stopped`  
Docker's restart policy. unless-stopped means that docker will always  
restart this container (e.g. after a host restart), unless you stopped it with  
*docker stop c_deluged*.

`sinaptika/deluge`  
Name of the image on which we will base the whole container.

The whole command:  
`docker create \`  
`--name c_deluge \`  
`-p 50200:50100 \`  
`-p 50300:50100/udp \`  
`-p 50400:58846 \`  
`-p 443:8112`  
`-v v_deluged_config:/opt/deluge/config \`  
`-v /path/to/downloads:/opt/deluge/downloads \`  
`-v /path/to/complete:/opt/deluge/complete \`  
`-e TZ=America/Costa_Rica \`  
`-e D_UID:1000 -e D_GID:1000 \`  
`-e D_D_UMASK=002`  
`--restart=unless-stopped \`  
`sinaptika/deluge`

#### Notes:
Don't use *--net host* on *docker create*, unless you know what you are doing.  
If you are using more than one interface with deluge, add docker network to container.  
Macvlan works great, so does ipvlan (but ipvlan is not yet included in docker stable).  
If you are having problems with file permission, check *-e D_UID=* and *-e D_D_UMASK=*  
If you are using only the web interface for accessing deluged, you don't need to  
expose port 58846 on the host.  
If building this image locally, don't forget that compiling latest libtorrent  
will take some time even on modern hw.  
For proxying just deluge-web don't use Apache or Nginx, it's overkill. Try caddy?  
If you are proxying more containers on your host, try traefik? Both support letsencrypt.  
If you are using dockerfile labels (docker-gen, etc), you can remove/change existing ones.  
All of the above is ofc just an opinion and ymmv.

**For a complete deluge docker image, consider using deluge images.**  
[deluge github](https://github.com/git-sinaptika/deluge)  
[deluge dockerhub](https://hub.docker.com/r/sinaptika/deluge/)  

**For advance uses or more customization, consider using separate images for deluged and deluge-web.**  
[deluged github](https://github.com/git-sinaptika/deluged)  
[deluged dockerhub](https://hub.docker.com/r/sinaptika/deluged/)  
[deluge-web github](https://github.com/git-sinaptika/deluge-web)  
[deluge-web dockerhub](https://hub.docker.com/r/sinaptika/deluge-web/)  

#### Changelog for deluge, deluged and deluge-web:  
**0.1**  
- supervisor integration  
  - umask and user done
  - passing variables to entrypoint and supervisor done  

**0.2**  
- fixing typos in readme, some basic editing in dockerfile
  - starting to unify structure/style in deluged, deluge-web and deluge images  

**0.3**
- downgraded libtorrent to 1.0.11 for stable, latest, and 1.3.15 tags
- added dev and stable

**0.4**
- Changed to multi-stage build and ssl force on deluge-web

**0.5**
- Dir strcuture changes on github and tag changes on docker hub
- Some syntax changes
- Added first run with debug for deluge-web