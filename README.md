# Quick Run
1. **Run the Container:**
   ```bash
   docker run -d -p 127.0.0.1:2222:2222 -v /tmp/.X11-unix:/tmp/.X11-unix  --name=cv-ssh --restart=unless-stopped --hostname=cv-ssh jartis/cv-ssh:latest
   ```
   Ensure X11 is running on your host system and accepts external sources (`xhost +`).
2. **Connect to the Container:**
   ```bash
   ssh -X -p2222 cv@127.0.0.1
   ```
   Password `cv`.


# **Description:**
The `cv-ssh` Docker image, based on Ubuntu 22.04, is a powerful tool for remote image processing and computer vision tasks. It comes pre-installed with OpenCV 4.8.1, the leading library for computer vision, along with essential tools like git, SSH server, tmux, and more. The image is configured for quick deployment and ease of use, allowing users to jump straight into their projects.

## **Key Features:**
- **OpenCV 4.8.1 Ready**: Out-of-the-box support for the latest OpenCV for advanced image processing.
- **SSH Server Setup**: Secure SSH access for remote operation and file transfers.
- **User-Friendly Environment**: Comes with tools like vim, bmon, htop, and mc for convenient system management.
- **Supervisor Support**: Supervisord for process control, ensuring services stay up and running.

# **How to Run:**
1. Pull the image from Docker Hub.
2. Run the container with port 2222 exposed for SSH access.
3. Connect via SSH using the predefined user credentials (username: `cv`, password: `cv`).

## **On Linux:**
1. **Build the Image:**
   ```bash
   docker build --tag cv-ssh:latest .
   ```
2. **Run the Container:**
   ```bash
   docker run -d -p 2222:2222 -v /tmp/.X11-unix:/tmp/.X11-unix  --name=cv-ssh --restart=unless-stopped --hostname=cv-ssh cv-ssh:latest
   ```
   Ensure X11 is running on your host system and accepts external sources (`xhost +`).
3. **Connect to the Container:**
   ```bash
   ssh -X -p2222 cv@127.0.0.1
   ```

Optional: **Secure with SSH Private Key:**
 1. **Get Key:**
       ```bash
       sudo docker logs cv-ssh | awk '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/'
       ```

2. **Disable password login:**

        Edit `/etc/ssh/sshd_config` and set `PasswordAuthentication no`, restart container.

## **On Windows (Using Xming X Server):**
1. Install [Xming X Server](https://sourceforge.net/projects/xming/).
2. Launch Xming and allow public access (be cautious about security implications).
3. Set up your environment to use X11 forwarding. This usually involves setting the `DISPLAY` environment variable to your local IP address. For example: `set DISPLAY=your_ip:0.0`.
4. Follow the same steps to build and run the Docker container as on Linux.
5. Connect via SSH to the container using an SSH client that supports X11 forwarding, such as PuTTY, and ensure X11 forwarding is enabled in the SSH client settings.

# **Repository**

[Github](https://github.com/JartisOfficial/cv-ssh)
