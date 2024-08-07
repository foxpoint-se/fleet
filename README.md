# Fleet

Stack for handling stuff related to IoT things.

## Getting started

Run `make` to get all possible commands. At the moment of writing the available commands are:

```bash
add-robot                      print how to add robot
deploy                         deploy web app
setup                          install and setup everything for development
```

TODO:

- lägg till fler make targets
- lägg till dom här i readme
- skript för att installera ssm agent
- stoppa agent innan register, se nedan

sudo service amazon-ssm-agent stop
sudo amazon-ssm-agent -register -code "REDACTED" -id "REDACTED" -region "eu-west-1"
sudo service amazon-ssm-agent start

får fortfarande problem med att den rollen inte får hämta secrets.
men get-caller-identity säger att det är jag
hur säger man att det är jag?
kan ju också ge tillåtelse för den rollen att läsa. men är det rätt?
