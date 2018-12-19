# ProtonMail Bridge

## Build:

 - obtain PKGBUILD from ProtonMail. You can ask at bridge@protonmail.ch
 - run `make`
 - done

## Run:

Like this:

```bash
docker run --rm -p 25:25 -p 143:143 -e EMAIL=<MY_SUPER_EMAIL> -e PASSWORD=<MY_SUPER_PASSWORD> -v protonvol:/home/proton --name proton-bridge -d t4cc0re/protonmail-bridge:latest
```

## Use:

Just wait a few secs. Get the credentials via `docker logs proton-bridge` and hammer them into your mail client/app.
Be aware of the port bindings above. It is world accessable. Please read-up on port bindings.

