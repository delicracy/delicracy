# Install and Setup

## MongoDB
Follow the introduction of official site.
[Install MongoDB Community Edition on Ubuntu](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/)

## Linuxbrew
[Linuxbrew](linuxbrew.sh) is the package manager on Linux like Homebrew.

``` bash
sudo apt-get install build-essential curl file git python-setuptools
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> ~/.bash_profile
echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >> ~/.bash_profile
echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >> ~/.bash_profile
    
brew install gcc
```

## Ruby 2.4.1(or 2.4.3)
```bash
brew install ruby-install chruby # Ruby version manager
ruby-install 2.4.1
chruby 2.4.1
echo "ruby-2.4.1" > ~/.ruby-version
```

## Rails 5.1.4
```bash
gem install rails -v 5.1.4 -N
```

## Setup App
At project root's path,
```bash
brew install imagemagick # image processing tool
bundle install # install required gems.
rails db:setup # prepare database.
```

## Start the Rails server
```bash
rails server
```

# Contact
If you want to get in touch with us, send an email: [kjoonk@governtech.io](mailto:kjoonk@governtech.io)
