# simple-tor-static-site-docker-image

> [!IMPORTANT]  
> This is very simple experimental image, please refer https://community.torproject.org/onion-services/advanced/opsec/ for best practices. 

## clone the repo

```
♪ git clone https://github.com/imthor/simple-tor-static-site-docker-image.git
♪ cd simple-tor-static-site-docker-image
```
## create a directory to store your private key generated
I'm creating a directory called `.secret` here in the same directory. 
Please note that the container will write `hostname`, `hs_ed25519_public_key` and `hs_ed25519_secret_key` to this folder when it runs for the first time. Please ensure that this is securely stored.
On subsequent runs, the image will read from this location and restart the onion service on the same hostname.

If you get a custom hostname ([Vanity Address](https://community.torproject.org/onion-services/advanced/vanity-addresses/) created for your service, you can place the corresponding `private_key` files in the `.secret` location and the service should start at that address. 

```
♪ mkdir .service
```

## build the image

```
♪ docker build -t simple-tor-static-site-docker-image .
```

## run the image 
If you make any changes to the image, make sure to change the volumes we're binding here with `-v` according to the changes you have made.
```
♪ docker run -d -v "${PWD}/hiddenservice:/var/www/hiddenservice" -v "${PWD}/.secret:/secret" --name sample_tor_service simple-tor-static-site-docker-image
8e32cfb22f8b6d639b82e92f9dec8867c8301db98543393884fedf5fc5fdbde4
♪
```
## get the service address
You should see the path to your onion service in the `hostname` file. You can open this in Tor Browser to see your live website. 
```
♪ cat .secret/hostname
XXXX5a5bjh6q5ij3ql6j267qou5iqx7k44zsyd.onion
♪
```


