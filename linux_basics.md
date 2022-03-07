# EBD Server and Linux Basics

For my TFM I am using the high performance computing facility of the Biological Station of Doñana (EBD-CSIC).

This facility has the following specification:

* CentOS Linux release 7.3.1611 (Core)
* 64 cores
* CPU Intel Xeon CPU E7-8891 v3 @ 2.80GHz
* 480Gb RAM



## Connecting to the server
To connect to the server, I need to be inside the EBD network (either physically or via VPN) and connect via SSH:

```{bash}
ssh <user.name>@genomics-a.ebd.csic.es
```

## Navigation

Below are some basic linux commands to navigate the server

```{bash}
# see where I am
pwd

# move around (change directory):
cd

# short cuts for going back to my home directory:
cd ~/
cd $HOME

# make a folder:
mkdir <new_directory>

# make a text file:
touch <new_file>.txt

# see the first or last lines of a file
head <file>
tail <file>

# see a whole file
cat file

# see compressed file
zcat <file>

# see only the first lines of a compressed ile:

zcat <file> | head

```

## Copying files and make alias

```{bash}
# copy a file
cp <old_file> <new_file>

# copy directory (a recursive copy)
cp -r <old_directory> <new_directory>

# make a symbolic link
ln -s <old_file> <new_file>
```

