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

# see folders and files
ls

# make a folder:
mkdir <new_directory>

# make a text file:
touch <new_file>.txt
nano <new_file>.txt

# see the first or last lines of a file
head <file>
tail <file>

# see a whole file
cat file

# see compressed file
zcat <file>

# see only the first lines of a compressed ile:
zcat <file> | head

# see lines with a concrete word or symbol
cat <file> | grep ">"

# count lines
cat <file> | grep -c ">"

# give permissions
chmod <777(rwx/rwx)/755(rwx/rw)> <file>
```

## Copying, moving and removing files and make alias

```{bash}
# copy a file
cp <old_file> <new_file>

# copy directory (a recursive copy)
cp -r <old_directory> <new_directory>

# copy parts of a file (example with head)
cat <file_to_copy> | head -n 1000 > <path>/<name_of_new_file>

# make a symbolic link
ln -s <old_file> <new_file>

# move a file
mv <file> <new_folder>

# remove a file
rm <file>

# remove a folder and its content
rm -r <folder>
```


## Installing packages

```{bash}
# download from link
wget <link_to_the_file>

# install the file downloaded
bash <file> -u
```

## Environment and screens

```{bash}
# create an environment in conda 4.10.3 (to install your specific versions of programs)
conda create --name <name_of_environment>

# activate environment
conda activate <name_of_environment>

# create an screen (to run programms in background)
screen -S <name_of_screen>

# list screens
screen -list

# access to a screen 
screen -r <name and/or number>

# leaving a screen
ctrl+a ctrl+d

#closing a screen
exit
```


## Running control

```{bash}
# stop a program
ctrl+z

# sending to background
bg

# sending to foreground
fg

# list of running programs
htop
top
```
