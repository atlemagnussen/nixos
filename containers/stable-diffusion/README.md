# Stable diffusion

## Test Nvidia-docker-toolkit
```sh
docker run --rm -it --device=nvidia.com/gpu=all ubuntu:latest nvidia-smi
````


https://github.com/Sharrnah/stable-diffusion-docker


https://github.com/AbdBarho/stable-diffusion-webui-docker/blob/master/docker-compose.yml


try extract docker command from this

```sh
docker run --device=nvidia.com/gpu=all \
-p 7860:7860 \
-v ./data:/data \
-v ./output/:/output/ \
-e CLI_ARGS="--allow-code --medvram --xformers --enable-insecure-extension-access --api" \
sd-auto:78
```

https://github.com/kestr31/docker-stable-diffusion-webui/blob/main/compose.yml

build
```sh
./scripts/build.sh stable-diff 12.6.0
```

run, create workspace dir 
first `/mnt/md0/stable-diffusion-workspace`

checkout webui latest version into workspace
```sh
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git \
    /mnt/md0/stable-diffusion-workspace/stable-diffusion-webui -b v1.10.1
```

```sh
docker run --rm -it --device=nvidia.com/gpu=all \
--name docker-stable-diffusion-webui \
-p 7860:7860 \
-v /mnt/md0/stable-diffusion-workspace/stable-diffusion-webui:/home/user/workspace \
stable-diff:1.3.0-12.6.0 
```

## find models

https://github.com/stability-ai/generative-models