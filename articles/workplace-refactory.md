# Workplace Refactory

## differentiating the workplace of yours from the workplace of your workplace's

After several conflicts among python packages, migrations from databases to databases, and messes of staled scripts and abandoned services thrown and appearing everywhere, I finnally realize that **my workplace is nothing more than an interface interacting directly with me myself. Anything other than that belongs to the workplace of my workplace, which ought to be pluginable, isolated, and in centralized managament.**

Take `nginx` as an example. When I develop something related to `nginx` I would edit the `nginx.conf` file and start `nginx` service. In this situation only `nginx.conf` is what I really care about. So `nginx.conf` file itself and my editor `vim` are in my workplace here. In the meantime `nginx` is only a service for testing purpose running underground, which I regard as a component of the workplace of my workplace. Therefor `nginx` should be abstracted from my workplace and placed in containers like `docker`.

## manage the workplace of the workplace's with containers

Mentioned as above, I use `docker` to manage all services standalone or composed like `postgresql`, `redis`, `openresty`, `django with mongodb`, `telegraf with kafka`, etc.
When I want to use the client tools of some servers I'll still use `docker` to run a container to achieve it.

But it is not flexible to build images again and again if the reliances of your runtime like `python` changes frequently. To deal with this problem I use `vagrant` with 3 DIYed boxes which I can modify easily at anytime to maintain the environments for `python`, `go` and `node` respectively. So that I can compile and run the programme in the specific virtual machine out of my host environment after coding in shared folders.

## the workplace of mine is now left neat and tidy

After identifying and migrating the components of the workplace of my workplace, what I really installed is only:

1. tools I use directly like `homebrew`, `git`, and `vim`;
2. `docker` and `vagrant` to put this system into practise.

## what else can I benefit from this

*TODO*: After uploading all the `Vagrantfile`s and `docker-compose.yaml`s to cloud storages like `OneDriver` (can be encrypted with `encFS`) one can got a consistent environment on different computers (and different operating systems).
